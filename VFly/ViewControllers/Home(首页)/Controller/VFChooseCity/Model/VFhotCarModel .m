//
//  VFhotCarModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFhotCarModel.h"

@implementation VFhotCarModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.hotCitys = dic[@"hotCitys"];
    }
    return self;
}

@end

@implementation VFhotCarListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cityID = dic[@"cityId"];
        self.shortname = dic[@"shortname"];
    }
    return self;
}

@end
