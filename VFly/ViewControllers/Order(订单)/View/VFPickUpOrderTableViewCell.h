//
//  VFPickUpOrderTableViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2018/3/12.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderListModel;

typedef void(^MyOrderNewTableViewCellButtonClickBlock)(NSInteger tag);

@interface VFPickUpOrderTableViewCell : UITableViewCell

@property (nonatomic, copy) MyOrderNewTableViewCellButtonClickBlock buttonClickBlock;

@property (nonatomic , strong)MyOrderListModel *model;

@end
