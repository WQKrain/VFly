//
//  anyButton.m
//  QA
//
//  Created by  CL on 15-1-14.
//  Copyright (c) 2015年 cl. All rights reserved.
//

#import "anyButton.h"

@implementation anyButton{
    CGRect imgeRect;
    CGRect titleRect;
    int change;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        change=0;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
-(NSString *)valueStr
{
    if (_valueStr == nil) {
        _valueStr = @"";
    }
    return _valueStr;
}
-(void)changeImageFrame:(CGRect )rect{
    imgeRect=rect;
    change=1;
    [self layoutSubviews];
}

-(void)changeTitleFrame:(CGRect )rect{
    titleRect=rect;
    change=1;
    [self layoutSubviews];
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    if(change)
        return imgeRect;
    return contentRect;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    if(change)
        return titleRect;
    return contentRect;
}
-(void)setHighlighted:(BOOL)highlighted
{
}
//-(void)setHighlighted:(BOOL)highlighted{
//    
//}
@end
