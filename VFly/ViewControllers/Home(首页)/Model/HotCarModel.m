//
//  HotCarModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/5.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "HotCarModel.h"

@implementation HotCarModel
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.topCarList = dic[@"topCarList"];
    }
    return self;
}
@end

@implementation HotCarListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.carId = dic[@"carId"];
        self.price = dic[@"price"];
        self.tags = dic[@"tags"];
    }
    return self;
}
@end
