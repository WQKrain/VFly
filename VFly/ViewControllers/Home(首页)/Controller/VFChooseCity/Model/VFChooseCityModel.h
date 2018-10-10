//
//  VFChooseCityModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFChooseCityModel : NSObject

@property (nonatomic,strong) NSString * cityID;
@property (nonatomic,strong) NSString * pid;
@property (nonatomic,strong) NSString * shortname;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * mergerName;
@property (nonatomic,strong) NSString * level;
@property (nonatomic,strong) NSString * pinyin;
@property (nonatomic,strong) NSString * first;
@property (nonatomic,strong) NSString * lng;
@property (nonatomic,strong) NSString * lat;

- (id) initWithDic:(NSDictionary *)dic;

@end
