//
//  couponModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/20.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface couponModel : NSObject

@property (nonatomic,strong) NSArray * couponList;
@property (nonatomic,strong) NSString * remainder;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface newCouponListModel : NSObject

@property (nonatomic,strong) NSString * listID;
@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * mk;
@property (nonatomic,strong) NSString * startTime;
@property (nonatomic,strong) NSString * endTime;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString * style;

- (id) initWithDic:(NSDictionary *)dic;

@end


@interface couponListModel : NSObject

@property (nonatomic,strong) NSString * listID;
@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * mk;
@property (nonatomic,strong) NSString * startTime;
@property (nonatomic,strong) NSString * endTime;
@property (nonatomic,strong) NSString * startTimestamp;
@property (nonatomic,strong) NSString * endTimestamp;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString * style;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface chooseCouponListModel : NSObject

@property (nonatomic,strong) NSString * cardID;
@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * mk;
@property (nonatomic,strong) NSString * startTimestamp;
@property (nonatomic,strong) NSString * endTimestamp;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString * useable;
@property (nonatomic,strong) NSString * usableCount;
@property (nonatomic,strong) NSString * style;

- (id) initWithDic:(NSDictionary *)dic;

@end
