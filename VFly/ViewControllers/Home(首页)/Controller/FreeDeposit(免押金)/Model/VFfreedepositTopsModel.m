//
//  VFfreedepositTopsModel.m
//  LuxuryCar
//
//  Created by Hcar on 2018/2/2.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFfreedepositTopsModel.h"

@implementation VFfreedepositTopsModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.tops = dic[@"tops"];
    }
    return self;
}

@end

@implementation VFfreedepositTopsListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.total_deductions = dic[@"total_deductions"];
        self.sort = dic[@"sort"];
    }
    return self;
}

@end
