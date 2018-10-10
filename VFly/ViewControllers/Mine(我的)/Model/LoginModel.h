//
//  LoginModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/2.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * credit;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * headImg;
@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString * order;
@property (nonatomic,strong) NSString * card;
@property (nonatomic,strong) NSString * bankCard;
@property (nonatomic,strong) NSString * bindTime;
@property (nonatomic,strong) NSString * score;
@property (nonatomic,strong) NSString * vipLevel;
@property (nonatomic,strong) NSString * vipScorePoint;
@property (nonatomic,strong) NSString * pushid;
@property (nonatomic,strong) NSString * firstLogin;

- (id) initWithDic:(NSDictionary *)dic;

@end


@interface VFLoginModel : NSObject

@property (nonatomic,strong) NSString * token;
- (id) initWithDic:(NSDictionary *)dic;

@end
