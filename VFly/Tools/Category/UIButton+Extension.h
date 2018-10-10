//
//  UIButton+Extension.h
//  TestHealthDemo
//
//  Created by 983135621@qq.com on 16/12/26.
//  Copyright © 2016年 983135621@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+(instancetype)buttonWithTitle:(NSString *)title sel:(SEL)sel target:(id)target;
+(instancetype)buttonWithTitle:(NSString *)title;
+(void)setButtonContentCenter:(UIButton *)button;
+(instancetype)newButtonWithTitle:(NSString *)title sel:(SEL)sel target:(id)target cornerRadius:(BOOL)cornerRadius;
@end
