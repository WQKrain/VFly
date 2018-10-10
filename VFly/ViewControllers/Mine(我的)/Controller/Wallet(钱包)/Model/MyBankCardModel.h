//
//  MyBankCardModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/17.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBankCardModel : NSObject
@property (nonatomic,strong) NSArray * bankCardList;
@property (nonatomic,strong) NSString * remainder;

- (id) initWithDic:(NSDictionary *)dic;


@end

@interface MyBankCardListModel : NSObject

@property (nonatomic,strong) NSString * bank;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * cardType;
@property (nonatomic,strong) NSString * bankCard;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * carId;
@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * card;
@property (nonatomic,strong) NSString * singleLimit;
@property (nonatomic,strong) NSString * dayLimit;
@property (nonatomic,strong) NSString * monthLimit;
@property (nonatomic,strong) NSString * brief;
@property (nonatomic,strong) NSString * backImage;


- (id) initWithDic:(NSDictionary *)dic;


@end
