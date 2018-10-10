//
//  VFUseCarUseeListModel.h
//  VFly
//
//  Created by Hcar on 2018/4/11.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFUseCarUseeListModel : NSObject

@property (nonatomic,strong) NSString * card_back;
@property (nonatomic,strong) NSString * card_face;
@property (nonatomic,strong) NSString * driving_licence;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * nick_name;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * useman_id;
- (id)initWithDic:(NSDictionary *)dic;

@end
