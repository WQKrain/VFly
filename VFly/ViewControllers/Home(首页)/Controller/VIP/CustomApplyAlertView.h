//
//  CustomApplyAlertView.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/10.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface CustomApplyAlertView : UIView

@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title pic:(UIImage *)image  message:(NSString *)message;

- (void)showXLAlertView;

@end
