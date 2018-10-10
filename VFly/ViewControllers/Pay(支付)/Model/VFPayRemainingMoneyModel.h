//
//  VFPayRemainingMoneyModel.h
//  VFly
//
//  Created by Hcar on 2018/4/19.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFPayRemainingMoneyModel : NSObject

@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSArray * lists;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFPayRemainingMoneyListModel : NSObject

@property (nonatomic,strong) NSString * item;
@property (nonatomic,strong) NSString * should_pay_id;
@property (nonatomic,strong) NSString * should_pay;
@property (nonatomic,strong) NSString * lists;
@property (nonatomic,strong) NSString * handler;
@property (nonatomic,strong) NSString * unpay;

- (id) initWithDic:(NSDictionary *)dic;

@end
