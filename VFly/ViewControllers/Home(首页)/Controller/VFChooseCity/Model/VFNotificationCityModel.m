//
//  VFNotificationCityModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFNotificationCityModel.h"

@implementation VFNotificationCityModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cityID = dic[@"cityID"];
        self.cityName = dic[@"cityName"];
        self.countyID = dic[@"countyID"];
        self.countyName = dic[@"countyName"];
        self.provinceName = dic[@"provinceName"];
        self.provinceID = dic[@"provinceID"];
    }
    return self;
}

@end
