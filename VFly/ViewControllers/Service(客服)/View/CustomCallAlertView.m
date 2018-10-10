//
//  CustomAlertView.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/8.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "CustomCallAlertView.h"

// RGB颜色转换（16进制->10进制）
#define ColorWithHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation CustomCallAlertView

- (id)initWithTitle:(NSString *)title withMsg:(NSString *)msg withCancel:(NSString *)cancel withSure:(NSString *)sure
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.frame = [UIScreen mainScreen].bounds;
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-140, self.bounds.size.height/2-100, 280, 182)];
        alertView.backgroundColor = [UIColor grayColor];
        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 4;
//        alertView.backgroundColor = ColorWithHexRGB(0Xeeeeee);
        alertView.backgroundColor = ColorWithHexRGB(0Xdddddd);
        [self addSubview:alertView];
        NSArray *dataArr = @[@"在线客服",@"拨打电话",@"稍后咨询"];
        for (int i = 0; i<3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 61*i, 280, 60);
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:dataArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [alertView addSubview:button];
        }
        //仿照这个
//        [UIView animateWithDuration:2 animations:^{
//            alertView.frame = CGRectMake(self.bounds.size.width/2-140, self.bounds.size.height/2-100, 280, 200);
//        }];
        //        alertView.layer.borderWidth = 1;
        //        alertView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    return self;
}

- (void)alertViewShow
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    
    
}

- (void)btnClick:(UIButton *)btn
{
    //    点击btn的时候要把用户点击的那个btn的tag值传出去
//    if (self.alertViewBlock)
//    {
//        self.alertViewBlock(btn.tag);
//    }
    //    先把这个弹出框从父视图上移除
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertAction:)]) {
        [self.delegate alertAction:btn.tag];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

@end
