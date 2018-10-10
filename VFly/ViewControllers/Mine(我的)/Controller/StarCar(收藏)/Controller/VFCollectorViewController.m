//
//  VFCollectorViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCollectorViewController.h"
#import "VFStarCollectionViewCell.h"
#import "VFCollectorViewCell.h"
#import "VFCarDetailViewController.h"
#import "StarModel.h"
@interface VFCollectorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) StarModel *starObj;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) VFDefaultPageView *pageView;
@property (nonatomic, strong) UIView *noCollectorView;
@property (nonatomic, strong) UIButton *noCollectButton;
@property (nonatomic, strong) UIButton *cartButton;

@end

@implementation VFCollectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self loadData];
    [self createView];
    [self setNav];
    [self createMJRefresh];
    _page = 1;
}

- (void)setNav {
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatutesBarH + 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc]init];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.frame = CGRectMake(0, 0, 64, kStatutesBarH + 44);
    [navView addSubview:backButton];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_icon_back_black"]];
    [backButton addSubview:backImageView];
    backImageView.sd_layout
    .leftSpaceToView(backButton, 20)
    .bottomSpaceToView(backButton, 0)
    .heightIs(24)
    .widthIs(24);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的收藏";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadData{
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    NSDictionary *dic = @{@"token":token,
                          @"page":@"0",
                          @"limit":@"10",
                          @"city":city};
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];

    [HttpManage getStarListParameter:dic Success:^(NSDictionary *data) {
        [self.noCollectorView removeFromSuperview];
        _starObj = [[StarModel alloc]initWithDic:data];
        for (NSDictionary *dic in _starObj.starList) {
            StarListModel *obj = [[StarListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        [weakSelf endRefresh];
        [_collectionView reloadData];
        [JSFProgressHUD hiddenHUD:weakSelf.view];
        
        if (_starObj.starList.count == 0)
        {
            [self setupNoDataView];
        }
    } failedBlock:^{
        [self setupNoDataView];

        [ProgressHUD showError:@"加载失败"];
        [_collectionView.mj_header endRefreshing];
    }];

}


- (void)setupNoDataView {
    
    self.noCollectorView = [[UIView alloc]init];
    self.noCollectorView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noCollectorView];
    self.noCollectorView.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(100)
    .centerYEqualToView(self.view);
    
    self.noCollectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, kScreenW - 40, 30)];
    [self.noCollectButton setTitleColor:HexColor(0xABABAB) forState:(UIControlStateNormal)];
    [self.noCollectButton setTitle:@"暂无收藏车辆" forState:(UIControlStateNormal)];
    [self.noCollectButton setBackgroundColor:[UIColor whiteColor]];
    [self.noCollectorView addSubview:self.noCollectButton];

    
    
    self.cartButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 60, kScreenW - 40, 40)];
    self.cartButton.backgroundColor = [UIColor whiteColor];
    [self.cartButton setTitle:@"前往车库 >" forState:(UIControlStateNormal)];
    [self.cartButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [self.cartButton addTarget:self action:@selector(goToCart:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.noCollectorView addSubview:self.cartButton];

}

- (void)goToCart:(UIButton *)sender {
    //进入车库
    NSNotification *notification =[NSNotification notificationWithName:@"jumpRent" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}








- (void)loadMoreData{
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    _page++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *dic = @{@"token":token,
                          @"page":pageNum,
                          @"limit":@"10",
                          @"city":city};

    [HttpManage getStarListParameter:dic Success:^(NSDictionary *data) {
        _starObj = [[StarModel alloc]initWithDic:data];
        
        if ([_starObj.remainder isEqualToString:@"0"]) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            for (NSDictionary *dic in _starObj.starList)
            {
                StarListModel *obj = [[StarListModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            if (_starObj.starList.count == 0)
            {}
            [weakSelf endRefresh];
        }
        [_collectionView reloadData];
        [JSFProgressHUD hiddenHUD:weakSelf.view];
    } failedBlock:^{
        [ProgressHUD showError:@"加载失败"];
        [_collectionView.mj_header endRefreshing];
        
    }];

    
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
    [_collectionView registerClass:[VFCollectorViewCell class] forCellWithReuseIdentifier:@"VFCollectorViewCell"];
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
    
    VFCollectorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VFCollectorViewCell" forIndexPath:indexPath];
    if (_dataArr.count == 0)
    {
        return cell;
    }

    StarListModel *model = _dataArr[indexPath.row];
    cell.model = model;
    [cell.cancelButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
























/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
