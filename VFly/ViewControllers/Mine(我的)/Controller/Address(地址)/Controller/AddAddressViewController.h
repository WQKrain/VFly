//
//  AddAddressViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class AddressListModel;
@interface AddAddressViewController : BaseViewController
@property (nonatomic , assign)BOOL isEdit;
@property (nonatomic ,assign)AddressListModel *model;
@end
