//
//  CityModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/8/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cityId = dic[@"id"];
        self.child = dic[@"child"];
        self.name = dic[@"name"];
    }
    return self;
}

    
@end
