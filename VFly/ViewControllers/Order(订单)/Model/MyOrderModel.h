//
//  MyOrderModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (nonatomic,strong) NSArray * orderList;
@property (nonatomic,strong) NSString * hasMorePages;
- (id) initWithDic:(NSDictionary *)dic;

@end

@interface MyPickUpOrderModel : NSObject

@property (nonatomic,strong) NSArray * shuttles;
@property (nonatomic,strong) NSString * hasMorePages;
- (id) initWithDic:(NSDictionary *)dic;

@end

@interface MyOrderListModel : NSObject

@property (nonatomic,strong) NSString * orderId;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * statusText;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * typeText;
@property (nonatomic,strong) NSString * orderTime;
@property (nonatomic,strong) NSString * carModel;
@property (nonatomic,strong) NSString * cover;
@property (nonatomic,strong) NSString * useStartTime;
@property (nonatomic,strong) NSString * useEndTime;
@property (nonatomic,strong) NSString * year;
@property (nonatomic,strong) NSString * brand;
@property (nonatomic,strong) NSString * expire;
@property (nonatomic,strong) NSString * getCarCity;
@property (nonatomic,strong) NSString * returnCarCity;
@property (nonatomic,strong) NSString * totalPrice;
@property (nonatomic,strong) NSString * days;
@property (nonatomic,strong) NSString * canRenew;
@property (nonatomic,strong) NSString * isEvaluation;
@property (nonatomic,strong) NSString * canPay;
@property (nonatomic,strong) NSString * dayRental;
@property (nonatomic,strong) NSString * canDel;

- (id) initWithDic:(NSDictionary *)dic;


@end

