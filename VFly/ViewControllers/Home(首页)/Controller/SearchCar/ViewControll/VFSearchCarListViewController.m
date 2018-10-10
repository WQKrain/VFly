//
//  VFSearchCarListViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSearchCarListViewController.h"
#import "DrivceTravelCollectionViewCell.h"
#import "VFSerchCarModel.h"
#import "VFCarDetailViewController.h"
#import "VFSubmitCarAlertView.h"

@interface VFSearchCarListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)UILabel *headerlabel;
@property (nonatomic , strong)VFDefaultPageView *pageView;
@property (nonatomic, strong) VFSubmitCarAlertView *showView;
@end

@implementation VFSearchCarListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    _dataArr = [[NSMutableArray alloc]init];
    [self loadData];
}

- (void)createView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    layOut.headerReferenceSize=CGSizeMake(kScreenW, 40);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kOldNavBarH - 90, kScreenW, kScreenH-kOldNavBarH + 90) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[DrivceTravelCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusable"];
    
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
    titleLabel.text = @"搜索";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    //--------------------------------------
    
}

- (void)back:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadData {
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (!token) {
        token= @"";
    }
    NSDictionary *dic = @{@"key":self.carModel,
                          @"token":token};
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage getSearchCarDataWithPar:dic With:^(NSDictionary *data) {
        
        NSLog(@"_____________%@",data);
        [_pageView removeFromSuperview];
        [JSFProgressHUD hiddenHUD:self.view];
        VFSerchCarModel *model = [[VFSerchCarModel alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *tempDic in model.carList) {
            VFSerchCarListModel *model = [[VFSerchCarListModel alloc]initWithDic:tempDic];
            [tempArr addObject:model];
        }
        _dataArr = tempArr;
        [self createView];
        if (_dataArr.count == 0)
        {
            [self.view addSubview:[self VFDefaultPageView:@"0"]];
        }
    } failedBlock:^{
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}

#pragma mark--------------缺省view--------------------
- (VFDefaultPageView *)VFDefaultPageView:(NSString *)state{
    kWeakSelf;
    _pageView = [[VFDefaultPageView alloc]initWithFrame:CGRectMake(0, SpaceH(360), kScreenW, kScreenH - SpaceH(360))];
    if ([state isEqualToString:@"0"]) {
        _pageView.showImage.image =[UIImage imageNamed:@"empty_image_FindCar"];
        _pageView.showlabel.text = @"抱歉，没找到您想要的车";
        [_pageView.showButton setTitle:@"点击我帮您找车" forState:UIControlStateNormal];
        _pageView.showButton.layer.borderWidth = 0;
        [_pageView.showButton setTitleColor:kTextBlueColor forState:UIControlStateNormal];
        [_pageView.showButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_pageView.showlabel.mas_bottom).offset(5);
        }];
        _pageView.DefaultPageBtnClickHandler = ^{
            //弹出输入框
            weakSelf.showView = [[VFSubmitCarAlertView alloc]init];
            weakSelf.showView.delegate = weakSelf;
            [weakSelf.view addSubview:[weakSelf.showView showView]];
        };
    }else{
        _pageView.showImage.image =[UIImage imageNamed:@"image_blankpage_network"];
        _pageView.showlabel.text = @"网络信号丢失";
        [_pageView.showButton setTitle:@"检查网络" forState:UIControlStateNormal];
    }
    return _pageView;
}

- (void)didSelectbutton:(NSInteger)tag{
    if (tag == 1) {
        if ([_showView.brandTextField.text isEqualToString:@""] || [_showView.modelTextField.text isEqualToString:@""]) {
            [CustomTool showOptionMessage:@"请将车辆信息填写完整"];
            return;
        }
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        NSDictionary *dic = @{@"token":token,@"brand":_showView.brandTextField.text,@"model":_showView.modelTextField.text};
        [HttpManage needCarSubmitParameter:dic success:^(NSDictionary *data) {
            [CustomTool showOptionMessage:@"我们会尽快上架您所需要的车辆"];
        } failedBlock:^(NSError *error) {
            
        }];
    }
    [_showView animateOut];
}

#pragma mark- collectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusable" forIndexPath:indexPath];
        if (!_headerlabel) {
            _headerlabel = [UILabel initWithTitle:kFormat(@"%ld个关于“%@”的结果", _dataArr.count,_carModel) withFont:kTitleSize textColor:kdetailColor];
        }else{
            _headerlabel.text = kFormat(@"%ld个关于“%@”的结果", _dataArr.count,_carModel);
        }
        _headerlabel.frame= CGRectMake(15, 0, kScreenW-30, 40);
        [headerView addSubview:_headerlabel];
        reusableview = headerView;
        
    }
    return reusableview;
    
}


//这个代理方法是每一个区里面返回多少个cell(对比TableView的代理方法)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DrivceTravelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataArr.count == 0) {
        return cell;
    }
    VFSerchCarListModel *model = _dataArr[indexPath.row];
    cell.titleLabel.text =model.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@／天",model.price];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VFSerchCarListModel *model = _dataArr[indexPath.row];
    VFCarDetailViewController *vc = [[VFCarDetailViewController alloc]init];
    vc.carId =model.carId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
