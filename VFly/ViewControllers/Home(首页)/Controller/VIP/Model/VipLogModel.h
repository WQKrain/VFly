//
//  VipLogModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipLogModel : NSObject

@property (nonatomic, strong) NSArray *logList;
@property (nonatomic, strong) NSString *remainder;

- (id) initWithDic:(NSDictionary *)dic;

@end


@interface VipLogListModel : NSObject

@property (nonatomic, strong) NSString *change;
@property (nonatomic, strong) NSString *markid;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *balance;

- (id) initWithDic:(NSDictionary *)dic;

@end
