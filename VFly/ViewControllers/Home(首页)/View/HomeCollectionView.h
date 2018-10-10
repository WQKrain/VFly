//
//  CollectionView.h
//  LunBoCollectionView
//
//  Created by wang on 2016/10/25.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HomeFooterViewHotCar,
    HomeFooterViewLimitedTimeOffers,
} HomeFooterViewType;

typedef void(^HomeCollectionViewSelectedBlock)(NSIndexPath *indexPath);

@interface HomeCollectionView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) HomeCollectionViewSelectedBlock homeCollectionViewSelectedBlock;
@property (nonatomic, assign) HomeFooterViewType footerViewType;

@property (nonatomic, strong) NSArray *dataArray;




@end
