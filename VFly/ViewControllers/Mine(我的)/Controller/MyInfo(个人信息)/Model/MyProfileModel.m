//
//  MyProfileModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MyProfileModel.h"

@implementation MyProfileModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.creditList = dic[@"creditList"];
    }
    return self;
}


@end

@implementation MyProfileListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.info = dic[@"key"];
        self.status = dic[@"status"];
        self.data = dic[@"model"];
    }
    return self;
}


@end

