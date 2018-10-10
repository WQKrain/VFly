//
//  VFMessageCountModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFMessageCountModel.h"

@implementation VFMessageCountModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.message = dic[@"message"];
    }
    return self;
}

@end

@implementation VFMessageCountListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.wallet = dic[@"wallet"];
        self.order = dic[@"order"];
    }
    return self;
}
@end
