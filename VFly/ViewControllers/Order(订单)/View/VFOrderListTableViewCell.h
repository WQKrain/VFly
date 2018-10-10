//
//  VFOrderListTableViewCell.h
//  VFly
//
//  Created by Hcar on 2018/4/16.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFOrderListModel;
@class VFOrderDetailModel;

typedef void(^OrderListTableViewCellButtonClickBlock)(NSInteger tag);

@interface VFOrderListTableViewCell : UITableViewCell
@property (nonatomic, copy) OrderListTableViewCellButtonClickBlock buttonClickBlock;
@property (nonatomic , strong)VFOrderListModel *model;
@property (nonatomic , strong)VFOrderDetailModel *detailModel;
@end
