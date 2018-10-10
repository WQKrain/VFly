//
//  VFOrderQRCodeModel.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/16.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFOrderQRCodeModel.h"

@implementation VFOrderQRCodeModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.qrcode_src = dic[@"qrcode_src"];
        self.overdue_time = dic[@"overdue_time"];
    }
    return self;
}

@end
