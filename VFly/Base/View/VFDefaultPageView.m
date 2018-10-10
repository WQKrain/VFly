//
//  VFDefaultPageView.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/11.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFDefaultPageView.h"

@implementation VFDefaultPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showImage = [[UIImageView alloc]init];
        _showImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_showImage];
        
        _showlabel = [UILabel initWithFont:kTitleBigSize textColor:kTitleBoldColor];
        [_showlabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
        _showlabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_showlabel];
        
        _showButton = [UIButton buttonWithTitle:@""];
        [_showButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showButton];
        
        [_showImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(kSpaceH(80));
            make.width.mas_equalTo(kSpaceW(183.0));
            make.height.mas_equalTo(kScreenW/kSpaceW(183.0)*47);
        }];
        
        [_showlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_showImage.mas_bottom).offset(kSpaceH(15));
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(20);
        }];
        
        [_showButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_showlabel.mas_bottom).offset(10);
            make.width.mas_equalTo(165);
            make.height.mas_equalTo(44);
        }];
        
    }
    return self;
}

- (void)layoutView{
    [_showImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(kSpaceH(80));
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(201);
    }];
    
    [_showlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_showImage.mas_bottom).offset(kSpaceH(15));
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    [_showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(kSpaceH(-60));
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(44);
    }];
}

- (void)buttonClick{
    if (_DefaultPageBtnClickHandler) {
        _DefaultPageBtnClickHandler();
    }
}

@end
