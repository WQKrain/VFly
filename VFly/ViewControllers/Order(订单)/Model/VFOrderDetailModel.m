//
//  VFOrderDetailModel.m
//  VFly
//
//  Created by Hcar on 2018/4/16.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFOrderDetailModel.h"

@implementation VFOrderDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.order_id = dic[@"order_id"];
        self.status = dic[@"status"];
        self.status_text = dic[@"status_text"];
        self.canPay = dic[@"canPay"];
        self.re_rental = dic[@"re_rental"];
        self.canEvaluation = dic[@"canEvaluation"];
        self.canRenew = dic[@"canRenew"];
        self.canDel = dic[@"canDel"];
        self.money = dic[@"money"];
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
        self.unpaid = dic[@"unpaid"];
        self.useman = dic[@"useman"];
        self.sent_address = dic[@"sent_address"];
    }
    return self;
}

@end

@implementation VFOrderDetailUsemanModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.card_status = dic[@"card_status"];
        self.driving_licence_status = dic[@"driving_licence_status"];
        self.mobile = dic[@"mobile"];
        self.nick_name = dic[@"nick_name"];
        self.useman_id = dic[@"useman_id"];
    }
    return self;
}

@end

@implementation VFOrderDetailPayModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.item = dic[@"item"];
        self.lists = dic[@"lists"];
        self.payed = kFormat(@"%@", dic[@"payed"]);
        self.should_pay_id = kFormat(@"%@", dic[@"should_pay_id"]);
        self.should_pay = kFormat(@"%@", dic[@"should_pay"]);
        self.pay_type = dic[@"pay_type"];
        self.status = dic[@"status"];
    }
    return self;
}

@end

@implementation VFOrderDetailPayListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.item = dic[@"item"];
        self.order_id = dic[@"order_id"];
        self.price = kFormat(@"%@", dic[@"price"]);
        self.method = kFormat(@"%@", dic[@"method"]);
        self.created_at = dic[@"created_at"];
        self.should_pay_id = dic[@"should_pay_id"];
    }
    return self;
}

@end
