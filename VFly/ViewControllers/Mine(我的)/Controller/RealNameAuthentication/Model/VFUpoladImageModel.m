//
//  VFUpoladImageModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFUpoladImageModel.h"

@implementation VFUpoladImageModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.picId = kFormat(@"%@", dic[@"id"]);
        self.path = dic[@"path"];
    }
    return self;
}

@end
