//
//  BaseRequestSerivce.h
//  VFly
//
//  Created by 毕博洋 on 2018/8/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "YTKBaseRequest.h"
/*
 typedef void(^ successBlock)(NSDictionary *responseDict);
 typedef void(^ failureBlock)(__kindof YTKBaseRequest *request);
 */

typedef void(^ successBlock)(NSDictionary *resposeDictionary);
typedef void(^ failureBlcok)(__kindof YTKBaseRequest *request);

@interface BaseRequestSerivce : YTKBaseRequest

//  发起网络请求
- (void)requestWithSuccess:(successBlock)success failure:(failureBlcok)failure;


@end
