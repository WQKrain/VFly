//
//  VFBreaksTheDepositOrderDetailModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/12/24.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFBreaksTheDepositOrderDetailModel : NSObject
@property (nonatomic,strong) NSDictionary * free_deposit;
@property (nonatomic,strong) NSString * open_free_deposit;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFBreaksTheDepositOrderDetailStateModel : NSObject
@property (nonatomic,strong) NSString * contract_status;
@property (nonatomic,strong) NSString * service_fee;
@property (nonatomic,strong) NSString * agreement;
@property (nonatomic,strong) NSString * service_fee_status;
@property (nonatomic,strong) NSDictionary * sign_bankcard;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFBreaksTheDepositBankCardDetailStateModel : NSObject
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * bankcard;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * card_num;

- (id) initWithDic:(NSDictionary *)dic;
@end
