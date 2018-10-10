//
//  VFCreateOrederModel.m
//  VFly
//
//  Created by Hcar on 2018/4/19.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCreateOrederModel.h"

@implementation VFCreateOrederModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.order_id = dic[@"order_id"];
        self.should_pay_id = dic[@"should_pay_id"];
        self.item = dic[@"item"];
        self.price = dic[@"price"];
        self.rental_days = dic[@"rental_days"];
        self.re_day_rental = dic[@"re_day_rental"];
    }
    return self;
}

@end
