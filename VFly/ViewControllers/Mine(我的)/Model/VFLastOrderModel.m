//
//  VFLastOrderModel.m
//  VFly
//
//  Created by Hcar on 2018/4/17.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFLastOrderModel.h"

@implementation VFLastOrderModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.brand = dic[@"brand"];
        self.model = dic[@"model"];
        self.car_img = dic[@"car_img"];
        self.re_day_rental = dic[@"re_day_rental"];
        self.status = dic[@"status"];
        self.status_text = dic[@"status_text"];
        self.order_id = dic[@"order_id"];
        
    }
    return self;
}

@end
