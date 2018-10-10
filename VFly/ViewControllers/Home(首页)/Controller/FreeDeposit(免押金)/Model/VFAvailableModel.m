//
//  VFAvailableModel.m
//  LuxuryCar
//
//  Created by Hcar on 2018/2/2.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFAvailableModel.h"

@implementation VFAvailableModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.quantity = dic[@"quantity"];
        self.used = dic[@"used"];
        self.available = dic[@"available"];
    }
    return self;
}

@end
