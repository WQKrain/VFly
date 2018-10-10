//
//  VFbananaDetailModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/10.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFbananaDetailModel.h"

@implementation VFbananaDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.logDetail = dic[@"logDetail"];
    }
    return self;
}

@end

@implementation VFbananaDetailPayModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.change = dic[@"change"];
        self.logId = dic[@"id"];
        self.cid = dic[@"cid"];
        self.createTime = dic[@"createTime"];
        self.des = dic[@"des"];
        self.balance = dic[@"balance"];
    }
    return self;
}


@end
