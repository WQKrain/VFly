//
//  VFSuttleOrderDetailModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFSuttleOrderDetailModel : NSObject

@property (nonatomic,strong) NSString * expire;
@property (nonatomic,strong) NSString * rental;
@property (nonatomic,strong) NSString * vipDiscount;

- (id) initWithDic:(NSDictionary *)dic;

@end
