//
//  VFPaymentModel.m
//  VFly
//
//  Created by Hcar on 2018/4/27.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFPaymentModel.h"

@implementation VFPaymentModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.order_id = dic[@"order_id"];
        self.money = dic[@"money"];
        self.handler = dic[@"handler"];
        self.should_pay_id = dic[@"should_pay_id"];
    }
    return self;
}

@end
