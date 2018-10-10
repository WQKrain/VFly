//
//  VFOrderListModel.h
//  VFly
//
//  Created by Hcar on 2018/4/14.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFOrderListModel : NSObject

@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSString * status;
@property (nonatomic, copy) NSString *status_text;
@property (nonatomic,strong) NSString * canPay;
@property (nonatomic,strong) NSString * canEvaluation;
@property (nonatomic,strong) NSString * canRenew;
@property (nonatomic,strong) NSString * canDel;

@property (nonatomic,strong) NSString * start_date;
@property (nonatomic,strong) NSString * end_date;
@property (nonatomic,assign) NSString * rental_days;
@property (nonatomic,strong) NSString * get_city;
@property (nonatomic,strong) NSString * return_city;
@property (nonatomic,strong) NSString * get_func;
@property (nonatomic,strong) NSString * re_day_rental;
@property (nonatomic,strong) NSString * free_deposit;
@property (nonatomic,strong) NSString * car_id;
@property (nonatomic,strong) NSString * model;
@property (nonatomic,strong) NSString * brand;
@property (nonatomic,strong) NSString * car_img;
@property (nonatomic,strong) NSString * created_at;

@property (nonatomic,strong) NSString * should_pay_id;


- (id) initWithDic:(NSDictionary *)dic;

@end
