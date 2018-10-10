//
//  couponModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/20.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "couponModel.h"

@implementation couponModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.couponList = dic[@"couponList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}

@end

@implementation newCouponListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.listID = dic[@"id"];
        self.money = dic[@"money"];
        self.mk = dic[@"mk"];
        self.startTime = dic[@"create_time"];
        self.endTime = dic[@"end_time"];
        self.text = dic[@"text"];
        self.style = dic[@"style"];
    }
    return self;
}

@end


@implementation couponListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.listID = dic[@"id"];
        self.money = dic[@"money"];
        self.mk = dic[@"mk"];
        self.startTime = dic[@"startTime"];
        self.endTime = dic[@"endTime"];
        self.startTimestamp = kFormat(@"%@", dic[@"startTimestamp"]);
        self.endTimestamp = kFormat(@"%@", dic[@"endTimestamp"]);;
        self.text = dic[@"text"];
        self.style = dic[@"style"];
    }
    return self;
}

@end

@implementation chooseCouponListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cardID = dic[@"id"];
        self.money = dic[@"money"];
        self.mk = dic[@"mk"];
        self.startTimestamp = dic[@"create_time"];
        self.endTimestamp = dic[@"end_time"];
        self.text = dic[@"text"];
        self.useable = dic[@"useable"];
        self.usableCount = dic[@"usableCount"];
        self.style = dic[@"style"];
    }
    return self;
}

@end



