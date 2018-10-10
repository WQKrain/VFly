//
//  BananaDetailModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BananaDetailModel : NSObject
@property (nonatomic,strong) NSArray * logList;
@property (nonatomic,strong) NSString * remainder;


- (id) initWithDic:(NSDictionary *)dic;
@end

@interface BananaDetailListModel : NSObject

@property (nonatomic,strong) NSString * change;
@property (nonatomic,strong) NSString * logId;
@property (nonatomic,strong) NSString * cid;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * des;

- (id) initWithDic:(NSDictionary *)dic;


@end
