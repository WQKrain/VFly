//
//  WebViewVC.h
//  LuxuryCar
//
//  Created by joyingnet on 16/8/20.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "BaseViewController.h"

@protocol JSObjcWebViewDelegate <JSExport>

- (void)wxShare:(NSString *)callString;
- (void)login;                      //登录
- (void)goToPay:(NSString *)str;    //跳转到支付页
- (void)goToMine;                   //跳转我的界面
- (void)goToWallet;                 //跳转到我的钱包界面
- (void)goToLogin;                  //跳转到登录
- (void)getToken;                   //获取token值
- (void)getVersion;                 //获取版本号
- (void)getPushId;                  //获取pushID
- (void)getDeviceToken;             //获取设备唯一标示
- (void)getCity;                    //获取城市
- (void)goBack;
- (void)goBack:(NSString *)str;
- (void)goToCarList;
- (void)gotoIndex;
@end

@interface WebViewVC : BaseViewController

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *urlTitle;
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) BOOL needToken;
@property (nonatomic, assign) BOOL isForB;
@property (nonatomic, assign) BOOL longRentShow;
@property (nonatomic, assign) BOOL noNav;
@end
