//
//  VFRealNameAuthenticationModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/12/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFRealNameAuthenticationModel.h"

@implementation VFRealNameAuthenticationModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if([[dic allKeys] containsObject:@"card"]){
            self.card = dic[@"card"];
        }
        if([[dic allKeys] containsObject:@"driving_licence"]){
            self.driving_licence = dic[@"driving_licence"];
        }
        self.cardStatus = dic[@"card_status"];
        self.drivingLicenceStatus = dic[@"driving_licence_status"];
    }
    return self;
}

@end

@implementation VFRealNameAuthenticationCardModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if([[dic allKeys] containsObject:@"name"]){
            self.name = dic[@"name"];
        }
        if([[dic allKeys] containsObject:@"card_num"]){
            self.card_num = dic[@"card_num"];
        }
    }
    return self;
}

@end

@implementation VFRealNameAuthenticationDrivingModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if([[dic allKeys] containsObject:@"name"]){
            self.name = dic[@"name"];
        }
        if([[dic allKeys] containsObject:@"card_num"]){
            self.card_num = dic[@"card_num"];
        }
        if([[dic allKeys] containsObject:@"sex"]){
            self.sex = dic[@"sex"];
        }
        if([[dic allKeys] containsObject:@"address"]){
            self.address = dic[@"address"];
        }
        if([[dic allKeys] containsObject:@"allow_car_model"]){
            self.allow_car_model = dic[@"allow_car_model"];
        }
    }
    return self;
}

@end
