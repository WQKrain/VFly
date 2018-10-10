//
//  VFRegistHXModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/12.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFRegistHXModel : NSObject

@property (nonatomic, strong) NSString * activated;
@property (nonatomic, strong) NSString * created;
@property (nonatomic, strong) NSString * modified;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * uuid;

- (id) initWithDic:(NSDictionary *)dic;

@end
