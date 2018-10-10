//
//  TabBarControllerConfig.m
//  VFly
//
//  Created by 毕博洋 on 2018/8/23.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "TabBarControllerConfig.h"

@implementation CYLBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //  设置状态栏颜色
        if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleDefault) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }
    [super pushViewController:viewController animated:animated];
}

@end

#import "HomeGroupedViewController.h"
#import "RentCarViewController.h"
#import "VFServiceViewController.h"
#import "MineViewController.h"

@implementation TabBarControllerConfig






@end
