//
//  VipModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/26.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VipModel.h"

@implementation VipModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
//        self.status = dic[@"status"];
//        self.vip = dic[@"vip"];
        self.vipList = dic[@"vipList"];
    }
    return self;
}


@end

@implementation VipListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.level = dic[@"level"];
        self.text = dic[@"text"];
        self.price = dic[@"price"];
        self.imageGood = dic[@"imageGood"];
        self.imageMain = dic[@"imageMain"];
        self.zk = dic[@"zk"];
        self.freeDays = dic[@"freeDays"];
        self.useKm = dic[@"useKm"];
        self.sendKm = dic[@"sendKm"];
        self.birthdayZk = dic[@"birthdayZk"];
        self.scorePoint = dic[@"scorePoint"];
        self.usablePrice = dic[@"usablePrice"];
    }
    return self;
}

@end
