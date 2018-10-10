//
//  HCBnnerListModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/5/9.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCBnnerListModel : NSObject

@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * action;


- (id) initWithDic:(NSDictionary *)dic;

@end
