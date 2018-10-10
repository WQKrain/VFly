//
//  VFCarLogoModel.m
//  VFly
//
//  Created by Hcar on 2018/5/15.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCarLogoModel.h"

@implementation VFCarLogoModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.brandList = dic[@"brandList"];
    }
    return self;
}

@end

@implementation VFCarLogoListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.brand = dic[@"brand"];
        self.x2 = dic[@"x2"];
        self.x3 = dic[@"x3"];
    }
    return self;
}

@end
