//
//  AppConstant.m
//  VFly
//
//  Created by 毕博洋 on 2018/7/16.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "AppConstant.h"

@implementation AppConstant


#ifdef DEBUG
NSString *const VF_BaseUrl                 =     @"https://test.weifengchuxing.com/api/";
#else
NSString *const VF_BaseUrl                 =     @"https://api2.weifengchuxing.com/api/";
#endif

NSString *const VF_LocalCityID              =     @"kLocalCityID";
NSString *const VF_NetworkConnectionState   =     @"NetworkConnectionState";
NSString *const VF_ReachableViaWiFi         =     @"ReachableViaWiFi";
NSString *const VF_ReachableViaWWAN         =     @"ReachableViaWWAN";
NSString *const VF_NotReachable             =     @"NotReachable";
NSString *const VF_Unknown                  =     @"Unknown";











@end
