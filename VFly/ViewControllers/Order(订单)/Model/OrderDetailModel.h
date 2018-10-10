//
//  OrderDetailModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (nonatomic,strong) NSString * orderId;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * cover;
@property (nonatomic,strong) NSString * statusText;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * typeText;
@property (nonatomic,strong) NSString * orderTime;
@property (nonatomic,strong) NSString * brand;
@property (nonatomic,strong) NSString * year;
@property (nonatomic,strong) NSString * model;
@property (nonatomic,strong) NSString * useStartTime;
@property (nonatomic,strong) NSString * useEndTime;
@property (nonatomic,strong) NSString * getCarFunc;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * getCarCity;
@property (nonatomic,strong) NSString * returnCarCity;
@property (nonatomic,strong) NSString * days;
@property (nonatomic,strong) NSString * frontMoney;
@property (nonatomic,strong) NSString * rentalMoney;
@property (nonatomic,strong) NSString * depositMoney;
@property (nonatomic,strong) NSString * illegalMoney;
@property (nonatomic,strong) NSString * frontMoneyStatus;
@property (nonatomic,strong) NSString * rentalMoneyStatus;
@property (nonatomic,strong) NSString * depositMoneyStatus;
@property (nonatomic,strong) NSString * illegalMoneyStatus;
@property (nonatomic,strong) NSString * totalMoney;
@property (nonatomic,strong) NSString * totalMoneyStatus;
@property (nonatomic,strong) NSString * expire;
@property (nonatomic,strong) NSString * paid;
@property (nonatomic,strong) NSString * unpaid;
@property (nonatomic,strong) NSString * passengerCounts;
@property (nonatomic,strong) NSString * carCounts;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * scoreMoney;
@property (nonatomic,strong) NSString * couponMoney;
@property (nonatomic,strong) NSString * freeDays;
@property (nonatomic,strong) NSString * dayRental;
@property (nonatomic,strong) NSString * isEvaluation;
@property (nonatomic,strong) NSString * canRenew;
@property (nonatomic,strong) NSString * payable;
@property (nonatomic,strong) NSString * vipZk;
@property (nonatomic,strong) NSString * vipDiscount;
@property (nonatomic,strong) NSString * longrentalZk;
@property (nonatomic,strong) NSString * longrentalDiscount;

@property (nonatomic,strong) NSString * unpaidFrontMoney;
@property (nonatomic,strong) NSString * unpaidRentalMoney;
@property (nonatomic,strong) NSString * unpaidDepositMoney;
@property (nonatomic,strong) NSString * unpaidIllegalMoney;
@property (nonatomic,strong) NSString * canDel;
@property (nonatomic,strong) NSString * is_free_deposit;

- (id) initWithDic:(NSDictionary *)dic;

@end
