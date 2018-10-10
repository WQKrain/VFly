//
//  MessageNoticeModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MessageNoticeModel.h"

@implementation MessageNoticeModel
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.messageList = dic[@"notifyList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}
@end

@implementation MessageNoticeListModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.messageID = dic[@"id"];
        self.title = dic[@"title"];
        self.text = dic[@"text"];
        self.image = dic[@"image"];
        self.createTime = dic[@"createTime"];
        self.url = dic[@"url"];
        self.extends = dic[@"extends"];
    }
    return self;
}
@end
