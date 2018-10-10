//
//  VFhotCarMode.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/26.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFhotCarMode.h"

@implementation VFhotCarMode

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.hotCarList = dic[@"hotCarList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}

@end

@implementation VFhotCarListMode
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.price = dic[@"price"];
        self.carId = dic[@"carId"];
        self.title = dic[@"title"];
        self.tags = dic[@"tags"];
    }
    return self;
}

@end
