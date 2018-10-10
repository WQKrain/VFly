//
//  LongRentModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LongRentModel : NSObject

@property (nonatomic,strong) NSArray * packageList;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface LongRentListModel : NSObject

@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString * minPriceText;
@property (nonatomic,strong) NSString * maxPriceText;
@property (nonatomic,strong) NSString * minPrice;
@property (nonatomic,strong) NSString * maxPrice;
@property (nonatomic,strong) NSString * packageId;

- (id) initWithDic:(NSDictionary *)dic;
@end
