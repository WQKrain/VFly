//
//  LoginViewController.h
//  LuxuryCar
//
//  Created by joyingnet on 16/8/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"
#import "BaseViewController.h"

//1.首先 用@protocol 声明一个协议
@protocol LoginViewControllerDelegate <NSObject>
//2.声明代理类需要实现的方法列表
@optional
- (void)loginViewControllerCallback;
@end


@interface LoginViewController : BaseViewController

@property (nonatomic,retain) id <LoginViewControllerDelegate> delegate;

@property (nonatomic, assign)NSInteger ident;
//@property (nonatomic, strong)CarModel *model;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *numberStr;



@end
