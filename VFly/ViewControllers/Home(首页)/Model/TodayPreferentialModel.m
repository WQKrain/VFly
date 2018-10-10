//
//  TodayPreferentialModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/4.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "TodayPreferentialModel.h"

@implementation TodayPreferentialModel
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.discountList = dic[@"discountList"];
    }
    return self;
}
@end

@implementation TodayPreferentialListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.nowPrice = dic[@"nowPrice"];
        self.costPrice = dic[@"costPrice"];
        self.carId = dic[@"carId"];
        self.startTime = dic[@"startTime"];
        self.endTime = dic[@"endTime"];
    }
    return self;
}
@end
