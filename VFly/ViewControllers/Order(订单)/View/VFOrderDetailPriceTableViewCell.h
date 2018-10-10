//
//  VFOrderDetailPriceTableViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2018/3/16.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VFOrderDetailPriceTableViewCell : UITableViewCell
@property (nonatomic , strong) UILabel *leftlabel;
@property (nonatomic , strong) UILabel *rightlabel;
@property (nonatomic , strong) UIImageView *leftImage;
@property (nonatomic , strong) UILabel *stateLabel;
@property (nonatomic , assign) BOOL needLine;
@end
