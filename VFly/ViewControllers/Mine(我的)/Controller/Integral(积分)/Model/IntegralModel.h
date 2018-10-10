//
//  IntegralModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralModel : NSObject

@property (nonatomic,strong)NSArray * logList;
@property (nonatomic , strong)NSString *remainder;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface IntegralListModel : NSObject

@property (nonatomic,strong) NSString * integralId;
@property (nonatomic,strong) NSString * change;
@property (nonatomic,strong) NSString * use;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * scoreBalance;

- (id) initWithDic:(NSDictionary *)dic;

@end
