//
//  MyProfileModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProfileModel : NSObject

@property (nonatomic,strong)NSArray * creditList;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface MyProfileListModel : NSObject

@property (nonatomic,strong) NSString * info;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSDictionary * data;

- (id) initWithDic:(NSDictionary *)dic;

@end
