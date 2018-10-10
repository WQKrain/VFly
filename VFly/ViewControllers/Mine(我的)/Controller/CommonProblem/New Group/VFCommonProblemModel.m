//
//  VFCommonProblemModel.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCommonProblemModel.h"

@implementation VFCommonProblemModel

- (id) initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.data = dic[@"data"];
        self.code = dic[@"code"];
    }
    return self;
}

@end

@implementation VFCommonProblmTitleModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.children = dic[@"children"];
        self.name = dic[@"name"];
    }
    return self;
}

@end

@implementation  VFCommonProblmListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
    }
    return self;
}



@end
