//
//  BaseRequestSerivce.m
//  VFly
//
//  Created by 毕博洋 on 2018/8/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "BaseRequestSerivce.h"

@implementation BaseRequestSerivce

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

//  设置json数据格式请求
- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (void)requestWithSuccess:(successBlock)success failure:(failureBlcok)failure {
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}





@end
