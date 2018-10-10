//
//  BaseNavigationController.h
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavBackDelegate <NSObject>
//2.声明代理类需要实现的方法列表
@optional
- (void)navBackBtnClick;
@end


@interface BaseNavigationController : UINavigationController

@property (nonatomic,retain) id <NavBackDelegate> backDelegate;

@end
