//
//  VFRenewMapModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/16.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFRenewMapModel.h"

@implementation VFRenewMapModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.dayRental = dic[@"dayRental"];
        self.vipZk = dic[@"vipZk"];
        self.level = dic[@"level"];
    }
    return self;
}

@end

@implementation VFRenewMapLevelModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.minDay = dic[@"minDay"];
        self.maxDay = dic[@"maxDay"];
        self.zk = dic[@"zk"];
    }
    return self;
}

@end

