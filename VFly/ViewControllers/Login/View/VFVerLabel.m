//
//  VFVerLabel.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/12.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFVerLabel.h"

@implementation VFVerLabel

//重写setText方法，当text改变时手动调用drawRect方法，将text的内容按指定的格式绘制到label上
- (void)setText:(NSString *)text {
    [super setText:text];
    // 手动调用drawRect方法
    [self setNeedsDisplay];
}

// 按照指定的格式绘制验证码/密码
- (void)drawRect:(CGRect)rect1 {
    //计算每位验证码/密码的所在区域的宽和高
    CGRect rect = CGRectMake(0,0,kScreenW - 40,80);
    float width = rect.size.width / (float)self.numberOfVertificationCode;
    float height = rect.size.height;
        
    // 将每位验证码/密码绘制到指定区域
    for (int i =0; i <self.text.length; i++)
    {
        // 计算每位验证码/密码的绘制区域
        CGRect tempRect =CGRectMake(i * width,0, width, height);
        if (self.secureTextEntry) {//密码，显示圆点
            UIImage *dotImage = [UIImage imageNamed:@"dot"];
            // 计算圆点的绘制区域
            CGPoint securityDotDrawStartPoint =CGPointMake(width * i + (width - dotImage.size.width) /2.0, (tempRect.size.height - dotImage.size.height) / 2.0);
            // 绘制圆点
            [dotImage drawAtPoint:securityDotDrawStartPoint];
        }
        else
        {//验证码，显示数字
            // 遍历验证码/密码的每个字符
            NSString *charecterString = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]];
            // 设置验证码/密码的现实属性
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
            attributes[NSFontAttributeName] = self.font;
            
            // 计算每位验证码/密码的绘制起点（为了使验证码/密码位于tempRect的中部，不应该从tempRect的重点开始绘制）
            // 计算每位验证码/密码的在指定样式下的size
            CGSize characterSize = [charecterString sizeWithAttributes:attributes];
            CGPoint vertificationCodeDrawStartPoint =CGPointMake(width * i + (width - characterSize.width) /2.0, (tempRect.size.height - characterSize.height) /2.0);
            // 绘制验证码/密码
            [charecterString drawAtPoint:vertificationCodeDrawStartPoint withAttributes:attributes];
        }
    }
    //绘制底部横线
    for (int k=0; k<self.numberOfVertificationCode; k++) {
        
        [self drawBottomLineWithRect:rect andIndex:k];
        [self drawSenterLineWithRect:rect andIndex:k];
    }
}

//绘制底部的线条
- (void)drawBottomLineWithRect:(CGRect)rect1 andIndex:(int)k {
    CGRect rect = CGRectMake(0,0,kScreenW - 40,80);
    float width = rect.size.width / (float)self.numberOfVertificationCode;
    float height = rect.size.height;
    //1.获取上下文
    CGContextRef context =UIGraphicsGetCurrentContext();
    //2.设置当前上下问路径
    CGFloat lineHidth =0.25*5;
    CGFloat strokHidth = 0*5;
 
    CGContextSetLineWidth(context, lineHidth);
    if (k<=self.text.length)
    {
        CGContextSetStrokeColorWithColor(context,HexColor(0xA8A8A8).CGColor);
        CGContextSetFillColorWithColor(context,HexColor(0xA8A8A8).CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(context,HexColor(0xA8A8A8).CGColor);
        CGContextSetFillColorWithColor(context,HexColor(0xA8A8A8).CGColor);
    }
    
    CGRect rectangle =CGRectMake(k*width+width/10,height-lineHidth-strokHidth,width-width/5,strokHidth);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
}
//绘制中间的输入的线条
- (void)drawSenterLineWithRect:(CGRect)rect1 andIndex:(int)k {
    if ( k==self.text.length ) {
        CGRect rect =CGRectMake(0,0,kScreenW - 40,80);
        float width = rect.size.width / (float)self.numberOfVertificationCode;
        float height = rect.size.height;
        //1.获取上下文
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context,0.5);
        CGContextSetStrokeColorWithColor(context,HexColor(0xEB3341).CGColor);
        CGContextSetFillColorWithColor(context,HexColor(0xEB3341).CGColor);
        CGContextMoveToPoint(context, width * k + (width -1.0) /2.0, height/5);
        CGContextAddLineToPoint(context,  width * k + (width -1.0) /2.0,height-height/5);
        CGContextStrokePath(context);
    }
}

@end
