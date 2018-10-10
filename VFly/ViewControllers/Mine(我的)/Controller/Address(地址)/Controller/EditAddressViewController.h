//
//  EditAddressViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class AddressListModel;
@interface EditAddressViewController : BaseViewController
@property (nonatomic,assign)id delegate;

@property (nonatomic,assign)BOOL mineChoose;
@end

@protocol rentCarChooseAddressDelegate <NSObject>

-(void)rentCarChooseAddressModel:(AddressListModel *)model;

@end
