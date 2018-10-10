//
//  VFhotCarMode.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/26.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFhotCarMode : NSObject
@property (nonatomic,strong) NSArray * hotCarList;
@property (nonatomic,strong) NSString * remainder;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFhotCarListMode : NSObject

@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * carId;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSArray * tags;

- (id) initWithDic:(NSDictionary *)dic;


@end
