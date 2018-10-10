//
//  GlobalConfigModel.m
//  VFeng
//
//  Created by Hcar on 2017/6/1.
//  Copyright © 2017年 Hcar. All rights reserved.
//

#import "GlobalConfigModel.h"

@implementation GlobalConfigModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.customerServiceTel = dic[@"customerServiceTel"];
        self.activityUrl = dic[@"activityUrl"];
        self.agreementUrl = dic[@"agreementUrl"];
        self.problemUrl = dic[@"problemUrl"];
        self.useType = dic[@"useType"];
        self.lastVersion = dic[@"lastVersion"];
        self.isUpdate = dic[@"isUpdate"];
        self.updateUrl = dic[@"updateUrl"];
        self.cPay = dic[@"cPay"];
        self.cRental = dic[@"cRental"];
        self.cUser = dic[@"cUser"];
        self.burl = dic[@"burl"];
        
        self.des = dic[@"des"];
        
        self.shareDomain = dic[@"shareDomain"];
        self.shareText = dic[@"shareText"];
        self.shareIcon = dic[@"shareIcon"];
        self.shareTitle = dic[@"shareTitle"];
        self.job = dic[@"job"];
        self.record = dic[@"record"];
        self.scoreActivityPoint = dic[@"scoreActivityPoint"];
        self.frontMoneyPoint = dic[@"frontMoneyPoint"];
        self.vipProblem = dic[@"vipProblem"];
        self.scoreProblemUrl  = dic[@"scoreProblemUrl"];
        self.homeImage = dic[@"homeImage"];
        self.homeImageUrl = dic[@"homeImageUrl"];
        self.serviceFeeUrl = dic[@"serviceFeeUrl"];
        self.signAuthorizationUrl = dic[@"signAuthorizationUrl"];
        self.freeDepositUrl = dic[@"freeDepositUrl"];
    }
    return self;
}


@end

@implementation bUrlList

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.main = dic[@"main"];
        self.wait = dic[@"wait"];
        self.regist = dic[@"register"];
    }
    return self;
}

@end

