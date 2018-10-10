///Users/H_Car/Desktop/vfly_ios_restructure/VFly/VFly.xcodeproj
//  VipInfoModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VipInfoModel.h"

@implementation VipInfoModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if ([dic objectForKey:@"vipLevel"]) {
            self.vipLevel = dic[@"vipLevel"];
        }
        else{
            self.vipLevel = dic[@"level"];
        }
        self.name = dic[@"name"];
        self.avatar = dic[@"avatar"];
        self.expireTime = dic[@"expireTime"];
        self.expireTimestamp = dic[@"expireTimestamp"];
        self.vipMoney = dic[@"vipMoney"];
        self.freeDays = dic[@"freeDays"];
        self.goUpStatus = dic[@"goUpStatus"];
        self.vipImage = dic[@"vipImage"];
        self.tqImage = dic[@"tqImage"];
    }
    return self;
}

@end
