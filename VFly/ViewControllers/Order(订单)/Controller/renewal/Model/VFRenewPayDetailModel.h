//
//  VFRenewPayDetailModel.h
//  VFly
//
//  Created by Hcar on 2018/4/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFRenewPayDetailModel : NSObject

@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSDictionary * car;
@property (nonatomic,strong) NSString * re_day_rental;
@property (nonatomic,strong) NSString * start_date;
@property (nonatomic,strong) NSString * end_date;
@property (nonatomic,strong) NSString * remark;
@property (nonatomic,strong) NSString * days;
@property (nonatomic,strong) NSString * created_at;
@property (nonatomic,strong) NSString * should_pay_id;


- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFRenewPayDetailCarModel : NSObject

@property (nonatomic,strong) NSString * img;
@property (nonatomic,strong) NSString * brand;
@property (nonatomic,strong) NSArray * model;

- (id) initWithDic:(NSDictionary *)dic;

@end

