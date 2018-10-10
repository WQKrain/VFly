//
//  OrderDetailModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.orderId = dic[@"orderId"];
        self.status = dic[@"status"];
        self.cover = dic[@"cover"];
        self.statusText = dic[@"statusText"];
        self.type = dic[@"type"];
        self.typeText = dic[@"typeText"];
        self.orderTime = dic[@"orderTime"];
        self.brand = dic[@"brand"];
        self.year = dic[@"year"];
        self.model = dic[@"model"];
        self.useStartTime = dic[@"useStartTime"];
        self.useEndTime = dic[@"useEndTime"];
        self.getCarFunc = dic[@"getCarFunc"];
        self.name = dic[@"name"];
        self.mobile = dic[@"mobile"];
        self.getCarCity = dic[@"getCarCity"];
        self.returnCarCity = dic[@"returnCarCity"];
        self.days = dic[@"days"];
        self.frontMoney = dic[@"frontMoney"];
        self.rentalMoney = dic[@"rentalMoney"];
        self.depositMoney = dic[@"depositMoney"];
        self.illegalMoney = dic[@"illegalMoney"];
        self.frontMoneyStatus = dic[@"frontMoneyStatus"];
        self.rentalMoneyStatus = dic[@"rentalMoneyStatus"];
        self.depositMoneyStatus = dic[@"depositMoneyStatus"];
        self.illegalMoneyStatus = dic[@"illegalMoneyStatus"];
        self.totalMoney = dic[@"totalMoney"];
        self.totalMoneyStatus = dic[@"totalMoneyStatus"];
        self.expire = dic[@"expire"];
        self.paid = dic[@"paid"];
        self.unpaid = dic[@"unpaid"];
        self.passengerCounts = dic[@"passengerCounts"];
        self.carCounts = dic[@"carCounts"];
        self.address = dic[@"address"];
        self.couponMoney = dic[@"couponMoney"];
        self.scoreMoney = dic[@"scoreMoney"];
        self.freeDays = dic[@"freeDays"];
        self.dayRental = dic[@"dayRental"];
        self.isEvaluation = dic[@"isEvaluation"];
        self.canRenew = dic[@"canRenew"];
        self.payable = dic[@"payable"];
        self.vipZk = dic[@"vipZk"];
        self.vipDiscount = dic[@"vipDiscount"];
        self.longrentalZk = dic[@"longrentalZk"];
        self.longrentalDiscount = dic[@"longrentalDiscount"];
        
        self.unpaidFrontMoney = dic[@"unpaidFrontMoney"];
        self.unpaidRentalMoney = dic[@"unpaidRentalMoney"];
        self.unpaidDepositMoney = dic[@"unpaidDepositMoney"];
        self.unpaidIllegalMoney = dic[@"unpaidIllegalMoney"];
        self.canDel = dic[@"canDel"];
        self.is_free_deposit = dic[@"is_free_deposit"];
    }
    return self;
}


@end
