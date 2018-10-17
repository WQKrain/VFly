//
//  VFHttpManage.m
//  VFly
//
//  Created by Hcar on 2018/4/4.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFHttpManage.h"

@implementation VFHttpManage

//GET请求
+(void)getWithUrlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
                success:(HttpSuccess)success
                failure:(HttpFailure)failure{
    //创建请求管理者
    NSString *urlStr = kFormat(@"%@%@",kNewBaseApi,urlString);
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>\n%@",urlStr);
    
    AFHTTPSessionManager * manager = [self getCustomHttpsPolicyWithUrlStr:urlStr];
    
    manager.requestSerializer.timeoutInterval = 5.0f;

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
    NSString *urlStr = kFormat(@"%@%@",kNewBaseApi,urlString);
    
    AFHTTPSessionManager * manager = [self getCustomHttpsPolicyWithUrlStr:urlStr];
    
    manager.requestSerializer.timeoutInterval = 5.0f;

    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error:nil];

        success (tempDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure (error);

    }];
    
}

//PUT请求
+(void)putWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    //创建请求管理者
    NSString *urlStr = kFormat(@"%@%@",kNewBaseApi,urlString);
    AFHTTPSessionManager * manager = [self getCustomHttpsPolicyWithUrlStr:urlStr];
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager PUT:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error:nil];
        success (tempDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);

    }];
}

//DELETE请求
+(void)deleteWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    //创建请求管理者
    NSString *urlStr = kFormat(@"%@%@",kNewBaseApi,urlString);
    AFHTTPSessionManager * manager = [self getCustomHttpsPolicyWithUrlStr:urlStr];
    [manager DELETE:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error:nil];
        success (tempDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);

    }];
}

//上传文件
+(void)uploadFile:(NSString *)urlString image:(NSData *)image success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSString *urlStr = kFormat(@"%@%@",kNewBaseApi,urlString);
    AFHTTPSessionManager * manager = [[self class] getCustomHttpsPolicyWithUrlStr:urlStr];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"userHeader.png", @"file",nil];
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:image name:@"file" fileName:@"userHeader.png" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error:nil];
        success (tempDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token)
    {
        [manager.requestSerializer setValue:kFormat(@"Bearer %@", token)  forHTTPHeaderField:@"Authorization"];
    }
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:@"application/x.VFLY.v2+json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.timeoutInterval = 15.f;
    return manager;
}

@end
