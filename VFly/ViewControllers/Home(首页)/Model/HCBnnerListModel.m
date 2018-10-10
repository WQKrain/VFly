//
//  HCBnnerListModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/5/9.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "HCBnnerListModel.h"

@implementation HCBnnerListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.url = dic[@"url"];
        self.action = dic[@"action"];
    }
    return self;
}


@end
