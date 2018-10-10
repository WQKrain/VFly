//
//  CustomAlertView.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/8.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCallAlertView : UIView
@property (nonatomic , assign)id delegate;
- (id)initWithTitle:(NSString *)title withMsg:(NSString *)msg withCancel:(NSString *)cancel withSure:(NSString *)sure;
- (void)alertViewShow;

@property (nonatomic,copy)void(^alertViewBlock)(NSInteger index);

@end

@protocol alertActionDelegate <NSObject>

- (void)alertAction:(NSInteger)atcion;

@end
