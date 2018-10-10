//
//  LoginModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/2.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.token = dic[@"token"];
        self.credit = dic[@"creditStatus"];
        self.headImg = dic[@"headimg"];
        self.mobile = dic[@"mobile"];
        self.name = dic[@"name"];
        self.money = dic[@"money"];
        self.nickname = dic[@"nickname"];
        self.order = dic[@"orderId"];
        self.card = dic[@"card"];
        self.bankCard = dic[@"bankCard"];
        self.bindTime = dic[@"bindTime"];
        self.score = dic[@"score"];
        self.vipLevel = dic[@"vipLevel"];
        self.vipScorePoint = dic[@"vipScorePoint"];
        self.pushid = dic[@"pushid"];
        self.firstLogin = dic[@"firstLogin"];
    }
    return self;
}

@end

@implementation VFLoginModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.token = dic[@"token"];
    }
    return self;
}

@end
