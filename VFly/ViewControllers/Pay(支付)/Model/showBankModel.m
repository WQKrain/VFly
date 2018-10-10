//
//  showBankModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/8/4.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "showBankModel.h"

@implementation showBankModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.list = dic[@"list"];
    }
    return self;
}


@end

@implementation showBankListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.icon = dic[@"icon"];
        self.bank = dic[@"bank"];
        self.singleLimit = dic[@"singleLimit"];
        self.dayLimit = dic[@"dayLimit"];
        self.brief = dic[@"brief"];
    }
    return self;
}

@end
