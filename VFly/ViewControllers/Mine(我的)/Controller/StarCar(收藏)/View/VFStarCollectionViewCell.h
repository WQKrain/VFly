//
//  VFStarCollectionViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarListModel;
@interface VFStarCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic)UIImageView *titleImage;
@property (strong,nonatomic)UILabel *titleLabel;
@property (strong,nonatomic)UILabel *priceLabel;
@property (strong,nonatomic)UIButton *cancelButton;
@property (strong,nonatomic)StarListModel *model;
@end
