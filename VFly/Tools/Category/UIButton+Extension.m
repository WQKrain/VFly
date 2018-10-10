//
//  UIButton+Extension.m
//  TestHealthDemo
//
//  Created by 983135621@qq.com on 16/12/26.
//  Copyright © 2016年 983135621@qq.com. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+(instancetype)buttonWithTitle:(NSString *)title sel:(SEL)sel target:(id)target{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    button.backgroundColor = kMainColor;
    
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(instancetype)buttonWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kMainColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    button.layer.borderColor = kMainColor.CGColor;
    button.layer.borderWidth = 1;
    return button;
}

#pragma mark 按钮图片文字垂直居中排列
+(void)setButtonContentCenter:(UIButton *)button
{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    
    //设置按钮内边距
    imgViewSize = button.imageView.bounds.size;
    titleSize = button.titleLabel.bounds.size;
    btnSize = button.bounds.size;
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [button setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    [button setTitleEdgeInsets:titleEdge];
}

+(instancetype)newButtonWithTitle:(NSString *)title sel:(SEL)sel target:(id)target cornerRadius:(BOOL)cornerRadius{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    button.backgroundColor = kNewButtonColor;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    if (cornerRadius) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
    }
    return button;
}


@end
