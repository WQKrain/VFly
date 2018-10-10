//
//  VFCarDetailModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFCarDetailModel : NSObject

@property (nonatomic,strong) NSArray * images;
@property (nonatomic,strong) NSString * carId;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * first_price;
@property (nonatomic,strong) NSDictionary * attr;
@property (nonatomic,strong) NSString * isStar;
@property (nonatomic,strong) NSString * year;
@property (nonatomic,strong) NSString * brand;
@property (nonatomic,strong) NSString * model;
@property (nonatomic,strong) NSArray * detailImages;
@property (nonatomic,strong) NSString * carDescription;
@property (nonatomic,strong) NSString * video;
@property (nonatomic,strong) NSArray * level;
@property (nonatomic,strong) NSArray * priceMap;
@property (nonatomic,strong) NSArray * specall;
@property (nonatomic,strong) NSString * shareUrl;
@property (nonatomic,strong) NSString * shareTitle;
@property (nonatomic,strong) NSString * shareDescription;
@property (nonatomic,strong) NSString * videoCover;
@property (nonatomic,strong) NSArray * tags;
@property (nonatomic,strong) NSString * deposit;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFCarAttrDetailModel : NSObject

@property (nonatomic,strong) NSString * drive;
@property (nonatomic,strong) NSString * output;
@property (nonatomic,strong) NSString * gear;
@property (nonatomic,strong) NSArray * seats;
@property (nonatomic,strong) NSString * firm;
@property (nonatomic,strong) NSString * kidney;
@property (nonatomic,strong) NSArray * stereotype;
- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFCarLevelDetailModel : NSObject

@property (nonatomic,strong) NSString * minDay;
@property (nonatomic,strong) NSString * maxDay;
@property (nonatomic,strong) NSString * zk;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFCarPriceMapDetailModel : NSObject

@property (nonatomic,strong) NSString * areaId;
@property (nonatomic,strong) NSString * price;

- (id) initWithDic:(NSDictionary *)dic;

@end

