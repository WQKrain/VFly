//
//  VFAvailableCouponsModel.h
//  VFly
//
//  Created by Hcar on 2018/4/14.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFAvailableCouponsModel : NSObject

@property (nonatomic,strong) NSString * couponsID;
@property (nonatomic,strong) NSString * useable;
@property (nonatomic,strong) NSString * create_time;
@property (nonatomic,strong) NSString * end_time;
@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * mk;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString * style;

- (id) initWithDic:(NSDictionary *)dic;

@end
