//
//  TodayPreferentialModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/4.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayPreferentialModel : NSObject
@property (nonatomic,strong) NSArray * discountList;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface TodayPreferentialListModel : NSObject

@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * nowPrice;
@property (nonatomic,strong) NSString * costPrice;
@property (nonatomic,strong) NSString * carId;
@property (nonatomic,strong) NSString * startTime;
@property (nonatomic,strong) NSString * endTime;

- (id) initWithDic:(NSDictionary *)dic;
@end

