//
//  CityModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/8/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property (nonatomic,strong) NSString * cityId;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSArray * child;
    
- (id) initWithDic:(NSDictionary *)dic;
@end
