//
//  VFRenewApplyModel.h
//  VFly
//
//  Created by Hcar on 2018/4/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFRenewApplyModel : NSObject

@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSString * should_pay_id;
@property (nonatomic,strong) NSString * money;

- (id) initWithDic:(NSDictionary *)dic;

@end
