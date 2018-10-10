//
//  UIView+Category.m
//  LuxuryCar
//
//  Created by Hcar on 2017/8/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

+(instancetype)initWithShadowViewFrame:(CGRect)frame shadowRadius:(NSInteger)shadowRadius{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.layer.cornerRadius = shadowRadius; //设置imageView的圆角
    view.layer.masksToBounds = YES;
    view.backgroundColor  = kWhiteColor;
    
    UIView *shadowView = [[UIView alloc]initWithFrame:view.frame];
    
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    
    shadowView.layer.shadowOpacity = 0.15;
    
    shadowView.layer.shadowRadius = shadowRadius;
    
    shadowView.layer.cornerRadius = shadowRadius;
    
    shadowView.clipsToBounds = NO;
    
    [shadowView addSubview:view];
    return shadowView;
}

+(instancetype)initWithLineView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor  = klineColor;
    return view;
}


@end
