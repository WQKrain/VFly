//
//  VFNotificationCityModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFNotificationCityModel : NSObject

@property (nonatomic,strong) NSString * cityName;
@property (nonatomic,strong) NSString * cityID;
@property (nonatomic,strong) NSString * countyID;
@property (nonatomic,strong) NSString * countyName;
@property (nonatomic,strong) NSString * provinceName;
@property (nonatomic,strong) NSString * provinceID;
- (id) initWithDic:(NSDictionary *)dic;

@end
