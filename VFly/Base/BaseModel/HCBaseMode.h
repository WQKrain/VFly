//
//  HCBaseMode.h
//  LuxuryCar
//
//  Created by Hcar on 2017/5/9.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCBaseMode : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSDictionary * data;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFBaseMode : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSDictionary *data;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFBaseListMode : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray *data;
- (id) initWithDic:(NSDictionary *)dic;
@end
