//
//  VFCallModel.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/25.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFCallModel.h"

@implementation VFCallModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.address = dic[@"address"];
        self.icon = dic[@"icon"];
        self.name = dic[@"name"];
        self.tel = dic[@"tel"];
    }
    return self;
}

@end
