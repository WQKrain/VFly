//
//  MyOrderModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MyOrderModel.h"

@implementation MyOrderModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.orderList = dic[@"orderList"];
        self.hasMorePages = dic[@"hasMorePages"];
    }
    return self;
}

@end

@implementation MyPickUpOrderModel
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.shuttles = dic[@"shuttles"];
        self.hasMorePages = dic[@"hasMorePages"];
    }
    return self;
}

@end


@implementation MyOrderListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.orderId = dic[@"orderId"];
        self.status = dic[@"status"];
        self.statusText = dic[@"statusText"];
        self.type = dic[@"type"];
        self.typeText = dic[@"typeText"];
        self.orderTime = dic[@"orderTime"];
        self.carModel = dic[@"model"];
        self.cover = dic[@"cover"];
        self.useStartTime = dic[@"useStartTime"];
        self.useEndTime = dic[@"useEndTime"];
        self.year = dic[@"year"];
        self.brand = dic[@"brand"];
        self.expire = dic[@"expire"];
        self.getCarCity = dic[@"getCarCity"];
        self.returnCarCity = dic[@"returnCarCity"];
        self.totalPrice = dic[@"totalPrice"];
        self.days = dic[@"days"];
        self.canRenew = dic[@"canRenew"];
        self.isEvaluation = dic[@"isEvaluation"];
        self.canPay = dic[@"canPay"];
        self.dayRental = dic[@"dayRental"];
        self.canDel = dic[@"canDel"];
    }
    return self;
}


@end


