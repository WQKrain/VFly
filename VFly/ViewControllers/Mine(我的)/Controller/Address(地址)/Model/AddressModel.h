//
//  AddressModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic,strong) NSArray * addressList;
@property (nonatomic,strong) NSString * remainder;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface AddressListModel : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * addressID;
@property (nonatomic,strong) NSString * cityId;

- (id) initWithDic:(NSDictionary *)dic;

@end
