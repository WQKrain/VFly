//
//  StarModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarModel : NSObject
@property (nonatomic,strong) NSArray * starList;
@property (nonatomic,strong) NSString * remainder;
- (id) initWithDic:(NSDictionary *)dic;

@end

@interface StarListModel : NSObject
@property (nonatomic,strong) NSString * carId;
@property (nonatomic,strong) NSString * drive;
@property (nonatomic,strong) NSString * gear;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * output;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * seats;
@property (nonatomic,strong) NSArray * tags;
- (id) initWithDic:(NSDictionary *)dic;
@end

