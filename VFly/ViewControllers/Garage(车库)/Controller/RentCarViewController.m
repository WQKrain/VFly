//
//  RentCarViewController.m
//  JSFLuxuryCar
//
//  Created by joyingnet on 16/7/29.
//  Copyright © 2016年 joyingnet. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "RentCarViewController.h"
#import "VFCarDetailViewController.h"
#import "CollectionViewCell.h"
#import "UIButton+WebCache.h"
#import "CustomScrollView.h"
#import "RentCarHearderView.h"
#import "LoginViewController.h"

#import "DriveTravelModel.h"
#import "CarModel.h"
#import "RHFiltrateView.h"

#import "VFCarDetailViewController.h"
#import "VFSubmitCarAlertView.h"

#import "VFCarLogoModel.h"


#define kCellIdentifier      @"kCellIdentifier"
#define kHeaderIdentifier    @"kHeaderIdentifier"

@interface RentCarViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate, UIAlertViewDelegate,RHFiltrateViewDelegate,VFSubmitCarDidSelectbuttonDelegate>
{
    UIView *redLine;
    NSInteger cellH;
    UIView *_grayLine; //分割线
    UIButton *_btn;
    CGFloat _offsetY;
    NSInteger count;
    RentCarHearderView *headerView;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSArray *headerArr;
@property (nonatomic, strong) NSMutableArray *dataArrayM;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *trademarkArr;
@property (nonatomic, strong) NSMutableArray *defaultArrayM;
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, strong) UILabel *noDataLabel;         //无数据时显示的Label
@property (nonatomic, assign) BOOL userDragging;            //用户是否在滑动
@property (nonatomic, strong) CLLocation *index_Location;   //记录定位
@property (nonatomic, assign) BOOL isFirst_Location;        //判断是否第一次定位

@property (nonatomic, assign) BOOL isShowType;

@property (nonatomic , strong)UIButton *topSelectButton;

@property (nonatomic , strong)UIView *comprehensiveSequencingView;
@property (nonatomic , strong)UIView *rentSortingView;
@property (nonatomic , strong)UIView *moreScreeningView;

@property (nonatomic , strong)NSMutableArray *chooseLabelArr;
@property (nonatomic , strong)NSArray *labelDatalArr;

@property (nonatomic, strong) NSMutableDictionary *cellDic;
@property (nonatomic, strong) RHFiltrateView * filtrate;

@property (nonatomic, strong) UIButton * comprehensiveButton;
@property (nonatomic, strong) UIButton * priceButton;
@property (nonatomic, strong) UIButton * moreButton;

@property (nonatomic, strong) NSString * comprehensiveStr;
@property (nonatomic, strong) NSString * priceStr;
@property (nonatomic, strong) NSArray *comprehensiveArr;
@property (nonatomic, strong) NSArray *priceArr;
@property (nonatomic, strong) VFDefaultPageView *pageView;

@property (nonatomic, strong) VFSubmitCarAlertView *showView;

@end

@implementation RentCarViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self preferredStatusBarStyle];
    
    [_moreScreeningView removeFromSuperview];
    [_rentSortingView removeFromSuperview];
    [_comprehensiveSequencingView removeFromSuperview];
    _comprehensiveButton.selected = NO;
    _priceButton.selected = NO;
    _moreButton.selected = NO;
    
    [JSFProgressHUD hiddenHUD:self.view];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)networkChanged:(id)info{
    NSDictionary *dic = (NSDictionary *)info;
    if ([dic[@"netType"] isEqualToString:kNotReachable]) {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"目前网络连接已断开哦"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
    }else{
        if (_dataArrayM.count == 0 || _headerArr.count == 0) {
            [self.collection.mj_header beginRefreshing];
        }
    }
}

- (void)dealloc{
    [[ChangeCityTool changeCity] removeObserver:self forKeyPath:@"city"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.UMPageStatistical = @"carModel";
    self.isShowType = NO;
    self.headerArr = [[NSArray alloc]init];
    self.titleLabel.text = @"车型";
    _dataArr = [[NSMutableArray alloc]init];
    self.cellDic = [[NSMutableDictionary alloc] init];
    _comprehensiveStr = @"0";
    _priceStr = @"4";
    _comprehensiveArr = @[@"综合排序",@"价格最高",@"价格最低"];
    _priceArr = @[@"0-2000元",@"2000-4000元",@"4000-6000元",@"6000元以上",@"不限"];
    _chooseLabelArr = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
    _labelDatalArr = @[@[@"不限",@"跑车", @"商务", @"SUV"], @[@"不限", @"2座",@"4座", @"5座", @"7座"], @[@"不限", @"敞篷", @"个性门"]];
    [self createSelectView];
    [self.view addSubview:self.collection];
    count=0;
    self.index = 1000;
    _trademarkArr = [NSMutableArray array];
    _urlArr = [NSMutableArray array];
    
    [self projectData];
    
    //监听用户所选地址是否已经变化
    [[ChangeCityTool changeCity] addObserver:self forKeyPath:@"city" options:NSKeyValueObservingOptionNew context:nil];
    
    // 价格排序视图
    kWeakself;
    //下拉刷新
    self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf getRefreshDataBy:_nameArr[self.index-chooseCarClass]];
        });
    }];
    
    //根据拖拽比例自动切换透明度---在导航栏下隐藏
    self.collection.mj_header.automaticallyChangeAlpha = YES;
    [self.collection.mj_header beginRefreshing];
}

- (void)createSelectView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kStatutesBarH, kScreenW, 64)];
    if (_secondVC) {
        view.frame = CGRectMake(0, kStatutesBarH+44, kScreenW, 64);
    }
    view.backgroundColor = kWhiteColor;
    NSArray *dataArr = @[@"综合排序",@"日租金",@"更多筛选"];
    for (int i=0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:@"icon_unfold_off"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenW/3*i, 0, kScreenW/3, 64);
        [button setTitle:dataArr[i] forState:UIControlStateNormal];
        [button setTitleColor:kdetailColor forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_selectmore"] forState:UIControlStateSelected];
        [button setTitleColor:kMainColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        if (i !=1) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, -70)];
        }else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
        }
        
        switch (i) {
            case 0:
                _comprehensiveButton = button;
                break;
            case 1:
                _priceButton = button;
                break;
            case 2:
                _moreButton = button;
                break;
            default:
                break;
        }
        
        button.tag = i;
        [button addTarget:self action:@selector(topSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    [self.view addSubview:view];
}

- (void)topSelectButton:(UIButton *)sender{
    
    if (sender == _topSelectButton) {
        sender.selected = !sender.selected;
    }else{
        _topSelectButton.selected = NO;
        sender.selected = YES;
    }
    switch (sender.tag) {
        case 0:
            if (sender.selected) {
                [_moreScreeningView removeFromSuperview];
                [_rentSortingView removeFromSuperview];
                [self.view addSubview:[self comprehensiveSequencingView]];
            }else{
                [_comprehensiveSequencingView removeFromSuperview];
            }
            break;
        case 1:
            if (sender.selected) {
                [_moreScreeningView removeFromSuperview];
                [_comprehensiveSequencingView removeFromSuperview];
                [self.view addSubview:[self createRentSortingView]];
            }else{
                [_rentSortingView removeFromSuperview];
            }
            
            break;
        case 2:
            if (sender.selected)
            {
                [_rentSortingView removeFromSuperview];
                [_comprehensiveSequencingView removeFromSuperview];
                [self.view addSubview:[self createMoreScreening]];
            }
            else
            {
                [_moreScreeningView removeFromSuperview];
            }
            break;
        default:
            break;
    }
    _topSelectButton = sender;

}

//根据日租金排序
- (UIView *)comprehensiveSequencingView{
    if (!_comprehensiveSequencingView) {
        _comprehensiveSequencingView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH+44, kScreenW, kScreenH)];
        if (!_secondVC) {
            _comprehensiveSequencingView.frame = CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH);
        }
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comprehensiveSequencingViewTap:)];
        [bgView addGestureRecognizer:singleTap];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [_comprehensiveSequencingView addSubview:bgView];
        
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        topLineView.backgroundColor = klineColor;
        [_comprehensiveSequencingView addSubview:topLineView];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenW, 150)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_comprehensiveSequencingView addSubview:whiteView];
        
        for (int i=0; i<3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 15+i*40, kScreenW, 40);
            button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
            [button setTitleColor:kdetailColor forState:UIControlStateNormal];
            [button setTitleColor:kMainColor forState:UIControlStateSelected];
            [button setTitle:_comprehensiveArr[i] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(comprehensiveSequencingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:button];
        }
    }
    return _comprehensiveSequencingView;
}

//根据日租金排序
- (UIView *)createRentSortingView{
    if (!_rentSortingView) {
        _rentSortingView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+44+kStatutesBarH, kScreenW, kScreenH)];
        if (!_secondVC) {
            _rentSortingView.frame = CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH);
        }
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comprehensiveSequencingViewTap:)];
        [bgView addGestureRecognizer:singleTap];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [_rentSortingView addSubview:bgView];
        
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        topLineView.backgroundColor = klineColor;
        [_rentSortingView addSubview:topLineView];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenW, 230)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_rentSortingView addSubview:whiteView];
    
        for (int i=0; i<5; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 15+i*40, kScreenW, 40);
            button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
            [button setTitleColor:kdetailColor forState:UIControlStateNormal];
            [button setTitleColor:kMainColor forState:UIControlStateSelected];
            [button setTitle:_priceArr[i] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(rentSortingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:button];
        }
    }
    return _rentSortingView;
}

//根据综合筛选排序
- (UIView *)createMoreScreening{
    if (!_moreScreeningView) {
        _moreScreeningView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+44+kStatutesBarH, kScreenW, kScreenH)];
        if (!_secondVC) {
            _moreScreeningView.frame = CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH);
        }
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comprehensiveSequencingViewTap:)];
        [bgView addGestureRecognizer:singleTap];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [_moreScreeningView addSubview:bgView];
        
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        topLineView.backgroundColor = klineColor;
        [_moreScreeningView addSubview:topLineView];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenW, 420)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_moreScreeningView addSubview:whiteView];
        
        _filtrate = [[RHFiltrateView alloc] initWithTitles:@[@"车辆类型", @"座位数", @"是否敞篷"] items:_labelDatalArr];
        _filtrate.frame = CGRectMake(0, 0, kScreenW, 350);
        _filtrate.delegate = self;
        [whiteView addSubview:_filtrate];
        
        UIButton *resetButton = [UIButton buttonWithTitle:@"重置"];
        [resetButton setTitleColor:kMainColor forState:UIControlStateNormal];
        resetButton.frame = CGRectMake(15, 350, (kScreenW-45)/2, 44);
        [resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:resetButton];
        
        UIButton *button = [UIButton newButtonWithTitle:@"确定" sel:@selector(applyButtonClick) target:self cornerRadius:NO];
        
        button.frame = CGRectMake((kScreenW-45)/2+15, 350, (kScreenW-45)/2, 44);
        [whiteView addSubview:button];
    }
    return _moreScreeningView;
}

#pragma mark --------------头部条件筛选事件----------

- (void)resetButtonClick{
    [_filtrate resetListView];
    _chooseLabelArr = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
    [self applyButtonClick];
    
    [_priceButton setTitle:@"日租金" forState:UIControlStateNormal];
    [_comprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
    CGSize titleSize = [_priceButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    [_priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
}

- (void)applyButtonClick{
    [_moreScreeningView removeFromSuperview];
    _topSelectButton.selected = NO;
    
    [_priceButton setTitle:@"日租金" forState:UIControlStateNormal];
    [_comprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
    CGSize titleSize = [_priceButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    [_priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        
    
    for (DriveTravelListModel *model in _dataArr)
    {
        NSString *seats = [_chooseLabelArr[1] stringByReplacingOccurrencesOfString:@"" withString:@"座"];
        
        NSLog(@"AAA____________%@",seats);

        if ([model.seats isEqualToString:seats] || [_chooseLabelArr[1] isEqualToString:@"不限"])
        {
            NSLog(@"BBB____________%@",model.stereotype);

            if ([model.stereotype containsObject:_chooseLabelArr[0]] || [_chooseLabelArr[0] isEqualToString:@"不限"])
            {

                NSLog(@"CCC____________%@",model.specail);
                NSLog(@"DDD____________%@",model.carId);
                if ([model.specail containsObject:_chooseLabelArr[2]] || [_chooseLabelArr[2] isEqualToString:@"不限"])
                {
                    [tempArr addObject:model];
                }
            }
        }
        _dataArrayM = tempArr;
        [_pageView removeFromSuperview];
        [self.collection reloadData];
        if (self.dataArrayM.count == 0) {
            [self.collection addSubview:[self VFDefaultPageView:@"0"]];
        }
    }
}

- (void)filtrateView:(RHFiltrateView *)filtrateView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    [_chooseLabelArr replaceObjectAtIndex:indexPath.section withObject:_labelDatalArr[indexPath.section][indexPath.row]];
}


- (void)comprehensiveSequencingButtonClick:(UIButton *)sender{
    [_filtrate resetListView];
    _chooseLabelArr  = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
    [_comprehensiveButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    _comprehensiveStr = kFormat(@"%ld", sender.tag);
    
    NSMutableArray *arrayTemp = [[NSMutableArray alloc]init];
    for (CarModel *obj in _dataArr) {
        switch ([_priceStr intValue]) {
            case 0:
                if ([obj.price intValue]<=2000) {
                    [arrayTemp addObject:obj];
                }
                self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
                break;
            case 1:
                if ([obj.price intValue]>2000 && [obj.price intValue]<=4000) {
                    [arrayTemp addObject:obj];
                }
                self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
                break;
            case 2:
                if ([obj.price intValue]>4000 && [obj.price intValue]<=6000) {
                    [arrayTemp addObject:obj];
                }
                self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
                break;
            case 3:
                if ([obj.price intValue]>6000) {
                    [arrayTemp addObject:obj];
                }
                self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
                break;
            case 4:
                self.dataArrayM =_dataArr;
                break;
            default:
                break;
        }
    }
    
    switch (sender.tag) {
        case 0:
            [_pageView removeFromSuperview];
            [self.collection reloadData];
            if (self.dataArrayM.count == 0) {
                [self.collection addSubview:[self VFDefaultPageView:@"0"]];
            }
            [_comprehensiveSequencingView removeFromSuperview];
            _topSelectButton.selected = NO;
            break;
        case 1:
            [self rentCarCompletePriceSwitchClickWithType:0];
            break;
        case 2:
             [self rentCarCompletePriceSwitchClickWithType:1];
            break;
        default:
            break;
    }
}


- (void)comprehensiveSequencingViewTap:(UIGestureRecognizer *)tap{
    [_moreScreeningView removeFromSuperview];
    [_comprehensiveSequencingView removeFromSuperview];
    [_rentSortingView removeFromSuperview];
    _topSelectButton.selected = NO;
}

- (void)rentSortingButtonClick:(UIButton *)sender{
    [_rentSortingView removeFromSuperview];
    _topSelectButton.selected = NO;
    [_priceButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];

    CGSize titleSize = [sender.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    [_priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    [self rentCarPrice:sender.tag];
}

- (void)rentCarPrice:(NSUInteger)index{
    [_filtrate resetListView];
    _chooseLabelArr  = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
    NSMutableArray *arrayTemp = [[NSMutableArray alloc]init];
    
    _priceStr = kFormat(@"%ld", index);
    
    for (CarModel *obj in _dataArr) {
        switch (index) {
            case 0:
                if ([obj.price intValue]<=2000) {
                    [arrayTemp addObject:obj];
                }
                self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
                break;
            case 1:
                if ([obj.price intValue]>2000 && [obj.price intValue]<=4000) {
                    [arrayTemp addObject:obj];
                }
                self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
                break;
            case 2:
                if ([obj.price intValue]>4000 && [obj.price intValue]<=6000) {
                    [arrayTemp addObject:obj];
                }
                self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
                break;
            case 3:
                if ([obj.price intValue]>6000) {
                    [arrayTemp addObject:obj];
                }
                self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
                break;
            case 4:
                self.dataArrayM =_dataArr;
                break;
            default:
                break;
        }
    }
    
    switch ([_comprehensiveStr intValue]) {
        case 0:
            break;
        case 1:
            [self rentCarCompletePriceSwitchClickWithType:0];
            break;
        case 2:
            [self rentCarCompletePriceSwitchClickWithType:1];
            break;
        default:
            break;
    }
    
    [_pageView removeFromSuperview];
    [self.collection reloadData];
    if (self.dataArrayM.count == 0) {
        [self.collection addSubview:[self VFDefaultPageView:@"0"]];
    }
}
    
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    NSString *city = change[@"new"];
    [self.collection.mj_header beginRefreshing];
}

#pragma mark - UICollectionViewDataSource/UICollectionViewDelegate
// 设置区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



// 一个区里面返回多少块
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 从重用队列里面取出来可重用的cell
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    DriveTravelListModel *model = self.dataArrayM[indexPath.row];
    cell.model = model;
    if (kIsVersion9)
    {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    
    return cell;
}

//这个方法是用来设置每一个cell的大小的
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenW-12)/2, (kScreenW-12)/2 *kPicZoom+100);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 6, 5,6);
}

//设置列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 设置区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        if (self.dataArrayM.count!=0)
        {
            for (UIView *view in reusableView.subviews) {
                [view removeFromSuperview];
            }
            //
            if (!headerView) {
                [self createCarLogsCollectionViewHearderViewWithSuperView:reusableView];
            }else{
                [reusableView addSubview:headerView];
            }
            return reusableView;
        }else
        {
            return reusableView;
        }
    }
    reusableView.backgroundColor = [UIColor whiteColor];
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        return footerview;
    }
    return reusableView;
}

// 设置区头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //这个宽度没影响
    CGFloat viewH= (SCREEN_WIDTH - 14*WIDTH_RATE * 6)/ 5.f;
    if (self.dataArrayM.count == 0) {
        return CGSizeMake(kScreenW, (viewH + topBottomGap)*2+20.f+topBottomGap);
    } else
    {
        return CGSizeMake(kScreenW, (viewH + topBottomGap)*2+20.f+topBottomGap);
    }
}



// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArrayM.count > 0) {
        DriveTravelListModel *model = self.dataArrayM[indexPath.row];
        VFCarDetailViewController *vc = [[VFCarDetailViewController alloc]init];
        vc.carId = model.carId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //返回YES允许其item移动
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据
    id objc = [self.dataArrayM objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.dataArrayM removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataArrayM insertObject:objc atIndex:destinationIndexPath.item];
}


#pragma mark-------区头上的点击事件--------
// 车辆分类
- (void)createCarLogsCollectionViewHearderViewWithSuperView:(UIView *)backView
{
    
    CGFloat viewH= (SCREEN_WIDTH - 14*WIDTH_RATE * 6)/ 5.f;
    
    headerView= [[RentCarHearderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (viewH + topBottomGap)*2+20.f+topBottomGap)];
    kWeakself;
    
    if (_headerArr.count == 0) {
        [VFHttpRequest getCarBrandSuccessBlock:^(NSDictionary *data) {
            VFBaseMode *baseModel = [[VFBaseMode alloc]initWithDic:data];
            if ([baseModel.code intValue] == 1) {
                VFCarLogoModel *obj = [[VFCarLogoModel alloc]initWithDic:baseModel.data];
                weakSelf.headerArr = obj.brandList;
                [backView addSubview:headerView];
            }
        } withFailureBlock:^(NSError *error) {
            
        }];
    }else{
        headerView.dataArr = self.headerArr;
        [backView addSubview:headerView];
    }
    
    headerView.selectedBlock = ^(NSInteger tag){
        if (tag == 0) {
            [weakSelf.filtrate resetListView];
            _chooseLabelArr = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
            [weakSelf.priceButton setTitle:@"日租金" forState:UIControlStateNormal];
            [weakSelf.comprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
            CGSize titleSize = [weakSelf.priceButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            [weakSelf.priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
            [weakSelf.priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
        }
        VFCarLogoListModel *model = [[VFCarLogoListModel alloc]initWithDic:weakSelf.headerArr[tag]];
        [weakSelf getCarDataForLogoWithLogo:model.brand];
    };
}

#pragma mark - UIViewControllerPreviewingDelegate

// peek
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    // 获取按压的cell
    NSIndexPath *indexPath = [self.collection indexPathForCell:(UICollectionViewCell *)[previewingContext sourceView]];
    CarModel *model = self.dataArrayM[indexPath.row];
    // 设置预览页面及高度
    VFCarDetailViewController *detailView = [VFCarDetailViewController new];
    detailView.carId = model.car_ID;
//    detailView.isPreviewing = YES;
//    detailView.preferredContentSize = CGSizeMake(0.0, SpaceH(1000.0));
//    // 设置不被虚化的范围
//    CGRect rect = CGRectMake(0, 0, kScreenW, 180);
//    previewingContext.sourceRect = rect;
//    
//    // peek菜单点击
//    kWeakself;
//    detailView.RentPreViewActionBlock = ^{
//        [weakSelf rentCarWithModel:model];
//    };
    
    return detailView;
}

// pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPreviewingPopNotification object:nil];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //tableview停止滚动，开始加载图像
    if (!decelerate)
    {
        [self loadImageForCellRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //如果tableview停止滚动，开始加载图像
    [self loadImageForCellRows];
}

// 更新cell图片
- (void)loadImageForCellRows
{
    NSArray *cells = [self.collection indexPathsForVisibleItems];
//    kWeakself;
    [cells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    }];
}


#pragma mark - Private Methods
// 价格升降序
- (void)rentCarCompletePriceSwitchClickWithType:(NSInteger)type
{
    [_comprehensiveSequencingView removeFromSuperview];
    _topSelectButton.selected = NO;

    [self.collection setContentOffset:CGPointMake(0, 0) animated:YES];
    NSArray *arrayTemp = [NSArray array];
    
    if (type == 0) {
        arrayTemp = [self.dataArrayM sortedArrayUsingComparator:^NSComparisonResult(CarModel *obj1, CarModel *obj2)
                     {
                         if ([obj1.price integerValue] < [obj2.price integerValue]) {
                             return NSOrderedDescending;
                         }
                         else {
                             return NSOrderedAscending;
                         }
                     }];
    }else{
        arrayTemp = [self.dataArrayM sortedArrayUsingComparator:^NSComparisonResult(CarModel *obj1, CarModel *obj2) {
            if ([obj1.price integerValue] > [obj2.price integerValue]) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedAscending;
                
            }
        }];
    }
    
    self.dataArrayM = [NSMutableArray arrayWithArray:arrayTemp];
    [_pageView removeFromSuperview];
    [self.collection reloadData];
    if (self.dataArrayM.count == 0) {
        [self.collection addSubview:[self VFDefaultPageView:@"0"]];
    }
}

- (void)projectData
{
    _nameArr = [NSMutableArray arrayWithObjects:@"热门",@"超跑",@"商务",@"婚庆",@"豪车",@"敞篷", nil];
    kWeakself;
    [VFHttpRequest getCarBrandSuccessBlock:^(NSDictionary *data) {
        NSLog(@"AAA___\n%@",data);

        VFBaseMode *baseModel = [[VFBaseMode alloc]initWithDic:data];
        if ([baseModel.code intValue] == 1) {
            VFCarLogoModel *obj = [[VFCarLogoModel alloc]initWithDic:baseModel.data];
            weakSelf.headerArr = obj.brandList;
            [weakSelf.collection reloadData];
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

// 根据logo获取车辆
- (void)getCarDataForLogoWithLogo:(NSString *)logo
{
    [JSFProgressHUD showHUDToView:self.view];
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    kWeakself;
    
    [VFHttpRequest getCarListParameter:@{@"city_id":cityID,@"brand":logo} successBlock:^(NSDictionary *data) {
        
        NSLog(@"BBB___\n%@",data);
        
        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        if ([model.code intValue] == 1) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in model.data) {
                DriveTravelListModel *obj = [[DriveTravelListModel alloc]initWithDic:dic];
                [array addObject:obj];
            }
            [weakSelf.dataArrayM removeAllObjects];
            weakSelf.dataArrayM = [array mutableCopy];
            
            [_pageView removeFromSuperview];
            [weakSelf.collection reloadData];
            if (weakSelf.dataArrayM.count == 0) {
                [weakSelf.collection addSubview:[self VFDefaultPageView:@"0"]];
            }
        }
        [JSFProgressHUD hiddenHUD:self.view];
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];

    }];
}

- (void)getRefreshDataBy:(NSString *)cate
{
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    kWeakself;
    [VFHttpRequest getCarListParameter:@{@"city_id":cityID} successBlock:^(NSDictionary *data) {
        
        NSLog(@"<<<<<<<<<%@",data);
        
        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        if ([model.code intValue] == 1) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in model.data) {
                DriveTravelListModel *obj = [[DriveTravelListModel alloc]initWithDic:dic];
                [array addObject:obj];
            }
            [self.dataArrayM removeAllObjects];
            [self.defaultArrayM removeAllObjects];
            self.dataArrayM = [NSMutableArray arrayWithArray:array];
            self.defaultArrayM = [NSMutableArray arrayWithArray:array];
            self.dataArr = self.dataArrayM;
            
            [weakSelf.filtrate resetListView];
            _chooseLabelArr = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
            [_priceButton setTitle:@"日租金" forState:UIControlStateNormal];
            [_comprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
            CGSize titleSize = [_priceButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            [_priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
            [_priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [JSFProgressHUD hiddenHUD:self.view];
                //滚动
                count = 0;
                
                [_pageView removeFromSuperview];
                [weakSelf.collection reloadData];
                if (weakSelf.dataArrayM.count == 0) {
                    [weakSelf.collection addSubview:[self VFDefaultPageView:@"0"]];
                }
                
                [weakSelf.collection.mj_header endRefreshing];
            });
        }
        [JSFProgressHUD hiddenHUD:self.view];
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
        [ProgressHUD showError:@"加载失败"];
        [weakSelf.collection.mj_header endRefreshing];
    }];
}

- (UICollectionView *)collection
{
    if (!_collection) {
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
        //设置他的滑动方向
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH-108)collectionViewLayout:layout];
        if (_secondVC) {
            
            UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+44+kStatutesBarH, kScreenW, 32)];
            topView.backgroundColor = HexColor(0xF5A623);
            [self.view addSubview:topView];
            
            UILabel *label = [UILabel initWithTitle:@"全部车型都支持免押金" withFont:kTitleBigSize textColor:kWhiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [topView addSubview:label];
            label.frame =CGRectMake(0, 0, kScreenW, 32);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"icon-close_white"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(removeBUttonCick:) forControlEvents:UIControlEventTouchUpInside];
            [topView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(topView);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(44);
            }];
            
            _collection.frame = CGRectMake(0, 44+44+kStatutesBarH+32, kScreenW, kScreenH-44-44-kStatutesBarH-32);
        }
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.backgroundColor = kWhiteColor;
        //这个是注册区头的，第二个参数是你现在注册的是区头还是区尾
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
        
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        //先注册一个cell
        [_collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        
    }
    return _collection;
}

- (void)removeBUttonCick:(UIButton *)sender{
    UIView *superView = sender.superview;
    //UIView动画的block代码块模式
    [UIView animateWithDuration:1 animations:^{
        //动画的最终状态
         _collection.frame = CGRectMake(0, 44+44+kStatutesBarH, kScreenW, kScreenH-44-44-kStatutesBarH);
        superView.alpha = 0;
    }completion:^(BOOL finished) {
        [superView removeFromSuperview];
    }];
}

- (UILabel *)noDataLabel
{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavBarH, kScreenW, 80)];
        _noDataLabel.textAlignment = 1;
        _noDataLabel.text = @"加载失败, 请下拉重新加载!";
        _noDataLabel.font = [UIFont systemFontOfSize:15];
        _noDataLabel.textColor = [UIColor colorWithWhite:0.518 alpha:1.000];
    }
    return _noDataLabel;
}

- (NSMutableArray *)dataArrayM
{
    if (!_dataArrayM) {
        _dataArrayM = [NSMutableArray array];
    }
    
    return _dataArrayM;
}

- (NSMutableArray *)defaultArrayM
{
    if (!_defaultArrayM) {
        _defaultArrayM = [NSMutableArray array];
    }
    
    return _defaultArrayM;
}

#pragma mark--------------缺省view--------------------
- (VFDefaultPageView *)VFDefaultPageView:(NSString *)state{
    _pageView = [[VFDefaultPageView alloc]initWithFrame:CGRectMake(0, SpaceH(360), kScreenW, kScreenH - SpaceH(360))];
    kWeakSelf;
    if ([state isEqualToString:@"0"]) {
        _pageView.showImage.image =[UIImage imageNamed:@"image_infound"];
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
        NSDictionary *dic = @{@"brand":_showView.brandTextField.text,@"model":_showView.modelTextField.text};
        
        [VFHttpRequest userNeedCarParameter:dic successBlock:^(NSDictionary *data) {
            [CustomTool showOptionMessage:@"我们会尽快上架您所需要的车辆"];
        } withFailureBlock:^(NSError *error) {
            
        }];
    }
    [_showView animateOut];
}

@end

