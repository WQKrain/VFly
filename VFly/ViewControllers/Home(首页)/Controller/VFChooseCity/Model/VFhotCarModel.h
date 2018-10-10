//
//  VFhotCarModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFhotCarModel : NSObject

@property (nonatomic,strong) NSArray * hotCitys;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFhotCarListModel : NSObject

@property (nonatomic,strong) NSString * cityID;
@property (nonatomic,strong) NSString * shortname;

- (id) initWithDic:(NSDictionary *)dic;

@end
