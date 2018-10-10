//
//  DrawMoneyModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "DrawMoneyModel.h"

@implementation DrawMoneyModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cardInfo = dic[@"cardInfo"];
        self.times = dic[@"times"];
        self.money = dic[@"money"];
    }
    return self;
}


@end


@implementation DrawMoneyCardListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.icon = dic[@"icon"];
        self.cardId = dic[@"id"];
        self.bank = dic[@"bank"];
        self.card = dic[@"card"];
    }
    return self;
}
@end
