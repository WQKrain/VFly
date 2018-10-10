//
//  VipModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/26.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipModel : NSObject

//@property (nonatomic, strong) NSString *status;
//@property (nonatomic, strong) NSString *vip;
@property (nonatomic, strong) NSArray *vipList;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface  VipListModel: NSObject
@property (nonatomic,strong) NSString * birthdayZk;
@property (nonatomic,strong) NSString * freeDays;
@property (nonatomic,strong) NSString * imageGood;
@property (nonatomic,strong) NSString * imageMain;
@property (nonatomic,strong) NSString * level;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * scorePoint;
@property (nonatomic,strong) NSString * sendKm;
@property (nonatomic,strong) NSString * usablePrice;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString * useKm;
@property (nonatomic,strong) NSString * zk;

- (id) initWithDic:(NSDictionary *)dic;


@end
