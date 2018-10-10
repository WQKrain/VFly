//
//  VFFreeCreditModel.m
//  VFly
//
//  Created by Hcar on 2018/4/27.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFFreeCreditModel.h"

@implementation VFFreeCreditModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.score = kFormat(@"%@", dic[@"score"]);
        self.userId = dic[@"id"];
        self.name = dic[@"name"];
        self.mobile = dic[@"mobile"];
        self.bankcard = dic[@"bankcard"];
        self.bank_mobile = dic[@"bank_mobile"];
        self.card_num = dic[@"card_num"];
        self.card_face = dic[@"card_face"];
        self.card_back = dic[@"card_back"];
        self.driving_licence = dic[@"driving_licence"];
        self.family_register = dic[@"family_register"];
        self.house = dic[@"house"];
        self.car = dic[@"car"];
        self.company = dic[@"company"];
        self.other = dic[@"other"];
    }
    return self;
}

@end
