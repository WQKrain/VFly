//
//  VFGetPayMoneyModel.m
//  VFly
//
//  Created by Hcar on 2018/4/13.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFGetPayMoneyModel.h"

@implementation VFGetPayMoneyModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.item = dic[@"item"];
        self.canDiscountMoney = kFormat(@"%@", dic[@"canDiscountMoney"]);
        self.unPayedMoney = kFormat(@"%@", dic[@"unPayedMoney"]);
        self.created_at =  kFormat(@"%@", dic[@"created_at"]);
        self.should_pay_id = kFormat(@"%@", dic[@"should_pay_id"]);
        self.is_score = kFormat(@"%@", dic[@"is_score"]);
        self.is_coupon = kFormat(@"%@", dic[@"is_coupon"]);
        self.handler = dic[@"handler"];
        self.real_money = dic[@"real_money"];
    }
    return self;
}

@end
