//
//  ChooseBankViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/8/28.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseBankViewController : BaseViewController
@property (nonatomic , strong)NSString *orderInfo;
@property (nonatomic , strong)NSString *payType;
@property (nonatomic , strong)NSString *orderID;
@property (nonatomic , strong)NSString *money;
@property (nonatomic , strong)NSString *couponId;
@property (nonatomic , strong)NSString *score;

@property (nonatomic , assign)BOOL isNew;
@property (nonatomic , strong)NSString *handler;

@end
