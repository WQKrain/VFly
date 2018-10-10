//
//  VFGetOrderMoneyModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/23.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFGetOrderMoneyModel.h"

@implementation VFGetOrderMoneyModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.money = dic[@"money"];
        self.expire = dic[@"expire"];
        self.canDiscountMoney = dic[@"canDiscountMoney"];
    }
    return self;
}

@end
