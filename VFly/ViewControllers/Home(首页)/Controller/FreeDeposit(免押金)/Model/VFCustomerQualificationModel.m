//
//  VFCustomerQualificationModel.m
//  LuxuryCar
//
//  Created by Hcar on 2018/2/1.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFCustomerQualificationModel.h"

@implementation VFCustomerQualificationModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.qualification_status = dic[@"qualification_status"];
        self.qualification = dic[@"qualification"];
    }
    return self;
}

@end

@implementation VFCustomerQualificationDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.credit_line = dic[@"credit_line"];
        self.freezing = dic[@"freezing"];
        self.available = dic[@"available"];
        self.total_deductions = dic[@"total_deductions"];
        self.used_times = dic[@"used_times"];
        self.mobile = dic[@"mobile"];
        self.id_card = dic[@"id_card"];
        self.bankcard = dic[@"bankcard"];
        self.name = dic[@"name"];
        self.house_property = dic[@"house_property"];
        self.car_property = dic[@"car_property"];
        self.other_property = dic[@"other_property"];
        self.id_card_face = dic[@"id_card_face"];
        self.id_card_back = dic[@"id_card_back"];
        self.driving_licence = dic[@"driving_licence"];
        self.expired_at = dic[@"expired_at"];
    }
    return self;
}

@end

