//
//  VFUserInfoModel.h
//  VFly
//
//  Created by Hcar on 2018/4/13.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFUserInfoModel : NSObject

@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * useman_id;
@property (nonatomic,strong) NSString * is_card_real;
@property (nonatomic,strong) NSString * partner;
@property (nonatomic,strong) NSString * headimg;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * card;
@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * score;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * last_use_time;
@property (nonatomic,strong) NSString * last_order_time;
@property (nonatomic,strong) NSString * total_pay;
@property (nonatomic,strong) NSString * regTime;
@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString * first_login;
@property (nonatomic,strong) NSString * cus_area;
@property (nonatomic,strong) NSString * cus_record;
@property (nonatomic,strong) NSString * cus_job;
@property (nonatomic,strong) NSString * cus_hobby;
@property (nonatomic,strong) NSArray * order;
@property (nonatomic,strong) NSString * is_certificate;

- (id) initWithDic:(NSDictionary *)dic;

@end
