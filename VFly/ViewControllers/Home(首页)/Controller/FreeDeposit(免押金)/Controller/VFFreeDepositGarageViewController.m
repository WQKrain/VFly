//
//  VFFreeDepositGarageViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/29.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFFreeDepositGarageViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "RentCarViewController.h"
#import "VFFreeDepositGarageCollectionViewCell.h"
#import "UIButton+WebCache.h"
#import "HttpManage.h"
#import "CarModel.h"
#import "Header.h"
#import "RentCarHearderView.h"
#import "LoginViewController.h"

#import "DriveTravelModel.h"
#import "RHFiltrateView.h"

#import "VFCarDetailViewController.h"
#import "VFSubmitCarAlertView.h"


#define kCellIdentifier      @"kCellIdentifier"
#define kHeaderIdentifier    @"kHeaderIdentifier"

@interface VFFreeDepositGarageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate, UIAlertViewDelegate,RHFiltrateViewDelegate,VFSubmitCarDidSelectbuttonDelegate>{
    NSInteger count;
    RentCarHearderView *headerView;
}

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSArray *headerArr;
@property (nonatomic, strong) NSMutableArray *dataArrayM;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *trademarkArr;
@property (nonatomic, strong) NSMutableArray *defaultArrayM;
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, strong) UILabel *noDataLabel;         //无数据时显示的Label
@property (nonatomic, strong) UILabel *freeDetailLabel;


@property (nonatomic , strong)UIButton *topSelectButton;

@property (nonatomic , strong)UIView *comprehensiveSequencingView;
@property (nonatomic , strong)UIView *rentSortingView;
@property (nonatomic , strong)UIView *moreScreeningView;

@property (nonatomic , strong)NSMutableArray *chooseLabelArr;
@property (nonatomic , strong)NSArray *labelDatalArr;

@property (nonatomic, strong) NSMutableDictionary *cellDic;
@property (nonatomic, strong) RHFiltrateView * filtrate;

@property (nonatomic, strong) UIButton * comprehensiveButton;
@property (nonatomic, strong) UIButton * topComprehensiveButton;
@property (nonatomic, strong) UIButton * priceButton;
@property (nonatomic, strong) UIButton * topPriceButton;
@property (nonatomic, strong) UIButton * moreButton;
@property (nonatomic, strong) UIButton * topMoreButton;

@property (nonatomic, strong) NSString * comprehensiveStr;
@property (nonatomic, strong) NSString * priceStr;
@property (nonatomic, strong) NSArray *comprehensiveArr;
@property (nonatomic, strong) NSArray *priceArr;
@property (nonatomic, strong) VFDefaultPageView *pageView;

@property (nonatomic, strong) VFSubmitCarAlertView *showView;

@property (nonatomic, strong) UIView *headerSelectView;
@property (nonatomic, strong) UIView *topHeaderView;

@property (nonatomic, strong) DriveTravelModel *driveTravelModel;

@end

@implementation VFFreeDepositGarageViewController

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
    _topComprehensiveButton.selected = NO;
    _priceButton.selected = NO;
    _topPriceButton.selected = NO;
    _moreButton.selected = NO;
    _topMoreButton.selected = NO;
    
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
    self.navBottomImageHidden = YES;
    self.index = chooseCarClass;
    self.headerArr = [[NSArray alloc]init];

    self.navTitleLabel.text = @"选择车辆";
    _dataArr = [[NSMutableArray alloc]init];
    self.cellDic = [[NSMutableDictionary alloc] init];
    _comprehensiveStr = @"0";
    _priceStr = @"4";
    _topHeaderView = [self createSelectViewTop];
    _topHeaderView.frame = CGRectMake(0, kStatutesBarH, kScreenW, 44);
    _topHeaderView.alpha = 0;
    [self.view addSubview:_topHeaderView];
    _comprehensiveArr = @[@"综合排序",@"价格最高",@"价格最低"];
    _priceArr = @[@"0-2000元",@"2000-4000元",@"4000-6000元",@"6000元以上",@"不限"];
    _chooseLabelArr = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
    _labelDatalArr = @[@[@"不限",@"跑车", @"商务", @"SUV"], @[@"不限", @"2座",@"4座", @"5座", @"7座"], @[@"不限", @"敞篷", @"个性门"]];
    self.view.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
    [self.view addSubview:self.collection];
    count=0;
    _trademarkArr = [NSMutableArray array];
    _urlArr = [NSMutableArray array];
    
    [self projectData];
    
    //监听用户所选地址是否已经变化
    [[ChangeCityTool changeCity] addObserver:self forKeyPath:@"city" options:NSKeyValueObservingOptionNew context:nil];
    kWeakSelf;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 134) {
        //根据偏移量来算出对应的 alpha 值
        CGFloat alpha = (offsetY-90)/44;
        if (alpha <= 0) {
            alpha = 0;
        }
        _topHeaderView.alpha = alpha;
    }else{
        _topHeaderView.alpha = 0;
    }
}

- (UIView *)createSelectViewTop{
    UIView *headerView= [[UIView alloc]init];
    headerView.backgroundColor = kWhiteColor;
    NSArray *dataArr = @[@"综合排序",@"日租金",@"更多筛选"];
    for (int i=0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:@"icon_unfold_off"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenW/3*i, 0, kScreenW/3, 42);
        [button setTitle:dataArr[i] forState:UIControlStateNormal];
        [button setTitleColor:kdetailColor forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_unfold_on"] forState:UIControlStateSelected];
        [button setTitleColor:kMainColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, -70)];
        
        switch (i) {
            case 0:
                _topComprehensiveButton = button;
                break;
            case 1:{
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
                _topPriceButton = button;
            }
                break;
            case 2:
                _topMoreButton = button;
                break;
            default:
                break;
        }
        
        button.tag = i;
        [button addTarget:self action:@selector(topSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kScreenW, 1)];
    lineView.backgroundColor = klineColor;
    [headerView addSubview:lineView];
    return headerView;
}


- (UIView *)createSelectView{
    UIView *headerView= [[UIView alloc]init];
    headerView.backgroundColor = kWhiteColor;
    NSArray *dataArr = @[@"综合排序",@"日租金",@"更多筛选"];
    for (int i=0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:@"icon_unfold_off"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenW/3*i, 0, kScreenW/3, 42);
        [button setTitle:dataArr[i] forState:UIControlStateNormal];
        [button setTitleColor:kdetailColor forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_unfold_on"] forState:UIControlStateSelected];
        [button setTitleColor:kMainColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, -70)];
        
        switch (i) {
            case 0:
                _comprehensiveButton = button;
                break;
            case 1:
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
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
        [headerView addSubview:button];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kScreenW, 1)];
    lineView.backgroundColor = klineColor;
    [headerView addSubview:lineView];
    return headerView;
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
                [self.view addSubview:[self comprehensiveSequencingViewState:@"0"]];
            }else{
                [_comprehensiveSequencingView removeFromSuperview];
            }
            break;
        case 1:
            if (sender.selected) {
                [_moreScreeningView removeFromSuperview];
                [_comprehensiveSequencingView removeFromSuperview];
                [self.view addSubview:[self createRentSortingViewState:@"0"]];
            }else{
                [_rentSortingView removeFromSuperview];
            }
            
            break;
        case 2:
            if (sender.selected) {
                [_rentSortingView removeFromSuperview];
                [_comprehensiveSequencingView removeFromSuperview];
                [self.view addSubview:[self createMoreScreeningState:@"0"]];
            }else{
                [_moreScreeningView removeFromSuperview];
            }
            break;
        default:
            break;
    }
    _topSelectButton = sender;
    
}

//根据日租金排序
- (UIView *)comprehensiveSequencingViewState:(NSString *)state{
    if (!_comprehensiveSequencingView) {
        _comprehensiveSequencingView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH)];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comprehensiveSequencingViewTap:)];
        [bgView addGestureRecognizer:singleTap];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [_comprehensiveSequencingView addSubview:bgView];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
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
    if ([state isEqualToString:@"0"]) {
        CGFloat offsetY = _collection.contentOffset.y;
        if (offsetY<=kNavBarH+134) {
            _comprehensiveSequencingView.frame = CGRectMake(0,kNavBarH+134-offsetY, kScreenW,  kScreenH-kNavBarH-134+offsetY);
        }else{
            _comprehensiveSequencingView.frame = CGRectMake(0,kNavBarH, kScreenW,  kScreenH-kNavBarH-134+offsetY);
        }
    }
    return _comprehensiveSequencingView;
}

//根据日租金排序
- (UIView *)createRentSortingViewState:(NSString *)state{
    if (!_rentSortingView) {
        _rentSortingView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH)];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comprehensiveSequencingViewTap:)];
        [bgView addGestureRecognizer:singleTap];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [_rentSortingView addSubview:bgView];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 230)];
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
    
    if ([state isEqualToString:@"0"]) {
        CGFloat offsetY = _collection.contentOffset.y;
        if (offsetY<=kNavBarH+134) {
            _rentSortingView.frame = CGRectMake(0,kNavBarH+134-offsetY, kScreenW,  kScreenH-kNavBarH-134+offsetY);
        }else{
            _rentSortingView.frame = CGRectMake(0,kNavBarH, kScreenW,  kScreenH-kNavBarH-134+offsetY);
        }
    }
    return _rentSortingView;
}

//根据综合筛选排序
- (UIView *)createMoreScreeningState:(NSString *)state{
    if (!_moreScreeningView) {
        _moreScreeningView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH)];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comprehensiveSequencingViewTap:)];
        [bgView addGestureRecognizer:singleTap];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [_moreScreeningView addSubview:bgView];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 420)];
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
        
        button.frame = CGRectMake(resetButton.right+15, 350, (kScreenW-45)/2, 44);
        [whiteView addSubview:button];
    }
    if ([state isEqualToString:@"0"]) {
        CGFloat offsetY = _collection.contentOffset.y;
        if (offsetY<=kNavBarH+134) {
            _moreScreeningView.frame = CGRectMake(0,kNavBarH+134-offsetY, kScreenW,  kScreenH-kNavBarH-134+offsetY);
        }else{
            _moreScreeningView.frame = CGRectMake(0,kNavBarH, kScreenW,  kScreenH-kNavBarH-134+offsetY);
        }
    }
    return _moreScreeningView;
}

#pragma mark --------------头部条件筛选事件----------

- (void)resetButtonClick{
    [_filtrate resetListView];
    _chooseLabelArr = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
    [self applyButtonClick];
    [_priceButton setTitle:@"日租金" forState:UIControlStateNormal];
    [_topPriceButton setTitle:@"日租金" forState:UIControlStateNormal];
    [_comprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
    [_topComprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
    CGSize titleSize = [_priceButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    [_priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    
    [_topPriceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_topPriceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
}

- (void)applyButtonClick{
    [_moreScreeningView removeFromSuperview];
    _topSelectButton.selected = NO;
    
    [_priceButton setTitle:@"日租金" forState:UIControlStateNormal];
    [_topPriceButton setTitle:@"日租金" forState:UIControlStateNormal];
    [_comprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
    [_topComprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
    CGSize titleSize = [_priceButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    [_priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    
    [_topPriceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_topPriceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (DriveTravelListModel *model in _dataArr) {
        NSString *seats = [_chooseLabelArr[1] stringByReplacingOccurrencesOfString:@"" withString:@"座"];
        if ([model.seats isEqualToString:seats] || [_chooseLabelArr[1] isEqualToString:@"不限"]){
            if ([model.stereotype containsObject:_chooseLabelArr[0]] || [_chooseLabelArr[0] isEqualToString:@"不限"]) {
                if ([model.specail containsObject:_chooseLabelArr[2]] || [_chooseLabelArr[2] isEqualToString:@"不限"]) {
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
    [_topComprehensiveButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    _comprehensiveStr = kFormat(@"%zi", sender.tag);
    
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
    [_topPriceButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    CGSize titleSize = [sender.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    [_priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    
    [_topPriceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [_topPriceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    
    [self rentCarPrice:sender.tag];
}

- (void)rentCarPrice:(NSUInteger)index{
    [_filtrate resetListView];
    _chooseLabelArr  = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
    NSMutableArray *arrayTemp = [[NSMutableArray alloc]init];
    
    _priceStr = kFormat(@"%zi", index);
    
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
    VFFreeDepositGarageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (cell != nil) {
        [cell.bottomView removeFromSuperview];
    }

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

// 设置每一个Itme的大小的
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-12)/2, (kScreenW-12)/2 *kPicZoom+145);
}

// 设置整个的四周边距的
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(9, 6, 9,6);
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0;
    
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
            if (!headerView) {
                [self createCarLogsCollectionViewHearderViewWithSuperView:reusableView];
            }else{
                _headerSelectView.frame = CGRectMake(0, 90, kScreenW, 42);
                [reusableView addSubview:[self collectionHeaderView]];
                [reusableView addSubview:_headerSelectView];
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

- (UIView *)collectionHeaderView{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 90)];
    UILabel *titleLabel = [UILabel initWithTitle:@"车库" withFont:kNewBigTitle textColor:kTitleBoldColor];
    titleLabel.frame = CGRectMake(15, 29, 65, 42);
    [titleView addSubview:titleLabel];

    _freeDetailLabel = [UILabel initWithTitle:@"您已获得万免押金额度，万以下押金可直接减免" withFont:kTextSmallSize textColor:kWhiteColor];
    
    if (_driveTravelModel) {
        _freeDetailLabel.text = _driveTravelModel.qualification_text;
    }
    
    _freeDetailLabel.backgroundColor = kTitleBoldColor;
    _freeDetailLabel.frame = CGRectMake(titleLabel.right+10, 47, kScreenW-100, 16);
    [_freeDetailLabel sizeToFit];
    _freeDetailLabel.height = _freeDetailLabel.height + 6;
    [titleView addSubview:_freeDetailLabel];
    return titleView;
}

// 设置区头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //这个宽度没影响
    if (self.dataArrayM.count == 0) {
        return CGSizeMake(kScreenW, SpaceH(360)+134);
    } else
    {
        return CGSizeMake(kScreenW, SpaceH(360)+134);
    }
}



// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArrayM.count > 0) {
        DriveTravelListModel *model = self.dataArrayM[indexPath.row];
        VFCarDetailViewController *vc = [[VFCarDetailViewController alloc]init];
        vc.carId = model.carId;
        vc.freeDeposit = YES;
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
    _headerSelectView = [self createSelectView];
    [backView addSubview:_headerSelectView];
    _headerSelectView.frame = CGRectMake(0, 90, kScreenW, 44);
    [backView addSubview:[self collectionHeaderView]];
    headerView= [[RentCarHearderView alloc] initWithFrame:CGRectMake(0, 134, kScreenW, SpaceW(360))];
    kWeakself;
    if (_headerArr.count == 0) {
        [HttpManage getCarLogoWithSuccessBlock:^(NSArray *data) {
            weakSelf.headerArr = data;
            headerView.dataArr = self.headerArr;
            [backView addSubview:headerView];
        } withFailureBlock:^(NSString *result_msg) {
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
            [weakSelf.topPriceButton setTitle:@"日租金" forState:UIControlStateNormal];
            [weakSelf.comprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
            [weakSelf.topComprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
            CGSize titleSize = [weakSelf.priceButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            [weakSelf.priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
            [weakSelf.priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
            
            [weakSelf.topPriceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
            [weakSelf.topPriceButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
        }
        CarModel *model = weakSelf.headerArr[tag];
        [weakSelf getCarDataForLogoWithLogo:model.name];
    };
}


// pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPreviewingPopNotification object:nil];
}

// 价格升降序
- (void)rentCarCompletePriceSwitchClickWithType:(NSInteger)type
{
    [_comprehensiveSequencingView removeFromSuperview];
    _topSelectButton.selected = NO;
    
    [self.collection setContentOffset:CGPointMake(0, 0) animated:YES];
    NSArray *arrayTemp = [NSArray array];
    arrayTemp = [self.dataArrayM sortedArrayUsingComparator:^NSComparisonResult(CarModel *obj1, CarModel *obj2) {
        if ([obj1.price integerValue] > [obj2.price integerValue]) {
            if (type == 0) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
            
        }
        else {
            if (type == 0) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
            
        }
    }];
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
    [HttpManage getCarLogoWithSuccessBlock:^(NSArray *data) {
        weakSelf.headerArr = data;
        [weakSelf.collection reloadData];
    } withFailureBlock:^(NSString *result_msg) {
    }];
}

// 根据logo获取车辆
- (void)getCarDataForLogoWithLogo:(NSString *)logo
{
    [JSFProgressHUD showHUDToView:self.view];
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    kWeakself;
    NSDictionary *dic = @{@"brand":logo,@"cityID":cityID,@"token":token};
    [HttpManage getFreedepositCarsParameter:dic successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        HCBaseMode *baseModel = [[HCBaseMode alloc]initWithDic:data];
        if ([baseModel.code isEqualToString:@"0"]) {
            _driveTravelModel = [[DriveTravelModel alloc]initWithDic:baseModel.data];
            NSArray *dataArr = _driveTravelModel.carList;
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in dataArr) {
                DriveTravelListModel *obj = [[DriveTravelListModel alloc]initWithDic:dic];
                [array addObject:obj];
            }
            [weakSelf.dataArrayM removeAllObjects];
            weakSelf.dataArrayM = array;
            
            [_pageView removeFromSuperview];
            [weakSelf.collection reloadData];
            if (weakSelf.dataArrayM.count == 0) {
                [weakSelf.collection addSubview:[self VFDefaultPageView:@"0"]];
            }
        }else{
            [CustomTool alertViewShow:baseModel.info];
        }
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}

- (void)getRefreshDataBy:(NSString *)cate
{
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    kWeakself;
    NSDictionary *dic = @{@"brand":@"",@"cityId":cityID,@"token":token};
    [HttpManage getFreedepositCarsParameter:dic successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        HCBaseMode *baseModel = [[HCBaseMode alloc]initWithDic:data];
        if ([baseModel.code isEqualToString:@"0"]) {
            _driveTravelModel = [[DriveTravelModel alloc]initWithDic:baseModel.data];
            NSArray *dataArr = _driveTravelModel.carList;
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in dataArr) {
                DriveTravelListModel *obj = [[DriveTravelListModel alloc]initWithDic:dic];
                [array addObject:obj];
            }
            [weakSelf.dataArrayM removeAllObjects];
            [weakSelf.defaultArrayM removeAllObjects];
            weakSelf.dataArrayM = [NSMutableArray arrayWithArray:array];
            weakSelf.defaultArrayM = [NSMutableArray arrayWithArray:array];
            weakSelf.dataArr = weakSelf.dataArrayM;
            
            [weakSelf.filtrate resetListView];
            _chooseLabelArr = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
            [weakSelf.priceButton setTitle:@"日租金" forState:UIControlStateNormal];
            [weakSelf.topPriceButton setTitle:@"日租金" forState:UIControlStateNormal];
            [weakSelf.comprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
            [weakSelf.topComprehensiveButton setTitle:@"综合排序" forState:UIControlStateNormal];
            
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
        }else{
            [CustomTool alertViewShow:baseModel.info];
        }
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
        layout.headerReferenceSize = CGSizeMake(320, SpaceH(360)+132);
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-44-kStatutesBarH)collectionViewLayout:layout];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.backgroundColor = kWhiteColor;
        //这个是注册区头的，第二个参数是你现在注册的是区头还是区尾
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
        
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        //先注册一个cell
        [_collection registerClass:[VFFreeDepositGarageCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    }
    return _collection;
}

- (UILabel *)noDataLabel
{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavBarH, kScreenW, 80)];
        _noDataLabel.textAlignment = 1;
        _noDataLabel.text = @"加载失败, 请下拉重新加载!";
        _noDataLabel.font = [UIFont systemFontOfSize:15];;
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
    kWeakSelf;
    _pageView = [[VFDefaultPageView alloc]initWithFrame:CGRectMake(0, SpaceH(360)+134, kScreenW, _collection.height - SpaceH(360)-134)];
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

@end
