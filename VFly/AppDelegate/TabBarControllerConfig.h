//
//  TabBarControllerConfig.h
//  VFly
//
//  Created by 毕博洋 on 2018/8/23.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"

@interface CYLBaseNavigationController : UINavigationController

@end
@interface TabBarControllerConfig : NSObject

@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;

@end
