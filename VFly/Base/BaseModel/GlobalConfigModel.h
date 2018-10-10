//
//  GlobalConfigModel.h
//  VFeng
//
//  Created by Hcar on 2017/6/1.
//  Copyright © 2017年 Hcar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalConfigModel : NSObject

@property (nonatomic,strong) NSString * customerServiceTel;
@property (nonatomic,strong) NSString * activityUrl;
@property (nonatomic,strong) NSString * agreementUrl;
@property (nonatomic,strong) NSString * problemUrl;
@property (nonatomic,strong) NSArray * useType;
@property (nonatomic,strong) NSString * lastVersion;
@property (nonatomic,strong) NSString * isUpdate;
@property (nonatomic,strong) NSString * updateUrl;
@property (nonatomic,strong) NSString * des;

@property (nonatomic,strong) NSString * cPay;
@property (nonatomic,strong) NSString * cRental;
@property (nonatomic,strong) NSString * cUser;
@property (nonatomic,strong) NSDictionary * burl;

@property (nonatomic,strong) NSString * shareDomain;
@property (nonatomic,strong) NSString * shareText;
@property (nonatomic,strong) NSString * shareIcon;
@property (nonatomic,strong) NSString * shareTitle;
@property (nonatomic,strong) NSArray * job;
@property (nonatomic,strong) NSArray * record;
@property (nonatomic,strong) NSString * scoreActivityPoint;
@property (nonatomic,strong) NSString * frontMoneyPoint;
@property (nonatomic,strong) NSString * vipProblem;
@property (nonatomic,strong) NSString * scoreProblemUrl;
@property (nonatomic,strong) NSString * homeImage;
@property (nonatomic,strong) NSString * homeImageUrl;
@property (nonatomic,strong) NSString * serviceFeeUrl;
@property (nonatomic,strong) NSString * signAuthorizationUrl;
@property (nonatomic,strong) NSString * freeDepositUrl;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface bUrlList : NSObject

@property (nonatomic,strong) NSString * main;
@property (nonatomic,strong) NSString * wait;
@property (nonatomic,strong) NSString * regist;
@property (nonatomic,strong) NSString * broot;

- (id) initWithDic:(NSDictionary *)dic;

@end
