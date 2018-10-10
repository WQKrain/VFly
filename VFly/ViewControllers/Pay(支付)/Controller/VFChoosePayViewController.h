//
//  VFChoosePayViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/23.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"

@interface VFChoosePayViewController : BaseViewController
@property (nonatomic , strong)NSString *orderID;
@property (nonatomic , strong)NSString *moneyType;
@property (nonatomic , strong)NSString *payType;
@property (nonatomic , strong)NSString *depositPay;

@property (nonatomic , strong)NSString *payMoney; //需支付金额
@property (nonatomic , strong)NSString *handler;
@property (nonatomic , assign)BOOL isHiddenBalancePay;
@end
