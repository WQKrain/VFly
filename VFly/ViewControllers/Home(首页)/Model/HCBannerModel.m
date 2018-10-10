//
//  HCBannerModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/5/9.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "HCBannerModel.h"

@implementation HCBannerModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        if([dic objectForKey:@"bannerList"]){
            self.bannerList = dic[@"bannerList"];
        }
    }
    return self;
}


@end
