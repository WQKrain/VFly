//
//  VFBreaksTheDepositOrderDetailModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/12/24.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFBreaksTheDepositOrderDetailModel.h"

@implementation VFBreaksTheDepositOrderDetailModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if([[dic allKeys] containsObject:@"free_deposit"]){
            self.free_deposit = dic[@"free_deposit"];
        }
        self.open_free_deposit = dic[@"open_free_deposit"];
    }
    return self;
}

@end

@implementation VFBreaksTheDepositOrderDetailStateModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if([[dic allKeys] containsObject:@"status"]){
            self.contract_status = dic[@"contract_status"];
        }
        if([[dic allKeys] containsObject:@"service_fee"]){
            self.service_fee = dic[@"service_fee"];
        }
        if ([[dic allKeys] containsObject:@"agreement"]) {
            self.agreement = dic[@"agreement"];
        }
        
        if ([[dic allKeys] containsObject:@"service_fee_status"]) {
            self.service_fee_status = dic[@"service_fee_status"];
        }
        
        if ([[dic allKeys] containsObject:@"sign_bankcard"]) {
            self.sign_bankcard = dic[@"sign_bankcard"];
        }
    }
    return self;
}

@end

@implementation VFBreaksTheDepositBankCardDetailStateModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.bankcard = dic[@"bankcard"];
        self.mobile = dic[@"mobile"];
        self.card_num = dic[@"card_num"];
    }
    return self;
}

@end

