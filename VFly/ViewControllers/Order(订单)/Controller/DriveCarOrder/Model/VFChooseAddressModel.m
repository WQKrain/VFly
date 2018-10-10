//
//  VFChooseAddressModel.m
//  VFly
//
//  Created by Hcar on 2018/4/19.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFChooseAddressModel.h"

@implementation VFChooseAddressModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.address = dic[@"address"];
        self.address_id = dic[@"address_id"];
        self.district_id = dic[@"district_id"];
        self.last_use_time = dic[@"last_use_time"];
    }
    return self;
}

@end
