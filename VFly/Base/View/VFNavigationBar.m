//
//  VFNavigationBar.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFNavigationBar.h"

@implementation VFNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44+kStatutesBarH)];
        _navView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_navView];
        
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, kStatutesBarH+11, 22,22)];
        _backImage.image = [UIImage imageNamed:@"icon_back_black"];
        [_navView addSubview:_backImage];
        
        _rightLabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kTextBlueColor];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.frame = CGRectMake(kScreenW-200, kStatutesBarH+11, 185, 22);
        [_navView addSubview:_rightLabel];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightBtn = rightButton;
        [_navView addSubview:rightButton];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(kStatutesBarH);
        }];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, kStatutesBarH, 80, 44);
        [_leftBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_leftBtn];
        
        _navRightImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-37, kStatutesBarH+11, 22,22)];
        [_navView addSubview:_navRightImage];
        
        UILabel * titleLabel= [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kTitleBoldColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:kBlodFont size:kTitleBigSize];
        [_navView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_navView);
            make.top.mas_equalTo(kStatutesBarH+12);
            make.height.mas_equalTo(kTitleSize);
        }];
        
        _titleLabel = titleLabel;
        
        _navlineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line_nav"]];
        [_navView addSubview:_navlineImage];
        [_navlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(_navView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setTitleLabel:(NSString *)str {
    self.titleLabel.text = str;
}

- (void)backButtonClick{
    if (_leftBtnClickHandler) {
        _leftBtnClickHandler();
    }
}

- (void)rightButtonClick{
    if (_rightBtnClickHandler) {
        _rightBtnClickHandler();
    }
}

@end
