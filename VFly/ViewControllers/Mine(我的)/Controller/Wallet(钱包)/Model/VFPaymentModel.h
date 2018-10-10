//
//  VFPaymentModel.h
//  VFly
//
//  Created by Hcar on 2018/4/27.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFPaymentModel : NSObject

@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * handler;
@property (nonatomic,strong) NSString * should_pay_id;

- (id) initWithDic:(NSDictionary *)dic;

@end
