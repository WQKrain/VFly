//
//  VFUseCarUseeListModel.m
//  VFly
//
//  Created by Hcar on 2018/4/11.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFUseCarUseeListModel.h"

@implementation VFUseCarUseeListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.card_back = dic[@"card_back"];
        self.card_face = dic[@"card_face"];
        self.driving_licence = dic[@"driving_licence"];
        self.mobile = dic[@"mobile"];
        self.nick_name = dic[@"nick_name"];
        self.status = dic[@"status"];
        self.useman_id = dic[@"useman_id"];
    }
    return self;
}

@end
