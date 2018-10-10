//
//  VFLastOrderModel.h
//  VFly
//
//  Created by Hcar on 2018/4/17.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFLastOrderModel : NSObject


@property (nonatomic,strong) NSString * brand;
@property (nonatomic,strong) NSString * model;
@property (nonatomic,strong) NSString * car_img;
@property (nonatomic,strong) NSString * re_day_rental;
@property (nonatomic,strong) NSString * status;
@property (nonatomic, copy) NSString *status_text;
@property (nonatomic,strong) NSString * order_id;

- (id) initWithDic:(NSDictionary *)dic;

@end
