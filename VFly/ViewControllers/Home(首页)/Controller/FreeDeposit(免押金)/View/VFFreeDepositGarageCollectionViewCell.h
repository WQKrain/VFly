//
//  VFFreeDepositGarageCollectionViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2018/1/30.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DriveTravelListModel;

@interface VFFreeDepositGarageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)DriveTravelListModel *model;

@property (nonatomic,strong)UIImageView *carImage;//车辆主图
@property (nonatomic,strong)UILabel *decriptionLabel;//车辆描述
@property (nonatomic,strong)UILabel *price;//车辆租金
@property (nonatomic,strong)UILabel *deposit;//车辆押金
@property (nonatomic,strong)UILabel *selectlabel;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *freeMoney;
@property (nonatomic,strong)UIView *borderView;
@property (nonatomic,strong)UIImageView *bgView;
@property (nonatomic,strong)UIImageView *rightImage;

@end
