//
//  DrivceTravelCollectionViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFhotCarListMode;
@interface DrivceTravelCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic)UIImageView *titleImage;
@property (strong,nonatomic)UILabel *titleLabel;
@property (strong,nonatomic)UILabel *priceLabel;
@property (strong,nonatomic)UILabel *tagLabel;
@property (strong,nonatomic)VFhotCarListMode *model;
@property (strong,nonatomic)UILabel *selectLabel;
@end
