//
//  VFCustomerQualificationModel.h
//  LuxuryCar
//
//  Created by Hcar on 2018/2/1.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFCustomerQualificationModel : NSObject

@property (nonatomic,strong) NSString * qualification_status;
@property (nonatomic,strong) NSDictionary * qualification;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFCustomerQualificationDetailModel : NSObject

@property (nonatomic,strong) NSString * credit_line;
@property (nonatomic,strong) NSString * freezing;
@property (nonatomic,strong) NSString * available;
@property (nonatomic,strong) NSString * total_deductions;
@property (nonatomic,strong) NSString * used_times;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * id_card;
@property (nonatomic,strong) NSString * bankcard;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSArray * house_property;
@property (nonatomic,strong) NSArray * car_property;
@property (nonatomic,strong) NSString * other_property;
@property (nonatomic,strong) NSString * id_card_face;
@property (nonatomic,strong) NSString * id_card_back;
@property (nonatomic,strong) NSString * driving_licence;
@property (nonatomic,strong) NSString * expired_at;

- (id) initWithDic:(NSDictionary *)dic;

@end
