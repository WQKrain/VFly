//
//  VFUserInfoModel.m
//  VFly
//
//  Created by Hcar on 2018/4/13.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFUserInfoModel.h"

@implementation VFUserInfoModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userId = dic[@"userId"];
        self.useman_id = dic[@"useman_id"];
        self.is_certificate = kFormat(@"%@", dic[@"is_certificate"]);
        self.is_card_real = kFormat(@"%@", dic[@"is_card_real"]);
        self.card = kFormat(@"%@", dic[@"card"]);
        self.partner = dic[@"partner"];
        self.headimg = dic[@"headimg"];
        self.token = dic[@"token"];
        self.name = dic[@"name"];
        self.money = dic[@"money"];
        self.nickname = dic[@"nickname"];
        self.score = dic[@"score"];
        self.phone = dic[@"phone"];
        self.last_use_time = dic[@"last_use_time"];
        self.last_order_time = dic[@"last_order_time"];
        self.total_pay = dic[@"total_pay"];
        self.regTime = dic[@"regTime"];
        self.nickname = dic[@"nickname"];
        self.first_login = dic[@"first_login"];
        self.cus_area = dic[@"cus_area"];
        self.cus_record = dic[@"cus_record"];
        self.cus_job = dic[@"cus_job"];
        self.cus_hobby = dic[@"cus_hobby"];
        self.order = dic[@"order"];
    }
    return self;
}

@end
