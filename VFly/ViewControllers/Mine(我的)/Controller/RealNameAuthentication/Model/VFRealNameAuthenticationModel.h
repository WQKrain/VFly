//
//  VFRealNameAuthenticationModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/12/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFRealNameAuthenticationModel : NSObject

@property (nonatomic,strong) NSString * cardStatus;
@property (nonatomic,strong) NSString * drivingLicenceStatus;
@property (nonatomic,strong) NSDictionary * card;
@property (nonatomic,strong) NSDictionary * driving_licence;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFRealNameAuthenticationCardModel : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * card_num;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFRealNameAuthenticationDrivingModel : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * card_num;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * allow_car_model;
- (id) initWithDic:(NSDictionary *)dic;

@end
