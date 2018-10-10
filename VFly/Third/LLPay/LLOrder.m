//
//  LLOrder.m
//  DemoPay
//
//  Created by linyf on 2016/11/28.
//  Copyright © 2016年 LianLianPay. All rights reserved.
//

#import "LLOrder.h"
@import UIKit;

@interface LLOrder ()
/// 支付方式
@property (nonatomic, assign) NSUInteger llPayType;

@property (nonatomic, strong) NSMutableDictionary *tradeInfoDic;

@end

@implementation LLOrder

- (instancetype)initWithLLPayType: (NSUInteger)payType {
    self = [super init];
    if (self) {
        self.llPayType = payType;
    }
    return self;
}

- (instancetype)initWithApplePayMerchantID: (NSString *)merchantID {
    self = [super init];
    if (self) {
        self.ap_merchant_id = merchantID;
    }
    return self;
}

+ (NSString *)timeStamp {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *simOrder = [dateFormater stringFromDate:[NSDate date]];
    return simOrder;
}

- (NSDictionary *)tradeInfoForPayment {
    _tradeInfoDic = [NSMutableDictionary dictionary];
    NSArray *keysNeedPass = @[@"oid_partner",@"sign_type",@"busi_partner",@"no_order",
                              @"dt_order",@"money_order",@"notify_url",@"risk_item",@"user_id"];
    _tradeInfoDic = [[self dictionaryWithValuesForKeys:keysNeedPass] mutableCopy];
    [self llOptionalParams];
    if (self.ap_merchant_id.length > 0) {//apple pay
        [self llAPPayTradeInfo];
    } else {
        _tradeInfoDic[@"id_no"] = self.id_no?:nil;
        _tradeInfoDic[@"acct_name"] = self.acct_name?:nil;
        _tradeInfoDic[@"card_no"] = self.card_no?:nil;
        [self llPayTradeInfoForPayment];
    }
    return [self isParamMissing]?nil:[_tradeInfoDic copy];
}

- (void)llOptionalParams {
    _tradeInfoDic[@"name_goods"] = self.name_goods?:nil;
    _tradeInfoDic[@"info_order"] = self.info_order?:nil;
    _tradeInfoDic[@"valid_order"] = self.valid_order?:nil;
}

- (void)llPayTradeInfoForPayment {
    _tradeInfoDic[@"no_agree"] = self.no_agree?:nil;
    _tradeInfoDic[@"id_type"] = self.id_type?:nil;
    _tradeInfoDic[@"platform"] = self.platform?:nil;
    _tradeInfoDic[@"shareing_data"] = self.shareing_data?:nil;
    
    BOOL llNeedPassUserInfo = NO;
    switch (self.llPayType) {
        case 0://快捷支付
            _tradeInfoDic[@"flag_modify"] = self.flag_modify?:@"0";
            break;
        case 1://认证支付
            llNeedPassUserInfo = YES;
            break;
        case 2://预授权
            break;
        case 3://游易付
            _tradeInfoDic[@"pay_type"] = self.pay_type?:[NSNull null];
            break;
        case 4://实名快捷
            llNeedPassUserInfo = YES;
            break;
        case 5://车易付
            _tradeInfoDic[@"pay_type"] = self.pay_type?:[NSNull null];
            break;
        case 6://分期付
            llNeedPassUserInfo = YES;
            _tradeInfoDic[@"repayment_no"] = self.repayment_no?:nil;
            _tradeInfoDic[@"repayment_plan"] = self.repayment_plan?:nil;
            _tradeInfoDic[@"sms_param"] = self.sms_param?:nil;
            break;
        default:
            break;
    }
    if (llNeedPassUserInfo) {
        _tradeInfoDic[@"id_no"] = self.id_no?:[NSNull null];
        _tradeInfoDic[@"acct_name"] = self.acct_name?:[NSNull null];
    }
}

- (void)llAPPayTradeInfo {
    _tradeInfoDic[@"ap_merchant_id"] = self.ap_merchant_id?:[NSNull null];
    _tradeInfoDic[@"llAPPayNeedShipping"] = self.llAPPayNeedShipping?:nil;
}

- (BOOL)isParamMissing {
    self.errorInfo = @"请传入参数";
    if ([_tradeInfoDic.allValues containsObject: [NSNull null]]) {
        [_tradeInfoDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if (obj == [NSNull null]) {
                self.errorInfo = [self.errorInfo stringByAppendingString:@" & "];
                self.errorInfo = [self.errorInfo stringByAppendingString:key];
            }
        }];
        return YES;
    }
    return NO;
}

+ (NSString*)llJsonStringOfObj:(NSDictionary *)dic {
    NSError *err = nil;
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:dic
                                                         options:0
                                                           error:&err];
    NSString *str = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    return str;
}

@end
