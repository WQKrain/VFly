//
//  VFSuttleOrderDetailModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSuttleOrderDetailModel.h"

@implementation VFSuttleOrderDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.rental = dic[@"rental"];
        self.expire = dic[@"expire"];
        self.vipDiscount = dic[@"vipDiscount"];
    }
    return self;
}

@end
