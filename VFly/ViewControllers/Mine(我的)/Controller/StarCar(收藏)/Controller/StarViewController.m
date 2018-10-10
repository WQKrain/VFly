//
//  StarViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "StarViewController.h"
#import "VFStarCollectionViewCell.h"
#import "VFCarDetailViewController.h"
#import "StarModel.h"

@interface StarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)StarModel *starObj;
@property (nonatomic , assign)NSInteger page;
@property (nonatomic , strong)VFDefaultPageView *pageView;

@end

@implementation StarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    self.UMPageStatistical = @"myStarts";
    [self createView];
    if (_isStar) {
        self.navTitleLabel.text = @"我的收藏";
    }else {
        self.navTitleLabel.text = @"我的足迹";
    }
    [self loadData];
    [self createMJRefresh];
    _page = 1;
}


-(void)loadData{
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    NSDictionary *dic = @{@"token":token,@"page":@"0",@"limit":@"10",@"city":city};
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    if (_isStar) {
        [HttpManage getStarListParameter:dic Success:^(NSDictionary *data) {
            [_pageView removeFromSuperview];
            _starObj = [[StarModel alloc]initWithDic:data];
            for (NSDictionary *dic in _starObj.starList) {
                StarListModel *obj = [[StarListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            _dataArr = tempArr;
            [weakSelf endRefresh];
            [_collectionView reloadData];
            [JSFProgressHUD hiddenHUD:weakSelf.view];
            
            if (_starObj.starList.count == 0) {
                [self.view addSubview:[self VFDefaultPageView:@"0"]];
            }
        } failedBlock:^{
            [self.view addSubview:[self VFDefaultPageView:@"1"]];
            [ProgressHUD showError:@"加载失败"];
            [_collectionView.mj_header endRefreshing];
        }];
    }else {
    }
}

- (VFDefaultPageView *)VFDefaultPageView:(NSString *)state{
    kWeakSelf;
    _pageView = [[VFDefaultPageView alloc]initWithFrame:CGRectMake(0, kOldNavBarH, kScreenW, kScreenH-kOldNavBarH)];
    if ([state isEqualToString:@"0"]) {
        _pageView.showImage.image =[UIImage imageNamed:@"image_blankpage_collection"];
        _pageView.showlabel.text = @"竟然一个收藏也没有";
        [_pageView.showButton setTitle:@"逛一逛" forState:UIControlStateNormal];
    }else{
        _pageView.showImage.image =[UIImage imageNamed:@"image_blankpage_network"];
        _pageView.showlabel.text = @"网络信号丢失";
        [_pageView.showButton setTitle:@"检查网络" forState:UIControlStateNormal];
    }
    [_pageView layoutView];
    _pageView.DefaultPageBtnClickHandler = ^{
        if ([state isEqualToString:@"0"]) {
            NSNotification *notification =[NSNotification notificationWithName:@"jumpRent" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [weakSelf loadData];
        }
    };
    
    [_pageView.showButton setTitleColor:kMainColor forState:UIControlStateNormal];
    return _pageView;
}

- (void)loadMoreData{
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    _page++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *dic = @{@"token":token,@"page":pageNum,@"limit":@"10",@"city":city};
    if (_isStar) {
        [HttpManage getStarListParameter:dic Success:^(NSDictionary *data) {
            _starObj = [[StarModel alloc]initWithDic:data];
            
            if ([_starObj.remainder isEqualToString:@"0"]) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else {
                for (NSDictionary *dic in _starObj.starList) {
                    StarListModel *obj = [[StarListModel alloc]initWithDic:dic];
                    [_dataArr addObject:obj];
                }
                if (_starObj.starList.count == 0) {
//                    [weakSelf.tableView showEmptyViewWithType:1];
                }
                [weakSelf endRefresh];
            }
            [_collectionView reloadData];
            [JSFProgressHUD hiddenHUD:weakSelf.view];
        } failedBlock:^{
//            [weakSelf.tableView showEmptyViewWithType:0];
            [ProgressHUD showError:@"加载失败"];
            [_collectionView.mj_header endRefreshing];
            
        }];
    }else {
    }

}

- (void)createMJRefresh{
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)endRefresh{
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
}

- (void)createView{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    //    这个是来设置咱的colletionView是横向滑动还是纵向滑动
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    这个属性是设置header的大小的
    layOut.headerReferenceSize=CGSizeMake(0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    //    先注册一下（对比table表注册的cell）
    [_collectionView registerClass:[VFStarCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //    这个方法是用来注册CollectionView的头的
    //    UICollectionElementKindSectionHeader这个是用来注册头的第三个参数是一个重用标识符
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusable"];
}


#pragma mark- collectionViewDelegate

//这个代理方法是每一个区里面返回多少个cell(对比TableView的代理方法)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VFStarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataArr.count == 0) {
        return cell;
    }
    
    if (_isStar) {
        StarListModel *model = _dataArr[indexPath.row];
        cell.model = model;
        [cell.cancelButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else {
    }

    
    return cell;
    
}

- (void)cellButtonClick:(UIButton *)sender{
    StarListModel *model = _dataArr[sender.tag];
    kWeakSelf;
    
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定删除？"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"删除" handler:^(HCAlertAction *action) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [JSFProgressHUD showHUDToView:self.view];
            [HttpManage favoriteCollectioCarWithCarId:model.carId withBlock:^(NSString *status) {
                [JSFProgressHUD hiddenHUD:self.view];
                if ([status isEqualToString:@"0"])
                {
                    [weakSelf loadData];
                    [ProgressHUD showSuccess:@"取消收藏"];
                }
                else
                {
                    [ProgressHUD showError:@"取消失败"];
                }
                
            }];
        });
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:NO completion:nil];
}

//这个方法是用来设置每一个cell的大小的
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenW-12)/2, (kScreenW-12)/2 *kPicZoom+100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 6, 5,6);
}

//设置列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section

{
    return 0;
}

//这个代理方法是来设置每个cell上下左右的边距的
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(9, 6, 9,6);
//}
//这个方法是选中cell的时候回调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    StarListModel *model = _dataArr[indexPath.row];
    VFCarDetailViewController *vc = [[VFCarDetailViewController alloc]init];
    vc.carId =model.carId;
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusable" forIndexPath:indexPath];
    reusableView.backgroundColor = [UIColor blueColor];
    return reusableView;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
