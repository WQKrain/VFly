//
//  VFRenewMapModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/16.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFRenewMapModel : NSObject
@property (nonatomic,strong) NSString * dayRental;
@property (nonatomic,strong) NSString * vipZk;
@property (nonatomic,strong) NSArray * level;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFRenewMapLevelModel : NSObject
@property (nonatomic,strong) NSString *minDay;
@property (nonatomic,strong) NSString *maxDay;
@property (nonatomic,strong) NSString *zk;
- (id) initWithDic:(NSDictionary *)dic;
@end
