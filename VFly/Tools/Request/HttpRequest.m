//
//  HttpRequest.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/2.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "HttpRequest.h"
#import "HCBaseMode.h"

//#define kNewBaseApi         api_root
@implementation HttpRequest


//请求连连支付三方接口
+(void)thirdUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //内容类型
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    manager.requestSerializer.timeoutInterval = 15;
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error:nil];
        success (tempDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);
    }];
}

//GET请求
+(void)getWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    //创建请求管理者
    NSString *urlStr = kFormat(@"%@%@", kNewBaseApi,urlString);
//    AFHTTPSessionManager * manager = [[self class] getCustomHttpsPolicyWithUrlStr:urlStr];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
    manager.requestSerializer.timeoutInterval = 30.f;
    //get请求
    [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error:nil];
        success (tempDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);
    }];
}

//POST请求
+(void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    //创建请求管理者
    NSString *urlStr = kFormat(@"%@%@", kNewBaseApi,urlString);
    NSLog(@"___________________%@",urlStr);
    AFHTTPSessionManager * manager = [[self class] getCustomHttpsPolicyWithUrlStr:urlStr];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error:nil];
        success (tempDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);
    }];
}

//上传文件
+(void)uploadFile:(NSString *)urlString image:(NSData *)image success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSString *urlStr = kFormat(@"%@%@", kNewBaseApi,urlString);
    AFHTTPSessionManager * manager = [[self class] getCustomHttpsPolicyWithUrlStr:urlStr];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
    
    manager.requestSerializer.timeoutInterval = 30.f;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"userHeader.png", @"file",nil];
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:image name:@"file" fileName:@"userHeader.png" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error:nil];
        success (tempDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);
    }];
}



+ (AFHTTPSessionManager *)getCustomHttpsPolicyWithUrlStr:(NSString *)urlStr
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;      //是否允许使用¥
    securityPolicy.validatesDomainName = NO;           //是否需要验证域名
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    __weak typeof(AFHTTPSessionManager) *weakManager = manager;
    
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
        
        /// 获取服务器的trust object
        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
        // 导入自签名证书
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"appSSL" ofType:@"cer"];
        NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
        if (!caCert) {
            DLog(@" ===== .cer file is nil =====");
            return 0;
        }
        NSSet *cerSet = [NSSet setWithObjects:caCert, nil];
        weakManager.securityPolicy.pinnedCertificates = cerSet;
        
        SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
        
        
        NSCAssert(caRef != nil, @"caRef is nil");
        NSArray *caArray;
        
        #ifdef DEBUG
        
        //测试证书
        SecCertificateRef apiRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"devweifengchuxingcom" ofType:@"cer"]]);
        
        SecCertificateRef rootRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SymantecBasicDVSSLCA-G1" ofType:@"cer"]]);
        
        SecCertificateRef symantecRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"VeriSignClass3PublicPrimaryCertificationAuthority-G5" ofType:@"cer"]]);
        
        caArray = @[(__bridge id)(caRef),(__bridge id)(apiRef),(__bridge id)(rootRef),(__bridge id)(symantecRef)];
        #else
        
        //发布证书
        SecCertificateRef  disApiRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"oaweifengchuxingcom" ofType:@"cer"]]);
        
        SecCertificateRef disRootRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"disSymantecBasicDVSSLCA-G1" ofType:@"cer"]]);
        
        SecCertificateRef disSymantecRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"disVeriSignClass3PublicPrimaryCertificationAuthority-G5" ofType:@"cer"]]);
        
        caArray = @[(__bridge id)(caRef),(__bridge id)(disApiRef),(__bridge id)(disRootRef),(__bridge id)(disSymantecRef)];
        #endif
    
        NSCAssert(caArray != nil, @"caArray is nil");
        // 将读取到的证书设置为serverTrust的根证书
        OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
        SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
        NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
        //选择质询认证的处理方式
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential = nil;
        
        //NSURLAuthenticationMethodServerTrust质询认证方式
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            //基于客户端的安全策略来决定是否信任该服务器，不信任则不响应质询。
            if ([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                //创建质询证书
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                //确认质询方式
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                //取消挑战
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
        return disposition;
    }];
    
    return manager;
}


@end
