//
//  HttpRequest.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/2.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

//宏定义成功block 回调成功后得到的信息
typedef void (^HttpSuccess)(id data);
//宏定义失败block 回调失败信息
typedef void (^HttpFailure)(NSError *error);

@interface HttpRequest : NSObject

+(void)getWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

+(void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

+(void)uploadFile:(NSString *)urlString image:(NSData *)image success:(HttpSuccess)success failure:(HttpFailure)failure;

+(void)thirdUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

@end
