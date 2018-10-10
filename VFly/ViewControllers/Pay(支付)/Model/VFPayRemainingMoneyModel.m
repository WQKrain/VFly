//
//  VFPayRemainingMoneyModel.m
//  VFly
//
//  Created by Hcar on 2018/4/19.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFPayRemainingMoneyModel.h"

@implementation VFPayRemainingMoneyModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.order_id = dic[@"order_id"];
        self.lists = dic[@"lists"];
    }
    return self;
}

@end

@implementation VFPayRemainingMoneyListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.item = dic[@"item"];
        self.should_pay_id = dic[@"should_pay_id"];
        self.should_pay = dic[@"should_pay"];
        self.handler = dic[@"handler"];
        self.unpay = dic[@"unpay"];
    }
    return self;
}

@end
