//
//  BaseViewController.h
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
@class VFNavigationBar;

typedef NS_OPTIONS(NSUInteger, HYHidenControlOptions) {
    
    HYHidenControlOptionLeft = 0x01,
    HYHidenControlOptionTitle = 0x01 << 1,
    HYHidenControlOptionRight = 0x01 << 2,
    
};

@protocol UIViewControllerNetworkListening <NSObject>

@optional
- (void)networkChanged:(id)info;
@end

@interface BaseViewController : UIViewController<UIViewControllerNetworkListening>
@property (nonatomic, copy)   NSString * titleStr;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *navRightLabel;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIImageView *navRightImage;
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UIImageView *navlineImage;
@property (nonatomic, strong) VFNavigationBar *navigationBar; // 自定义的导航栏
@property (nonatomic, assign) BOOL navSandow;
@property (nonatomic, assign) BOOL navBottomImageHidden;
@property (nonatomic, copy) NSString *centerBlodTitle;
@property (nonatomic, copy) NSString *UMPageStatistical;

- (void)replaceDefaultNavBar:(UIView *)nav;

- (void)setKeyScrollView:(UIScrollView * )keyScrollView scrolOffsetY:(CGFloat)scrolOffsetY options:(HYHidenControlOptions)options;

@end
