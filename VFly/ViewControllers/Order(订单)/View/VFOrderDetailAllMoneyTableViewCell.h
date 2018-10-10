//
//  VFOrderDetailAllMoneyTableViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2018/3/16.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFOrderDetailModel;
@class OrderDetailModel;

@interface VFOrderDetailAllMoneyTableViewCell : UITableViewCell

@property (nonatomic , strong)VFOrderDetailModel *model;
@property (nonatomic , strong)OrderDetailModel *oldModel;

@end
