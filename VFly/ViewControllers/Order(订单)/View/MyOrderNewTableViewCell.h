//
//  MyOrderNewTableViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2017/8/24.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderListModel;
@class OrderDetailModel;

typedef void(^MyOrderNewTableViewCellButtonClickBlock)(NSInteger tag);

@interface MyOrderNewTableViewCell : UITableViewCell

@property (nonatomic, copy) MyOrderNewTableViewCellButtonClickBlock buttonClickBlock;

@property (nonatomic , strong)MyOrderListModel *model;

@property (nonatomic , strong)OrderDetailModel *detailModel;

@property (nonatomic , strong)UIImageView *carImage;

@end
