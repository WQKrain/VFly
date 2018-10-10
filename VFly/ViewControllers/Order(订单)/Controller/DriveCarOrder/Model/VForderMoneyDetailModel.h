//
//  VForderMoneyDetailModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/24.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VForderMoneyDetailModel : NSObject

@property (nonatomic,strong) NSString * days;
@property (nonatomic,strong) NSString * frontMoney;
@property (nonatomic,strong) NSString * rentalMoney;
@property (nonatomic,strong) NSString * depositMoney;
@property (nonatomic,strong) NSString * illegalMoney;
@property (nonatomic,strong) NSString * longRentalDiscount;
@property (nonatomic,strong) NSString * vipDiscount;
@property (nonatomic,strong) NSString * dayRental;
@property (nonatomic,strong) NSArray * level;
@property (nonatomic,strong) NSString * vipZk;
- (id)initWithDic:(NSDictionary *)dic;

@end

@interface VForderMoneyDetailLevelModel : NSObject

@property (nonatomic,strong) NSString * minDay;
@property (nonatomic,strong) NSString * maxDay;
@property (nonatomic,strong) NSString * zk;

- (id) initWithDic:(NSDictionary *)dic;

@end
