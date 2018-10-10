//
//  VFSuttleOrderGetDetailModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSuttleOrderGetDetailModel.h"

@implementation VFSuttleOrderGetDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.price = dic[@"price"];
        self.descriptionStr = dic[@"description"];
        self.carModel = dic[@"carModel"];
        self.image = dic[@"image"];
        self.level = dic[@"level"];
        self.smallImage = dic[@"smallImage"];
    }
    return self;
}

@end
