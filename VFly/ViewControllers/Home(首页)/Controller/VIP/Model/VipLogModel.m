//
//  VipLogModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VipLogModel.h"

@implementation VipLogModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.remainder = dic[@"remainder"];
        self.logList = dic[@"logList"];
    }
    return self;
}
@end

@implementation VipLogListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.change = dic[@"change"];
        self.markid = dic[@"id"];
        self.cid = dic[@"cid"];
        self.createTime = dic[@"createTime"];
        self.des = dic[@"des"];
        self.balance = dic[@"balance"];
    }
    return self;
}


@end
