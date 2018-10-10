//
//  RecentActivitiesModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "RecentActivitiesModel.h"

@implementation RecentActivitiesModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.newsList = dic[@"newsList"];
        self.remainder = dic[@"remainder"];
    }
    return self;
}
@end

@implementation activitiesModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.activityList = dic[@"activityList"];
    }
    return self;
}
@end


@implementation RecentActivitiesListModel
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.actionId = dic[@"id"];
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.url = dic[@"url"];
        self.view = dic[@"view"];
        self.action = dic[@"action"];
        self.time = dic[@"time"];
        self.actionDescription = dic[@"description"];
    }
    return self;
}

@end

@implementation activitiesListModel
- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.url = dic[@"url"];
        self.time = dic[@"time"];
        self.activitiesId = dic[@"id"];
        self.view = dic[@"view"];
        self.action = dic[@"action"];
    }
    return self;
}

@end

