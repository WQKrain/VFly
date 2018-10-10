//
//  VFAvailableCouponsModel.m
//  VFly
//
//  Created by Hcar on 2018/4/14.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFAvailableCouponsModel.h"

@implementation VFAvailableCouponsModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.couponsID = dic[@"id"];
        self.useable = dic[@"useable"];
        self.create_time = dic[@"create_time"];
        self.end_time = dic[@"end_time"];
        self.money = dic[@"money"];
        self.mk = dic[@"mk"];
        self.text = dic[@"text"];
        self.style = dic[@"style"];
    }
    return self;
}

@end
