//
//  VFProblmModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/12.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFProblmModel.h"

@implementation VFProblmModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.data = dic[@"data"];
        self.code = dic[@"code"];
    }
    return self;
}

@end

@implementation VFProblmTitleModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.children = dic[@"children"];
        self.name = dic[@"name"];
    }
    return self;
}

@end

@implementation  VFProblmListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
    }
    return self;
}

@end
