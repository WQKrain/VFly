//
//  VFOrderDetailModel.h
//  VFly
//
//  Created by Hcar on 2018/4/16.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFOrderDetailModel : NSObject
@property (nonatomic,copy) NSString * order_id;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString *status_text;
@property (nonatomic,copy) NSString * canPay;
@property (nonatomic,copy) NSString * canEvaluation;
@property (nonatomic,copy) NSString * canRenew;
@property (nonatomic,copy) NSString * canDel;
@property (nonatomic,copy) NSString * brand;
@property (nonatomic,copy) NSString * unpaid;
@property (nonatomic,copy) NSString * car_id;
@property (nonatomic,copy) NSString * car_img;
@property (nonatomic,copy) NSString * created_at;
@property (nonatomic,copy) NSString * end_date;
@property (nonatomic,copy) NSArray  * freeDeposits;
@property (nonatomic,copy) NSString * free_deposit;
@property (nonatomic,copy) NSString * get_city;
@property (nonatomic,copy) NSString * get_func;
@property (nonatomic,copy) NSString * has_driver;
@property (nonatomic,copy) NSString * model;
@property (nonatomic,copy) NSArray  * money;
@property (nonatomic,copy) NSString * re_day_rental;
@property (nonatomic,copy) NSString * re_rental;
@property (nonatomic,copy) NSString * remark;
@property (nonatomic,copy) NSString * rental_days;
@property (nonatomic,copy) NSString * return_city;
@property (nonatomic,copy) NSString * sent_address;
@property (nonatomic,copy) NSString * start_date;
@property (nonatomic,copy) NSDictionary * useman;

- (id) initWithDic:(NSDictionary *)dic;

@end


@interface VFOrderDetailUsemanModel : NSObject

@property (nonatomic,copy) NSString * mobile;
@property (nonatomic,copy) NSString * nick_name;
@property (nonatomic,copy) NSString * useman_id;
@property (nonatomic,copy) NSString * card_status;
@property (nonatomic,copy) NSString * driving_licence_status;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFOrderDetailPayModel : NSObject

@property (nonatomic,copy) NSString * item;
@property (nonatomic,copy) NSArray  * lists;
@property (nonatomic,copy) NSString * payed;
@property (nonatomic,copy) NSString * should_pay_id;
@property (nonatomic,copy) NSString * should_pay;
@property (nonatomic,copy) NSString * pay_type;
@property (nonatomic,copy) NSString * status;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFOrderDetailPayListModel : NSObject

@property (nonatomic,copy) NSString * item;
@property (nonatomic,copy) NSArray  * order_id;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * method;
@property (nonatomic,copy) NSString * created_at;
@property (nonatomic,copy) NSString * should_pay_id;

- (id) initWithDic:(NSDictionary *)dic;

@end


