//
//  VFRegistHXModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/12.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFRegistHXModel.h"

@implementation VFRegistHXModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.activated = dic[@"activated"];
        self.created = dic[@"created"];
        self.modified = dic[@"modified"];
        self.password = dic[@"password"];
        self.type = dic[@"type"];
        self.username = dic[@"username"];
        self.uuid = dic[@"uuid"];
    }
    return self;
}


@end
