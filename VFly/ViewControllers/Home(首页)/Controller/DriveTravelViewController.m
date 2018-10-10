//
//  DriveTravelViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "DriveTravelViewController.h"
#import "DrivceTravelCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "HCBnnerListModel.h"
#import "WebViewVC.h"
#import "VFhotCarMode.h"
#import "VFCarDetailViewController.h"

@interface DriveTravelViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic , strong)NSMutableArray *urlArr;
@property (nonatomic , strong)NSMutableArray *imageArr;
@property (nonatomic , assign)NSInteger page;
// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation DriveTravelViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"热门推荐";
    self.cellDic = [[NSMutableDictionary alloc] init];
    [self.rightButton setTitle:@"进入车库" forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:kTitleBigSize]];
    [self.rightButton setTitleColor:kTextBlueColor forState:UIControlStateNormal];
     _page = 1;
    _imageArr = [[NSMutableArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kOldNavBarH, kScreenW, kScreenH-kOldNavBarH) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
//    [_collectionView registerClass:[DrivceTravelCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusable"];
    [self loadData];
    [self createMJRefresh];
    AdjustsScrollViewInsetNever(self,_collectionView);
}

- (void)defaultRightBtnClick{
    NSNotification *notification =[NSNotification notificationWithName:@"jumpRent" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createMJRefresh {
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

- (void)endRefresh{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}


- (void)loadData {
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    NSDictionary *dic = @{@"page":@"0",@"limit":@"10",@"cityId":cityID};
    kWeakself;
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage getHotCarWithParameter:dic withSuccessBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        VFhotCarMode *model = [[VFhotCarMode alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.hotCarList) {
            VFhotCarListMode *obj = [[VFhotCarListMode alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr =tempArr;
        [weakSelf.collectionView reloadData];
        [weakSelf endRefresh];
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}

- (void)loadMoreData{
    _page ++;
    kWeakself;
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    NSString *pageNum = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *dic = @{@"page":pageNum,@"limit":@"10",@"cityId":cityID};
    [HttpManage getHotCarWithParameter:dic withSuccessBlock:^(NSDictionary *data) {
        VFhotCarMode *model = [[VFhotCarMode alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"]) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            for (NSDictionary *dic in model.hotCarList) {
                VFhotCarListMode *obj = [[VFhotCarListMode alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf endRefresh];
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark----------- 点击首页广告位实现跳转-----------
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

}

#pragma mark- collectionViewDelegate
//这个代理方法是每一个区里面返回多少个cell(对比TableView的代理方法)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    /// 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.collectionView registerClass:[DrivceTravelCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    
    // 从重用队列里面取出来可重用的cell
    DrivceTravelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (_dataArr.count == 0) {
        return cell;
    }
    VFhotCarListMode *model = _dataArr[indexPath.row];
    cell.titleLabel.text =model.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@／天",model.price];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"place_holer_750x500"]];
    cell.model = model;
    return cell;
    
}
//这个方法是用来设置每一个cell的大小的
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenW -36)/2, (kScreenW -36)/2*kPicZoom +109);
}
//这个代理方法是来设置每个cell上下左右的边距的
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets edge = UIEdgeInsetsMake(12, 12, 12, 12);
    return edge;
}
//这个方法是选中cell的时候回调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.dataArr.count > 0) {
        VFhotCarListMode *model = self.dataArr[indexPath.row];
        VFCarDetailViewController *detailView = [VFCarDetailViewController new];
        detailView.carId = model.carId;
        [self.navigationController pushViewController:detailView animated:YES];
    }
}
//这个是返回多少的区的代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusable" forIndexPath:indexPath];
    reusableView.backgroundColor = [UIColor blueColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/3.0*2.0) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    _cycleScrollView.imageURLStringsGroup = _imageArr;
    [reusableView addSubview:_cycleScrollView];
    return reusableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
