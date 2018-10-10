//
//  VipOrderModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipOrderModel : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *money;

- (id) initWithDic:(NSDictionary *)dic;

@end
