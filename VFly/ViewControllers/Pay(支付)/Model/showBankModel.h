//
//  showBankModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/8/4.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface showBankModel : NSObject

@property (nonatomic,strong) NSArray * list;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface showBankListModel : NSObject

@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * bank;
@property (nonatomic,strong) NSString * singleLimit;
@property (nonatomic,strong) NSString * dayLimit;
@property (nonatomic,strong) NSString * brief;

- (id) initWithDic:(NSDictionary *)dic;

@end
