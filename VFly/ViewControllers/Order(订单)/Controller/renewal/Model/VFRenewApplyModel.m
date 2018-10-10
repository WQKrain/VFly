//
//  VFRenewApplyModel.m
//  VFly
//
//  Created by Hcar on 2018/4/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFRenewApplyModel.h"

@implementation VFRenewApplyModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.order_id = dic[@"order_id"];
        self.should_pay_id = dic[@"should_pay_id"];
        self.money = dic[@"money"];
    }
    return self;
}

@end
