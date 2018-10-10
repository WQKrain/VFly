//
//  VFPaySuccessfulViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"

@interface VFPaySuccessfulViewController : BaseViewController
@property (nonatomic , strong)NSString *orderId;
@property (nonatomic , strong)NSString *moneyType;
@property (nonatomic , strong)NSString *payMoney;
@property (nonatomic , assign)BOOL isNew;
@property (nonatomic , assign)BOOL isBalance;
@end
