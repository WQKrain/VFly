//
//  HotCarModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/5.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotCarModel : NSObject

@property (nonatomic,strong) NSArray * topCarList;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface HotCarListModel : NSObject

@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * carId;
@property (nonatomic,strong) NSArray * tags;

- (id) initWithDic:(NSDictionary *)dic;
@end

