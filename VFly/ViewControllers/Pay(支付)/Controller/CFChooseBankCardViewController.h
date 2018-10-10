//
//  CFChooseBankCardViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"

@interface CFChooseBankCardViewController : BaseViewController
@property (nonatomic , strong)NSString *orderInfo;
@property (nonatomic , strong)NSString *moneyType;
@property (nonatomic , strong)NSString *orderID;
@property (nonatomic , strong)NSString *money;

@property (nonatomic , strong)NSString *useCouponsID;
@property (nonatomic , strong)NSString *score;

@property (nonatomic , assign)BOOL isNew;
@property (nonatomic , strong)NSString *handler;
 
@end
