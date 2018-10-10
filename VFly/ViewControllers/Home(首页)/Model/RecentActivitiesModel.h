//
//  RecentActivitiesModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentActivitiesModel : NSObject
@property (nonatomic,strong) NSArray * newsList;
@property (nonatomic,strong) NSString * remainder;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface RecentActivitiesListModel : NSObject
@property (nonatomic,strong) NSString * actionId;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString * view;
@property (nonatomic,strong) NSString * action;
@property (nonatomic,strong) NSString * time;
@property (nonatomic,strong) NSString * actionDescription;
- (id) initWithDic:(NSDictionary *)dic;
@end


@interface activitiesModel : NSObject
@property (nonatomic,strong) NSArray * activityList;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface activitiesListModel : NSObject

@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString * time;
@property (nonatomic,strong) NSString * activitiesId;
@property (nonatomic,strong) NSString * view;
@property (nonatomic,strong) NSString * action;

- (id) initWithDic:(NSDictionary *)dic;
@end



