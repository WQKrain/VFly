//
//  VFConfirmOrderViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/20.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
#import "VFCarDetailModel.h"

@interface VFConfirmOrderViewController : BaseViewController
@property (nonatomic,strong)VFCarDetailModel*model;
@property (nonatomic ,assign)BOOL freeDeposit;
@end
