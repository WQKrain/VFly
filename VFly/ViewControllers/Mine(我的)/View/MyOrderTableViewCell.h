//
//  MyOrderTableViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *CarImage;
@property (strong, nonatomic) UILabel *CarTitlelabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statelabel;
@property (strong, nonatomic) UIButton *detailBtn;
@end
