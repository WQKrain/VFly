//
//  VFChooseCityModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChooseCityModel.h"

@implementation VFChooseCityModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cityID = kFormat(@"%@", dic[@"id"]);
        self.pid = kFormat(@"%@",dic[@"pid"]);
        self.shortname = dic[@"shortname"];
        self.name = dic[@"name"];
        self.mergerName = dic[@"merger_name"];
        self.level = kFormat(@"%@",dic[@"level"]);
        self.pinyin = dic[@"pinyin"];
        self.first = dic[@"first"];
        self.first = dic[@"lng"];
    }
    return self;
}

@end
