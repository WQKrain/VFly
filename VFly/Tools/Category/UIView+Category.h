//
//  UIView+Category.h
//  LuxuryCar
//
//  Created by Hcar on 2017/8/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)
+(instancetype)initWithShadowViewFrame:(CGRect)frame shadowRadius:(NSInteger)shadowRadius;
+(instancetype)initWithLineView;
@end
