//
//  VFCarDetailModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFCarDetailModel.h"

@implementation VFCarDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.images = dic[@"images"];
        self.carId = dic[@"carId"];
        self.price = dic[@"price"];
        
        if([[dic allKeys] containsObject:@"first_price"]){
            self.first_price = dic[@"first_price"];
        }
        
        self.attr = dic[@"attr"];
        self.isStar = dic[@"isStar"];
        self.year = dic[@"year"];
        self.brand = dic[@"brand"];
        self.model = dic[@"model"];
        self.carDescription = dic[@"description"];
        self.detailImages = dic[@"detailImages"];
        self.video = dic[@"video"];
        self.level = dic[@"level"];
        self.priceMap = dic[@"priceMap"];
        self.specall = dic[@"specall"];
        self.shareUrl = dic[@"url"];
        self.shareTitle = dic[@"title"];
        self.shareDescription = dic[@"shareDescription"];
        self.videoCover = dic[@"videoCover"];
        self.tags = dic[@"tags"];
        
        if([[dic allKeys] containsObject:@"deposit"]){
            self.deposit = dic[@"deposit"];
        }
    }
    return self;
}

@end

@implementation VFCarAttrDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.drive = dic[@"drive"];
        self.output = dic[@"output"];
        self.gear = dic[@"gear"];
        self.seats = dic[@"seats"];
        self.firm = dic[@"firm"];
        self.kidney = dic[@"kidney"];
        self.stereotype = dic[@"stereotype"];
    }
    return self;
}

@end

@implementation VFCarLevelDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.minDay = dic[@"minDay"];
        self.maxDay = dic[@"maxDay"];
        self.zk = dic[@"zk"];
    }
    return self;
}

@end

@implementation VFCarPriceMapDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.areaId = dic[@"area_id"];
        self.price = dic[@"price"];
    }
    return self;
}

@end

