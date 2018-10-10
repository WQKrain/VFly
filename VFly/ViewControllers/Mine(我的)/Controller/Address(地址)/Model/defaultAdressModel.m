//
//  defaultAdressModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/28.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "defaultAdressModel.h"

@implementation defaultAdressModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.address = dic[@"address"];
        self.mobile = dic[@"mobile"];
        self.addressID = dic[@"id"];
    }
    return self;
}


@end
