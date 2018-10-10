//
//  StarModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "StarModel.h"

@implementation StarModel


- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.starList = dic[@"starList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}

@end

@implementation StarListModel
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.carId = dic[@"carId"];
        self.drive = dic[@"drive"];
        self.gear = dic[@"gear"];
        self.image = dic[@"image"];
        self.name = dic[@"name"];
        self.output = dic[@"output"];
        self.price = dic[@"price"];
        self.seats = dic[@"seats"];
        self.tags = dic[@"tags"];
    }
    return self;
}

@end

