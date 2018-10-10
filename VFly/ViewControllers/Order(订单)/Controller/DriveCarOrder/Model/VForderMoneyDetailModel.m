//
//  VForderMoneyDetailModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/24.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VForderMoneyDetailModel.h"

@implementation VForderMoneyDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.days = dic[@"days"];
        self.frontMoney = dic[@"frontMoney"];
        self.rentalMoney = dic[@"rentalMoney"];
        self.depositMoney = dic[@"depositMoney"];
        self.illegalMoney = dic[@"illegalMoney"];
        self.longRentalDiscount = dic[@"longRentalDiscount"];
        self.vipDiscount = dic[@"vipDiscount"];
        self.dayRental = dic[@"dayRental"];
        self.level = dic[@"level"];
        self.vipZk = dic[@"vipZk"];
    }
    return self;
}

@end

@implementation VForderMoneyDetailLevelModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.minDay = dic[@"minDay"];
        self.maxDay = dic[@"maxDay"];
        self.zk = dic[@"zk"];
    }
    return self;
}

@end
