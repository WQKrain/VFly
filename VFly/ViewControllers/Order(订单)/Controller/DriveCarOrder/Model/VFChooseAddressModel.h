//
//  VFChooseAddressModel.h
//  VFly
//
//  Created by Hcar on 2018/4/19.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFChooseAddressModel : NSObject

@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * address_id;
@property (nonatomic,strong) NSString * district_id;
@property (nonatomic,strong) NSString * last_use_time;

- (id)initWithDic:(NSDictionary *)dic;

@end
