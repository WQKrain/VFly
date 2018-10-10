//
//  VipInfoModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipInfoModel : NSObject
@property (nonatomic, strong) NSString *vipLevel;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *expireTime;
@property (nonatomic, strong) NSString *expireTimestamp;
@property (nonatomic, strong) NSString *vipMoney;
@property (nonatomic, strong) NSString *freeDays;
@property (nonatomic, strong) NSString *goUpStatus;
@property (nonatomic, strong) NSString *vipImage;
@property (nonatomic, strong) NSString *tqImage;
- (id) initWithDic:(NSDictionary *)dic;
@end
