//
//  CollectionView.m
//  LunBoCollectionView
//
//  Created by wang on 2016/10/25.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "HomeCollectionView.h"
#import "HomeCollectionViewCell.h"



static NSString *CellIdentifier = @"HomeCollectionViewCell";

@interface HomeCollectionView ()

@end

@implementation HomeCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionView Delegate/DataSource
//返回个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return _dataArray.count;
}


//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.footerViewType == HomeFooterViewLimitedTimeOffers) {
        cell.isOffers = YES;
    } else
    {
        cell.isOffers = NO;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, SpaceW(20), 0, SpaceW(20));
}

////选中单元格的协议方法
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.homeCollectionViewSelectedBlock) {
        self.homeCollectionViewSelectedBlock(indexPath);
    }
    
    return YES;
}

#pragma mark - Private Methods


#pragma mark - Getters/Setters

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //创建布局视图
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置属性
        flowLayout.itemSize = CGSizeMake(kScreenW/1.6, kScreenW/1.6*kPicZoom + 113);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //注册单元格
        [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        
    }
    return _collectionView;
}

@end
