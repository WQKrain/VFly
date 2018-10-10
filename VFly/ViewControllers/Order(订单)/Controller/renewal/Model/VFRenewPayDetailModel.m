//
//  VFRenewPayDetailModel.m
//  VFly
//
//  Created by Hcar on 2018/4/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFRenewPayDetailModel.h"

@implementation VFRenewPayDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.order_id = dic[@"order_id"];
        self.car = dic[@"car"];
        self.re_day_rental = dic[@"re_day_rental"];
        self.start_date = dic[@"start_date"];
        self.end_date = dic[@"end_date"];
        self.days = dic[@"days"];
        self.created_at = dic[@"created_at"];
        self.should_pay_id = dic[@"should_pay_id"];
    }
    return self;
}

@end


@implementation VFRenewPayDetailCarModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.img = dic[@"img"];
        self.brand = dic[@"brand"];
        self.model = dic[@"model"];
    }
    return self;
}

@end
