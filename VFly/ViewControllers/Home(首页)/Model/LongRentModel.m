//
//  LongRentModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "LongRentModel.h"

@implementation LongRentModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.packageList = dic[@"packageList"];
    }
    return self;
}
@end

@implementation LongRentListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.text = dic[@"text"];
        self.minPriceText = dic[@"minPriceText"];
        self.maxPriceText = dic[@"maxPriceText"];
        self.minPrice = dic[@"minPrice"];
        self.maxPrice = dic[@"maxPrice"];
        self.packageId = dic[@"packageId"];
    }
    return self;
}
@end
