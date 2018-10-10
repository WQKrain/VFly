//
//  VFSerchCarModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/28.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSerchCarModel.h"

@implementation VFSerchCarModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.carList = dic[@"carList"];
        self.total = dic[@"total"];
    }
    return self;
}

@end


@implementation VFSerchCarListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.image = dic[@"image"];
        self.price = dic[@"price"];
        self.logo = dic[@"logo"];
        self.carId = dic[@"carId"];
        self.tags = dic[@"tags"];
    }
    return self;
}


@end
