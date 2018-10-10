//
//  AddressModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.addressList = dic[@"addressList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}


@end

@implementation AddressListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.address = dic[@"address"];
        self.mobile = dic[@"mobile"];
        self.status = dic[@"status"];
        self.createTime = dic[@"createTime"];
        self.addressID = dic[@"id"];
        self.cityId = dic[@"cityId"];
    }
    return self;
}


@end
