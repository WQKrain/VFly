//
//  VFGetPayMoneyModel.h
//  VFly
//
//  Created by Hcar on 2018/4/13.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFGetPayMoneyModel : NSObject

@property (nonatomic,strong) NSString * item;
@property (nonatomic,strong) NSString * canDiscountMoney;
@property (nonatomic,strong) NSString * unPayedMoney;
@property (nonatomic,strong) NSString * created_at;
@property (nonatomic,strong) NSString * should_pay_id;
@property (nonatomic,strong) NSString * is_score;
@property (nonatomic,strong) NSString * is_coupon;
@property (nonatomic,strong) NSString * handler;
@property (nonatomic,strong) NSString * real_money;

- (id) initWithDic:(NSDictionary *)dic;

@end
