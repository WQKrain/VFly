//
//  IntegralModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "IntegralModel.h"

@implementation IntegralModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.logList = dic[@"logList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}

@end

@implementation IntegralListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.integralId = dic[@"id"];
        self.change = dic[@"change"];
        self.use = dic[@"use"];
        self.createTime = dic[@"createTime"];
        self.scoreBalance = dic[@"createTime"];
    }
    return self;
}


@end
