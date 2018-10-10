//
//  HCBankCardViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class MyBankCardListModel;
@interface HCBankCardViewController : BaseViewController

@property (nonatomic,assign)id delegate;

@end

@protocol BankCardListDelegate <NSObject>

-(void)BankCardListSenderModel:(MyBankCardListModel *)model;

@end
