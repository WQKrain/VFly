//
//  UILabel+Extension.h
//  LuxuryCar
//
//  Created by Hcar on 2017/8/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+(instancetype)initWithTitle:(NSString *)title withFont:(NSInteger)font textColor:(UIColor *)color;
+(instancetype)initWithFont:(NSInteger)font textColor:(UIColor *)color;

+(instancetype)initWithNavTitle:(NSString *)title;

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
