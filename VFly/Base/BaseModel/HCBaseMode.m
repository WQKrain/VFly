//
//  HCBaseMode.m
//  LuxuryCar
//
//  Created by Hcar on 2017/5/9.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "HCBaseMode.h"

@implementation HCBaseMode

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = dic[@"code"];
        self.info = dic[@"info"];
        self.time = dic[@"time"];
        self.data = dic[@"data"];
    }
    return self;
}


@end

@implementation VFBaseMode

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = kFormat(@"%@", dic[@"code"]);
        self.date = dic[@"date"];
        self.message = dic[@"message"];
        self.data = dic[@"data"];
    }
    return self;
}


@end

@implementation VFBaseListMode

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = dic[@"code"];
        self.date = dic[@"date"];
        self.message = dic[@"message"];
        self.data = dic[@"data"];
    }
    return self;
}

@end
