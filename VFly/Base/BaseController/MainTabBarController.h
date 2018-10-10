//
//  MainTabBarController.h
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VFBaseNavigationController : UINavigationController

@end
@interface MainTabBarController : UITabBarController

@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) anyButton *selectedBtn;

@end
