//
//  VipOrderModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VipOrderModel.h"

@implementation VipOrderModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.orderId = dic[@"orderId"];
        self.money = dic[@"money"];
    }
    return self;
}


@end
