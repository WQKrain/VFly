//
//  VFOrderListModel.m
//  VFly
//
//  Created by Hcar on 2018/4/14.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFOrderListModel.h"

@implementation VFOrderListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.order_id = dic[@"order_id"];
        self.status = kFormat(@"%@", dic[@"status"]);
        self.status_text = dic[@"status_text"];
        self.canPay = dic[@"canPay"];
        self.canEvaluation = dic[@"canEvaluation"];
        self.canRenew = dic[@"canRenew"];
        self.canDel = dic[@"canDel"];
        
        self.start_date = dic[@"start_date"];
        self.end_date = dic[@"end_date"];
        self.rental_days = dic[@"rental_days"];
        self.get_city = dic[@"get_city"];
        self.return_city = dic[@"return_city"];
        self.get_func = dic[@"get_func"];
        self.re_day_rental = dic[@"re_day_rental"];
        self.free_deposit = dic[@"free_deposit"];
        self.car_id = dic[@"car_id"];
        self.brand = dic[@"brand"];
        self.model = dic[@"model"];
        self.car_img = dic[@"car_img"];
        self.created_at = dic[@"created_at"];
        self.should_pay_id = dic[@"should_pay_id"];
    }
    return self;
}

@end
