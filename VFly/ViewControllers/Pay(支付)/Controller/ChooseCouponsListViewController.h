//
//  ChooseCouponsListViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class chooseCouponListModel;
@interface ChooseCouponsListViewController : BaseViewController
@property (nonatomic,assign)id delegate;
@property (nonatomic , strong)NSString *money;
@property (nonatomic , assign)BOOL isNew;
@end

@protocol chooseCouponsDelegate <NSObject>

-(void)chooseCouponsModel:(chooseCouponListModel *)model;
-(void)backCancleCoupons;
@end
