//
//  DrawMoneyModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawMoneyModel : NSObject

@property (nonatomic,strong) NSDictionary * cardInfo;
@property (nonatomic,strong) NSString * money;
@property (nonatomic,strong) NSString * times;



- (id) initWithDic:(NSDictionary *)dic;
@end

@interface DrawMoneyCardListModel : NSObject

@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * cardId;
@property (nonatomic,strong) NSString * bank;
@property (nonatomic,strong) NSString * card;

- (id) initWithDic:(NSDictionary *)dic;


@end
