//
//  ChangeCityTool.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/7.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ChangeCityTool.h"

@implementation ChangeCityTool

+(instancetype)changeCity{
    static ChangeCityTool * __location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __location = [[self alloc] init];
    });
    return __location;
}
    
- (instancetype)init
    {
        self = [super init];
        if (self) {
            self.city = @"杭州市";
        }
        return self;
    }

    
@end
