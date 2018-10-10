//
//  HCAlertViewController.h
//  LuxuryCar
//
//  Created by joyingnet on 16/8/17.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(HCAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;

@end


@interface HCAlertViewController : UIViewController

@property (nonatomic, readonly) NSArray<HCAlertAction *> *actions;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTextAlignment messageAlignment;
@property (nonatomic, assign) BOOL needDismissAnimation;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
- (void)addAction:(HCAlertAction *)action;

@end
