//
//  VFDefaultPageView.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/11.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DefaultPageBtnClickBlock)();

@interface VFDefaultPageView : UIView

@property (nonatomic, copy) DefaultPageBtnClickBlock DefaultPageBtnClickHandler;
@property (nonatomic, strong) UIImageView *showImage;
@property (nonatomic, strong) UILabel *showlabel;
@property (nonatomic, strong) UIButton *showButton;

- (void)layoutView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
