//
//  HCBannerModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/5/9.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCBannerModel : NSObject

@property (nonatomic, strong) NSArray * bannerList;

- (id) initWithDic:(NSDictionary *)dic;

@end
