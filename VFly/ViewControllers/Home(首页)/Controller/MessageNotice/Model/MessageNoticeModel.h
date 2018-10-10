//
//  MessageNoticeModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageNoticeModel : NSObject
@property (nonatomic,strong) NSArray * messageList;
@property (nonatomic,strong) NSString * remainder;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface MessageNoticeListModel : NSObject

@property (nonatomic,strong) NSString * messageID;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString * extends;

- (id) initWithDic:(NSDictionary *)dic;
@end
