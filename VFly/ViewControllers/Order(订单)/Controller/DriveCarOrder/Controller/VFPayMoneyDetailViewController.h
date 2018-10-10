//
//  VFPayMoneyDetailViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/21.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class VForderMoneyDetailModel;
@interface VFPayMoneyDetailViewController : BaseViewController
@property (nonatomic , strong)VForderMoneyDetailModel *model;

@property (nonatomic , assign)BOOL freeDeposit;

@property (nonatomic , strong)NSString *type;

@property (nonatomic , strong)NSString *rentMoney;
@property (nonatomic , strong)NSString *vipZK;
@property (nonatomic , strong)NSString *longRentZK;
@property (nonatomic , strong)NSString *allRentMoney;

@end
