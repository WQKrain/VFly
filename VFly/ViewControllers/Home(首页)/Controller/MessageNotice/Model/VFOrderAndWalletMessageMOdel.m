//
//  VFOrderAndWalletMessageMOdel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFOrderAndWalletMessageMOdel.h"

@implementation VFOrderAndWalletMessageMOdel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.messageList = dic[@"messageList"];
    }
    return self;
}


@end

@implementation VFOrderAndWalletMessageListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.messageID = dic[@"id"];
        self.title = dic[@"title"];
        self.text = dic[@"text"];
        self.image = dic[@"image"];
        self.createTime = dic[@"create_time"];
        self.otherStatus = [dic[@"other_status"] integerValue];
        self.extends = dic[@"extends"];
    }
    return self;
}
@end

@implementation VFOrderAndWalletMessageExtendsModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.orderId = dic[@"orderId"];
        self.type = dic[@"type"];
        self.logId = dic[@"logId"];
    }
    return self;
}
@end

