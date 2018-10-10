//
//  VFFreeCreditModel.h
//  VFly
//
//  Created by Hcar on 2018/4/27.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFFreeCreditModel : NSObject

@property (nonatomic,strong) NSString * score;
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * bankcard;
@property (nonatomic,strong) NSString * bank_mobile;
@property (nonatomic,strong) NSString * card_num;
@property (nonatomic,strong) NSString * card_face;
@property (nonatomic,strong) NSString * card_back;
@property (nonatomic,strong) NSString * driving_licence;
@property (nonatomic,strong) NSString * family_register;
@property (nonatomic,strong) NSString * house;
@property (nonatomic,strong) NSString * car;
@property (nonatomic,strong) NSString * company;
@property (nonatomic,strong) NSString * other;

- (id) initWithDic:(NSDictionary *)dic;

@end
