//
//  VFSuttleListModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSuttleListModel.h"

@implementation VFSuttleListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.shuttleList = dic[@"shuttleList"];
    }
    return self;
}

@end

@implementation VFSuttleListArrModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.price = dic[@"price"];
        self.carModel = dic[@"carModel"];
        self.image = dic[@"image"];
        self.level = dic[@"level"];
        self.deatil = dic[@"description"];
        self.smallImage = dic[@"smallImage"];
    }
    return self;
}

@end
