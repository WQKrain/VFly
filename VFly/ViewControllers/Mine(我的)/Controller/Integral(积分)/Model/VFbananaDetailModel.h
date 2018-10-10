//
//  VFbananaDetailModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/10.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFbananaDetailModel : NSObject

@property (nonatomic,strong) NSDictionary *logDetail;
- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFbananaDetailPayModel : NSObject

@property (nonatomic,strong) NSString * change;
@property (nonatomic,strong) NSString * logId;
@property (nonatomic,strong) NSString * cid;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * des;
@property (nonatomic,strong) NSString * balance;

- (id) initWithDic:(NSDictionary *)dic;

@end
