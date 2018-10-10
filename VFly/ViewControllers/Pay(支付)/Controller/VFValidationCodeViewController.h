//
//  VFValidationCodeViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"

@interface VFValidationCodeViewController : BaseViewController

@property (nonatomic , strong)NSString *doPayFee;
@property (nonatomic , strong)NSString *orderID;
@property (nonatomic , strong)NSString *moneyType;
@property (nonatomic , strong)NSString *func;
@property (nonatomic, strong) NSString *useCouponsID;
@property (nonatomic, strong) NSString *useIntegral;

@property (nonatomic , assign)BOOL isNew;
@property (nonatomic, strong) NSString *should_pay_id;

@end
