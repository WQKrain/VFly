//
//  DriveTravelModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "DriveTravelModel.h"

@implementation DriveTravelModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.carList = dic[@"carList"];
        if ([[dic allKeys] containsObject:@"remainder"]) {
            self.remainder = dic[@"remainder"];
        }
        
        if ([[dic allKeys] containsObject:@"qualification_text"]) {
            self.qualification_text = dic[@"qualification_text"];
        }
        
        if ([[dic allKeys] containsObject:@"available"]) {
            self.available = dic[@"available"];
        }
    }
    return self;
}


@end

@implementation DriveTravelListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.price = kFormat(@"%@", dic[@"price"]);
        self.carId = dic[@"car_id"];
        self.brand = dic[@"brand"];
        self.year = dic[@"year"];
        self.model = dic[@"model"];
        self.seats = dic[@"seats"];
        self.stereotype = dic[@"stereotype"];
        self.specail = dic[@"specail"];
        self.tags = dic[@"tags"];
        
        if ([[dic allKeys] containsObject:@"deposit"]) {
            self.deposit = dic[@"deposit"];
        }
        
        if ([[dic allKeys] containsObject:@"service_fee"]) {
            self.service_fee = dic[@"service_fee"];
        }
        
        if ([[dic allKeys] containsObject:@"label"]) {
            self.label = dic[@"label"];
        }
    }
    return self;
}


@end

