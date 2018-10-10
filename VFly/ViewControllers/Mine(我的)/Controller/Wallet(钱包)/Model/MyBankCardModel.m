//
//  MyBankCardModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/17.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MyBankCardModel.h"

@implementation MyBankCardModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.bankCardList = dic[@"bankCardList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}

@end


@implementation MyBankCardListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.bank = kFormat(@"%@", dic[@"bank"]);
        self.name = dic[@"name"];
        self.cardType = kFormat(@"%@", dic[@"cardType"]);
        self.bankCard = kFormat(@"%@", dic[@"bankcard"]);
        self.createTime = dic[@"createTime"];
        self.carId = kFormat(@"%@", dic[@"id"]);
        self.icon = dic[@"icon"];
        self.mobile = kFormat(@"%@", dic[@"mobile"]);
        self.card = kFormat(@"%@", dic[@"card"]);;
        self.singleLimit = dic[@"singleLimit"];
        self.dayLimit = dic[@"dayLimit"];
        self.monthLimit = dic[@"dayLimit"];
        self.brief = dic[@"brief"];
        self.backImage = dic[@"backImage"];
    }
    return self;
}


@end
