//
//  BananaDetailModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BananaDetailModel.h"

@implementation BananaDetailModel
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.logList = dic[@"logList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}

@end

@implementation BananaDetailListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.change = dic[@"change"];
        self.logId = dic[@"id"];
        self.cid = dic[@"cid"];
        self.createTime = dic[@"createTime"];
        self.des = dic[@"des"];
    }
    return self;
}


@end
