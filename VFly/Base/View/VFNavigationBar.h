//
//  VFNavigationBar.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NavBtnClickBlock)(void);
@interface VFNavigationBar : UIView
@property (nonatomic , strong)UIView *leftView;
@property (nonatomic , strong)UIView *rightView;
@property (nonatomic , strong)UIView *centerView;
@property (nonatomic , strong)UIView *navView;
@property (nonatomic , strong)UIImageView *backImage;
@property (strong, nonatomic) UIImageView *navRightImage;

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *navlineImage;

@property (nonatomic, copy) NavBtnClickBlock leftBtnClickHandler;
@property (nonatomic, copy) NavBtnClickBlock rightBtnClickHandler;

@end
