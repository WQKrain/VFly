//
//  DriveTravelModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriveTravelModel : NSObject

@property (nonatomic,copy) NSArray * carList;
@property (nonatomic,copy) NSString * remainder;
@property (nonatomic,copy) NSString * qualification_text;
@property (nonatomic,copy) NSString * available;
- (id) initWithDic:(NSDictionary *)dic;

@end

@interface DriveTravelListModel : NSObject

@property (nonatomic,copy) NSString * image;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * carId;
@property (nonatomic,copy) NSString * brand;
@property (nonatomic,copy) NSString * year;
@property (nonatomic,copy) NSString * model;
@property (nonatomic,copy) NSString * seats;
@property (nonatomic,copy) NSArray * stereotype;
@property (nonatomic,copy) NSArray * specail;
@property (nonatomic,copy) NSArray * tags;
@property (nonatomic,copy) NSString * deposit;
@property (nonatomic,copy) NSString * service_fee;
@property (nonatomic,copy) NSString * label;

- (id) initWithDic:(NSDictionary *)dic;


@end
