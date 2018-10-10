//
//  VFCollectorViewCell.h
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class StarListModel;

@interface VFCollectorViewCell : UICollectionViewCell
@property (strong,nonatomic)UIImageView *titleImage;
@property (strong,nonatomic)UILabel *titleLabel;
@property (strong,nonatomic)UILabel *priceLabel;
@property (strong,nonatomic)UIButton *cancelButton;
@property (strong,nonatomic)StarListModel *model;
@end

NS_ASSUME_NONNULL_END
