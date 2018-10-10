//
//  LLAddNameAndCardIDViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"

@interface LLAddNameAndCardIDViewController : BaseViewController
@property (nonatomic , strong)NSString *orderInfo;
@property (nonatomic , strong)NSString *payType;
@property (nonatomic , strong)NSString *orderID;
@property (nonatomic , strong)NSString *money;

@property (nonatomic , strong)NSString *handler;
@property (nonatomic , assign)BOOL isNew;
@end
