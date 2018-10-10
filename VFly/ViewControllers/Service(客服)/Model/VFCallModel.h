//
//  VFCallModel.h
//  LuxuryCar
//
//  Created by Hcar on 2018/1/25.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFCallModel : NSObject

@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * tel;

- (id) initWithDic:(NSDictionary *)dic;

@end
