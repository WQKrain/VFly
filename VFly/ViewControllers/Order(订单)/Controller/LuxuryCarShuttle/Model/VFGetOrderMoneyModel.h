//
//  VFGetOrderMoneyModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/23.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFGetOrderMoneyModel : NSObject

@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * expire;
@property (nonatomic,strong) NSString * canDiscountMoney;

- (id) initWithDic:(NSDictionary *)dic;



@end
