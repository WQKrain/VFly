//
//  ListCell.h
//  LuxuryCar
//
//  Created by wang on 16/8/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotCarListModel;

@interface HomeCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) HotCarListModel *model;
@property (nonatomic, assign) BOOL isOffers;
@property (nonatomic, strong) UILabel *selectLabel;
@end
