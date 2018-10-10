//
//  VFCreateOrederModel.h
//  VFly
//
//  Created by Hcar on 2018/4/19.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFCreateOrederModel : NSObject

@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSString * should_pay_id;
@property (nonatomic,strong) NSString * item;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * rental_days;
@property (nonatomic,strong) NSString * re_day_rental;
- (id)initWithDic:(NSDictionary *)dic;

@end
