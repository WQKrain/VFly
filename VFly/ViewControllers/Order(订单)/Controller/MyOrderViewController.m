//
//  MyOrderViewController.m
//  LuxuryCar
//
//  Created by joyingnet on 16/8/6.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "MyOrderViewController.h"
#import "Header.h"
#import "HttpManage.h"
#import "MyOrderModel.h"
//自驾出行订单cell
#import "MyOrderNewTableViewCell.h"
//豪车接送订单cell
#import "VFPickUpOrderTableViewCell.h"
#import "VFOldChoosePayViewController.h"

#import "VFPayRemainingMoneyViewController.h"
#import "VFContinueRentCarViewController.h"
#import "VFEvaluationOrderViewController.h"
#import "VFOrdertailViewController.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger index;
    UIControl *_maskView;
}
@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *headerView;

//自驾订单nav展示的四个选择按钮view及其之上的控件
@property (nonatomic, strong) UIView *driveOrderState;
@property (nonatomic, strong) UIView *topMarkView;
@property (nonatomic, strong) UIButton *topSelectButton;

//接送订单nav展示的两个选择按钮view及其之上的控件
@property (nonatomic, strong) UIView *pickUpOrderState;
@property (nonatomic, strong) UIView *topPickUpMarkView;
@property (nonatomic, strong) UIButton *topPickUpSelectButton;

//接送订单表头展示的两个选择按钮view及其之上的控件
@property (nonatomic, strong) UIView *headerPickUpOrderState;
@property (nonatomic, strong) UIView *headerPickUpMarkView;
@property (nonatomic, strong) UIButton *headerPickUpSelectButton;

//自驾订单表头展示的四个选择按钮view及其之上的控件
@property (nonatomic, strong) UIView *headerDriveOrderState;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIButton *switchButton;

@end

@implementation MyOrderViewController

- (instancetype)init
{
    if (self = [super init]) {
        //self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"myOrder";
    self.header = @"订单列表";
    _page = 1;
    index= 500;
    [self createMJRefresh];
     [self createMaskView];
    [self createNavView];
    [self customTableView];
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options: HYHidenControlOptionLeft |HYHidenControlOptionTitle];
    
    //创建悬浮按钮
    _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchButton setImage:[UIImage imageNamed:@"Button_black_JieSong"] forState:UIControlStateNormal];
    [_switchButton setImage:[UIImage imageNamed:@"Button_white_ZiJia"] forState:UIControlStateSelected];
    [_switchButton addTarget:self action:@selector(chooseOrderState:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchButton];
    _switchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(137);
        make.bottom.mas_equalTo(-20-kSafeBottomH);
    }];
    
    [self loadData];
}

- (void)defaultRightBtnClick{
    
}

- (void)chooseOrderState:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        _pickUpOrderState.hidden = NO;
        _driveOrderState.hidden = YES;
        _headerPickUpOrderState.hidden = NO;
        _headerDriveOrderState.hidden = YES;
    }else{
        _pickUpOrderState.hidden = YES;
        _driveOrderState.hidden = NO;
        _headerPickUpOrderState.hidden = YES;
        _headerDriveOrderState.hidden = NO;
    }
    _page = 1;
    [self loadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 134) {
        //根据偏移量来算出对应的 alpha 值
        CGFloat alpha = (offsetY-90)/44;
        if (alpha <= 0) {
            alpha = 0;
        }
        _navView.alpha = alpha;
    }else{
        _navView.alpha = 0;
    }
}

- (void)createNavView{
    //注：此处计算间距为两端留15，按钮宽度40，间距20 15*2+40*4+20*3
    _navView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-244)/2, kStatutesBarH, 244, 44)];
    [self.view addSubview:_navView];
    _navView.alpha = 0;
    
    _driveOrderState = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _navView.width, _navView.height)];
    [_navView addSubview:_driveOrderState];
    NSArray *titleArr = @[@"待预定",@"进行中",@"已完成",@"已关闭"];
    for (int i=0; i<4; i++) {
        UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake(66*i, 0, 46, 44);
        [chooseButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
        [chooseButton setTitle:titleArr[i] forState:UIControlStateNormal];
        chooseButton.tag = 10+i;
        if (i==0) {
            chooseButton.selected = YES;
            _topSelectButton = chooseButton;
        }
        [chooseButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseButton setTitleColor:kTitleBoldColor forState:UIControlStateNormal];
        [chooseButton setTitleColor:kMainColor forState:UIControlStateSelected];
        [_driveOrderState addSubview:chooseButton];
    }
    
    _topMarkView = [[UIView alloc]initWithFrame:CGRectMake(0, 31, 46, 1)];
    _topMarkView.backgroundColor = kMainColor;
    [_driveOrderState addSubview:_topMarkView];
    
    
    _pickUpOrderState = [[UIView alloc]initWithFrame:CGRectMake((_navView.width-112)/2, 0, 112, _navView.height)];
    _pickUpOrderState.hidden = YES;
    [_navView addSubview:_pickUpOrderState];
    NSArray *pickUpArr = @[@"待支付",@"已付款"];
    for (int i=0; i<pickUpArr.count; i++) {
        UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake(60*i, 0, 46, 44);
        [chooseButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
        [chooseButton setTitle:pickUpArr[i] forState:UIControlStateNormal];
        chooseButton.tag = 100+i;
        if (i==0) {
            chooseButton.selected = YES;
            _topPickUpSelectButton = chooseButton;
        }
        [chooseButton addTarget:self action:@selector(pickUpChooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseButton setTitleColor:kTitleBoldColor forState:UIControlStateNormal];
        [chooseButton setTitleColor:kMainColor forState:UIControlStateSelected];
        [_pickUpOrderState addSubview:chooseButton];
    }

    _topPickUpMarkView = [[UIView alloc]initWithFrame:CGRectMake(0, 31, 46, 1)];
    _topPickUpMarkView.backgroundColor = kMainColor;
    [_pickUpOrderState addSubview:_topPickUpMarkView];
    
}

- (void)loadMoreData{
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    _page++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",_page];
    
    if (_switchButton.selected) {
        NSString * status = kFormat(@"%ld", _topPickUpSelectButton.tag-100+1);
        NSDictionary *dic = @{@"token":token,@"page":pageNum,@"limit":@"10",@"status":status};
        [HttpManage getUserShuttlesOrderParameter:dic success:^(NSDictionary *data) {
            MyPickUpOrderModel *model = [[MyPickUpOrderModel alloc]initWithDic:data];
            for (NSDictionary *dic in model.shuttles) {
                MyOrderListModel *obj = [[MyOrderListModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            _tableView.tableFooterView = [[UIView alloc]init];
            [self endRefresh];
            [_tableView reloadData];
            if ([model.hasMorePages isEqualToString:@""]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                _tableView.tableFooterView = [self createFootView];
            }
        } failure:^(NSError *error) {
            [weakSelf.tableView showEmptyViewWithType:0 image:nil title:nil];
            [ProgressHUD showError:@"加载失败"];
            [_tableView.mj_header endRefreshing];
        }];
    }else{
        NSDictionary *dic = @{@"token":token,@"page":pageNum,@"limit":@"10",@"status":kFormat(@"%ld", _topSelectButton.tag-10+1)};
        
        [HttpManage getUserOrderMessageParameter:dic success:^(NSDictionary *data) {
            MyOrderModel *model = [[MyOrderModel alloc]initWithDic:data];
            for (NSDictionary *dic in model.orderList) {
                MyOrderListModel *obj = [[MyOrderListModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            [self endRefresh];
            [self.tableView reloadData];
            if ([model.hasMorePages isEqualToString:@""]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                _tableView.tableFooterView = [self createFootView];
            }else{
                _tableView.tableFooterView = [[UIView alloc]init];
            }
        } failure:^(NSError *error) {
            [weakSelf.tableView showEmptyViewWithType:0 image:nil title:nil];
            [ProgressHUD showError:@"加载失败"];
            [_tableView.mj_header endRefreshing];
        }];
    }
}

- (void)createMJRefresh{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)endRefresh{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadData{
    kWeakself;
    if (_switchButton.selected) {
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        NSString * status = kFormat(@"%ld", _topPickUpSelectButton.tag-100+1);
        NSDictionary *dic = @{@"token":token,@"page":@"1",@"limit":@"10",@"status":status};
        [JSFProgressHUD showHUDToView:self.view];
        [HttpManage getUserShuttlesOrderParameter:dic success:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            [weakSelf.tableView removeEmptyView];
            MyPickUpOrderModel *model = [[MyPickUpOrderModel alloc]initWithDic:data];
            for (NSDictionary *dic in model.shuttles) {
                MyOrderListModel *obj = [[MyOrderListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            _dataArr = [NSMutableArray arrayWithArray:tempArr];
            
            if (_dataArr.count == 0) {
                [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_orders"] title:@"暂无此类订单"];
                [weakSelf.tableView noContentViewFrame:CGRectMake(0, kNavTitleH+45, kScreenW, kScreenH-kNavTitleH-45)];
                [self.tableView noContentViewTop:@"50"];
            }
            [_tableView reloadData];
            [self endRefresh];
            
            if ([model.hasMorePages isEqualToString:@""]) {
                if (_dataArr.count>0) {
                    _tableView.tableFooterView = [self createFootView];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    _tableView.tableFooterView = [[UIView alloc]init];
                }
            }else{
                _tableView.tableFooterView = [[UIView alloc]init];
            }
            
        } failure:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
            [weakSelf.tableView showEmptyViewWithType:0 image:nil title:nil];
            [ProgressHUD showError:@"加载失败"];
            [_tableView.mj_header endRefreshing];
        }];
    }else{
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        NSString * status = kFormat(@"%ld", _topSelectButton.tag-10+1);
        NSDictionary *dic = @{@"token":token,@"page":@"1",@"limit":@"10",@"status":status};
        
        [JSFProgressHUD showHUDToView:self.view];
        [HttpManage getUserOrderMessageParameter:dic success:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            [weakSelf.tableView removeEmptyView];
            MyOrderModel *model = [[MyOrderModel alloc]initWithDic:data];
            for (NSDictionary *dic in model.orderList) {
                MyOrderListModel *obj = [[MyOrderListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            _dataArr = [NSMutableArray arrayWithArray:tempArr];
            if (_dataArr.count == 0) {
                UIImage *image = [UIImage imageNamed:@"image_blankpage_orders"];
                if (_topSelectButton.tag-10 == 3) {
                    image = [UIImage imageNamed:@"image_blankpage_oders_gray"];
                }
                [weakSelf.tableView showEmptyViewWithType:1 image:image title:@"暂无此类订单"];
                [weakSelf.tableView noContentViewFrame:CGRectMake(0, kNavTitleH+45, kScreenW, kScreenH-kNavTitleH-45)];
                [self.tableView noContentViewTop:@"50"];
            }
            [_tableView reloadData];
            [self endRefresh];
            
            if ([model.hasMorePages isEqualToString:@""]) {
                if (_dataArr.count>0) {
                    _tableView.tableFooterView = [self createFootView];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    _tableView.tableFooterView = [[UIView alloc]init];
                }
            }else{
                _tableView.tableFooterView = [[UIView alloc]init];
            }
        } failure:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
            [weakSelf.tableView showEmptyViewWithType:0 image:nil title:nil];
            [ProgressHUD showError:@"加载失败"];
            [_tableView.mj_header endRefreshing];
        }];
    }
}


- (void)createMaskView
{
    _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    //设置背景颜色
    _maskView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.3];
    //隐藏遮罩视图
    _maskView.hidden = YES;
    [self.tabBarController.view addSubview:_maskView];
    //单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_maskView addGestureRecognizer:tap];
}

- (void)customTableView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = [self createTableHeaderView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerClass:[MyOrderNewTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[VFPickUpOrderTableViewCell class] forCellReuseIdentifier:@"pickUpCell"];
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
}

#pragma mark-----------tableView表头表尾-----------
- (UIView *)createTableHeaderView{
    _headerView = [[UIView alloc]init];
    _headerView.frame = CGRectMake(0, 0, kScreenW, kNavTitleH+45+10);
    UILabel *label = [UILabel initWithNavTitle:_header];
    label.frame = CGRectMake(15, 0, kScreenW-30, kNavTitleH);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kNewBigTitle];
    [_headerView addSubview:label];
    
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavTitleH, kScreenW, 1)];
    topLineView.backgroundColor = kHomeLineColor;
    [_headerView addSubview:topLineView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavTitleH+44, kScreenW, 1)];
    lineView.backgroundColor = kHomeLineColor;
    [_headerView addSubview:lineView];
    
    _headerDriveOrderState = [[UIView alloc]initWithFrame:CGRectMake(0, kNavTitleH, kScreenW, 44)];
    [_headerView addSubview:_headerDriveOrderState];
    NSArray *titleArr = @[@"待预定",@"进行中",@"已完成",@"已关闭"];
    for (int i=0; i<4; i++) {
        UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake((kScreenW-184-kSpaceW(40*3))/2+(46+kSpaceW(40))*i, 0, 46, 44);
        [chooseButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
        [chooseButton setTitle:titleArr[i] forState:UIControlStateNormal];
        chooseButton.tag = 10+i;
        if (i==0) {
            chooseButton.selected = YES;
            _selectButton = chooseButton;
        }
        [chooseButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseButton setTitleColor:kTitleBoldColor forState:UIControlStateNormal];
        [chooseButton setTitleColor:kMainColor forState:UIControlStateSelected];
        [_headerDriveOrderState addSubview:chooseButton];
    }
    
    _markView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-184-kSpaceW(40*3))/2, 44, 46, 1)];
    _markView.backgroundColor = kMainColor;
    [_headerDriveOrderState addSubview:_markView];
    
    _headerPickUpOrderState = [[UIView alloc]initWithFrame:CGRectMake(0, kNavTitleH, kScreenW, 44)];
    _headerPickUpOrderState.hidden = YES;
    [_headerView addSubview:_headerPickUpOrderState];
    NSArray *pickUpArr = @[@"待支付",@"已付款"];
    for (int i=0; i<pickUpArr.count; i++) {
        UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake((kScreenW-92-kSpaceW(40))/2+(46+kSpaceW(40))*i, 0, 46, 44);
        [chooseButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
        [chooseButton setTitle:pickUpArr[i] forState:UIControlStateNormal];
        chooseButton.tag = 100+i;
        if (i==0) {
            chooseButton.selected = YES;
            _headerPickUpSelectButton = chooseButton;
        }
        [chooseButton addTarget:self action:@selector(pickUpChooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseButton setTitleColor:kTitleBoldColor forState:UIControlStateNormal];
        [chooseButton setTitleColor:kMainColor forState:UIControlStateSelected];
        [_headerPickUpOrderState addSubview:chooseButton];
    }
    
    _headerPickUpMarkView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-92-kSpaceW(40))/2, 44, 46, 1)];
    _headerPickUpMarkView.backgroundColor = kMainColor;
    [_headerPickUpOrderState addSubview:_headerPickUpMarkView];
    
    return _headerView;
}

- (UIView *)createFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 122)];
    UILabel *showlabel = [UILabel initWithTitle:@"没有更多了~" withFont:kTextSize textColor:kNewDetailColor];
    showlabel.frame = CGRectMake(15, 12, kScreenW-30, 17);
    showlabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:showlabel];
    return footView;
}

- (void)chooseButtonClick:(UIButton *)sender{
    UIButton *topButton = [_navView viewWithTag:sender.tag];
    UIButton *headerButton = [_headerView viewWithTag:sender.tag];
    _topSelectButton.selected = NO;
    _selectButton.selected = NO;
    topButton.selected = YES;
    headerButton.selected = YES;
    _selectButton = headerButton;
    _topSelectButton = topButton;
    
    [UIView animateWithDuration:0.2 animations:^{
        //动画的最终状态
        _markView.frame =CGRectMake((kScreenW-184-kSpaceW(40*3))/2+(46+kSpaceW(40))*(sender.tag-10), 44, 46, 1);
        _topMarkView.frame = CGRectMake(66*(sender.tag-10), 31, 46, 1);
    }completion:^(BOOL finished) {
    }];
    
    [self loadData];

    _page = 1;
}

- (void)pickUpChooseButtonClick:(UIButton *)button{
    UIButton *topButton = [_navView viewWithTag:button.tag];
    UIButton *headerButton = [_headerView viewWithTag:button.tag];
    _headerPickUpSelectButton.selected = NO;
    _topPickUpSelectButton.selected = NO;
    topButton.selected = YES;
    headerButton.selected = YES;
    _headerPickUpSelectButton = headerButton;
    _topPickUpSelectButton = topButton;
    [UIView animateWithDuration:0.2 animations:^{
        _headerPickUpMarkView.frame =CGRectMake((kScreenW-92-kSpaceW(40))/2+(46+kSpaceW(40))*(button.tag-100), 44, 46, 1);
        _topPickUpMarkView.frame = CGRectMake(66*(button.tag-100), 31, 46, 1);
    }completion:^(BOOL finished) {
    }];
    
    _page = 1;
    [self loadData];
}

#pragma mark---------tableView 的代理事件------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderListModel *obj = _dataArr[indexPath.row];
    if (_switchButton.selected) {
        VFPickUpOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pickUpCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[VFPickUpOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pickUpCell"];
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.model = obj;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        kWeakSelf;
        cell.buttonClickBlock = ^(NSInteger tag) {
            switch (tag) {
                case 0:
                    [weakSelf deleteOrder:obj.orderId];
                    break;
                case 1:
                    if ([obj.status isEqualToString:@"1"]) {
                        [weakSelf payDepositMoney:obj.orderId type:obj.type];
                    }else if([obj.status isEqualToString:@"16"]){
                        [weakSelf continueRentCarPay:obj.orderId];
                    }else{
                        [weakSelf payRemainingMoney:obj.orderId unpaid:obj.canPay];
                    }
                    break;
                case 2:
                    [weakSelf continueRentCar:obj.orderId endTime:obj.useEndTime];
                    break;
                case 3:
                    [weakSelf returnCar:obj.orderId];
                    break;
                case 4:
                    [weakSelf evaluationRentCar:obj.orderId];
                    break;
                default:
                    break;
            }
        };
        return cell;
    }else{
        MyOrderNewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MyOrderNewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.model = obj;
        if (_topSelectButton.tag-10 == 3) {
            [cell.carImage sd_setImageWithURL:[NSURL URLWithString:obj.cover] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell.carImage.image = [self changeGrayImage:image];
            }];
        }else{
            [cell.carImage sd_setImageWithURL:[NSURL URLWithString:obj.cover] placeholderImage:[UIImage imageNamed:@"place_holer_750x500"]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        kWeakSelf;
        cell.buttonClickBlock = ^(NSInteger tag) {
            switch (tag) {
                case 0:
                    [weakSelf deleteOrder:obj.orderId];
                    break;
                case 1:
                    if ([obj.status isEqualToString:@"1"]) {
                        [weakSelf payDepositMoney:obj.orderId type:obj.type];
                    }else if([obj.status isEqualToString:@"16"]){
                        [weakSelf continueRentCarPay:obj.orderId];
                    }else{
                        [weakSelf payRemainingMoney:obj.orderId unpaid:obj.canPay];
                    }
                    break;
                case 2:
                    [weakSelf continueRentCar:obj.orderId endTime:obj.useEndTime];
                    break;
                case 3:
                    [weakSelf returnCar:obj.orderId];
                    break;
                case 4:
                    [weakSelf evaluationRentCar:obj.orderId];
                    break;
                default:
                    break;
            }
        };
        return cell;
    }
}

//续租支付
- (void)continueRentCarPay:(NSString *)orderID{
    VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
    vc.orderID = orderID;
    vc.moneyType = @"9";
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//删除订单
- (void)deleteOrder:(NSString *)orderID{
    kWeakSelf;
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定删除吗"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        [HttpManage orderDelParameter:@{@"token":token,@"orderId":orderID} success:^(NSDictionary *data) {
            
            HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
            if ([model.info isEqualToString:@"ok"]) {
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"删除成功"];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
                    [self loadData];
                }];
                
                [alertCtrl addAction:Action];
                [self presentViewController:alertCtrl animated:NO completion:nil];
            }else{
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.info];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
                [alertCtrl addAction:Action];
                [weakSelf presentViewController:alertCtrl animated:NO completion:nil];
            }
        } failedBlock:^(NSError *error) {
            
        }];
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//支付订金
- (void)payDepositMoney:(NSString *)orderID type:(NSString *)type{
    VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
    vc.orderID = orderID;
    if ([type isEqualToString:@"2"]) {
        vc.moneyType = @"10";
    }else{
        vc.moneyType = @"1";
    }
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//支付尾款
- (void)payRemainingMoney:(NSString *)orderID unpaid:(NSString *)unpaid{
    if ([unpaid isEqualToString:@"1"]) {
        VFPayRemainingMoneyViewController *vc = [[VFPayRemainingMoneyViewController alloc]init];
        vc.orderID = orderID;
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"您已全部支付哦"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
    }
}

//还车
- (void)returnCar:(NSString *)orderID{
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定还车吗"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        [HttpManage confirmReturnCarParameter:@{@"token":token,@"orderId":orderID} success:^(NSDictionary *data) {
            HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
            if ([model.info isEqualToString:@"ok"]) {
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"还车申请提交成功了哦"];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
                [alertCtrl addAction:Action];
                [self presentViewController:alertCtrl animated:NO completion:nil];
            }else{
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.info];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
                [alertCtrl addAction:Action];
                [self presentViewController:alertCtrl animated:NO completion:nil];
            }
        } failedBlock:^(NSError *error) {
            
        }];
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


//续租
- (void)continueRentCar:(NSString *)orderID endTime:(NSString *)endTime{
    VFContinueRentCarViewController *vc = [[VFContinueRentCarViewController alloc]init];
    vc.orderID = orderID;
    vc.endTimeStr = endTime;
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//评价
- (void)evaluationRentCar:(NSString *)orderID{
    VFEvaluationOrderViewController *vc = [[VFEvaluationOrderViewController alloc]init];
    vc.orderID = orderID;
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderListModel *obj = _dataArr[indexPath.row];
    NSInteger stats = [obj.status intValue];
    int height;
    int noClickHeight;
    if (_switchButton.selected) {
        height = 306;
        noClickHeight = 250;
    }else{
        height = 405;
        noClickHeight = 360;
    }

    if (stats == 1) {
        return height;
    }else if (stats == 3){
        
        if ([obj.canPay isEqualToString:@"0"]) {
           return noClickHeight;
        }else{
            return height;
        }
    }
    else if (stats == 2 || stats == 4 || stats == 5 || stats == 6 || stats == 7){
        
        return noClickHeight;
        
    }else if (stats == 8){
        if ([obj.canRenew isEqualToString:@"1"]) {
            return height;
        }else{
            return height;
        }
        
    }else if (stats == 9 || stats == 10 || stats == 11 || stats == 12 || stats == 15){
        if ([obj.isEvaluation isEqualToString:@"0"]) {
            return height;
            
        }else{
            return noClickHeight;
        }
    }else if (stats == 13 || stats == 14){
    
        if ([obj.isEvaluation isEqualToString:@"0"]) {
            return height;
        }else{
            return height;
        }
    }else if (stats == 16){
        if ([obj.isEvaluation isEqualToString:@"0"]) {
            return height;
        }else{
            return height;
        }
    }else{
       return noClickHeight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyOrderListModel *model = _dataArr[indexPath.row];
    VFOrdertailViewController *odVC = [[VFOrdertailViewController alloc] init];
    odVC.orderID = model.orderId;
    odVC.isBack = YES;
    [self.navigationController pushViewController:odVC animated:YES];
}

#pragma mark - CellBtnClickDelegate
- (void)queryOrderDetailBtnClick:(UIButton*)button
{
//    MyOrderListModel *model = _dataArr[button.tag];
//    OrderDetailsnVC *odVC = [[OrderDetailsnVC alloc] init];
//    odVC.isPayVC = YES;
//    odVC.order_id = model.orderId;
//    odVC.orderType = [model.type integerValue];
//    [self.navigationController pushViewController:odVC WithAnimationType:nil];
}

- (void)payOrderBtnClickWithOrderId:(NSString *)orderId withOrderInfo:(NSString *)orderInfo withOrderCost:(NSString *)orderCost
{
//    PayViewController *payVC = [PayViewController new];
//    payVC.orderId = orderId;
//    payVC.orderInfo = orderInfo;
//    payVC.orderCost = orderCost;
//    payVC.rentCar = YES;
//    [self.navigationController pushViewController:payVC WithAnimationType:nil];
}

- (void)willPayBackTheCarBtnClickWith:(NSString *)orderId
{
    kWeakself;
    HCAlertViewController *alertC = [HCAlertViewController alertControllerWithTitle:@"提示" message:@"确定要还车吗？"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertC addAction:cancelAction];
    HCAlertAction *sureAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        [HttpManage willGoBackTheCarWithOrderId:orderId withBlock:^(NSString *status) {
            if ([status isEqualToString:@"ok"]) {
                [alertC dismissViewControllerAnimated:YES completion:nil];
                HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"正在审核，请您耐心等待"];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
                [alertVC addAction:Action];
                [weakSelf presentViewController:alertVC animated:NO completion:nil];
            }
        }];
    }];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:NO completion:nil];
}

#pragma mark - 滑动加载图片
// scrollview delegate
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

//更新cell图片
- (void)loadImageForCellRows
{
//    NSArray *cells = [_tableView indexPathsForVisibleRows];
//    [cells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        NSIndexPath *indexPath = (NSIndexPath *)obj;
//        MyOrderNewTableViewCell *cell = (MyOrderNewTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
//        OrderModel *model = _dataArr[indexPath.row];
//    }];
}

#pragma mark - Private Methods

//返回
- (void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)callBtnAction
{
//    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:kServiceTel];
//    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
//    HCAlertAction *confirmAction = [HCAlertAction actionWithTitle:@"呼叫" handler:^(HCAlertAction *action) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",kServiceTel]]];
//    }];
//    [alertVC addAction:cancelAction];
//    [alertVC addAction:confirmAction];
//    [self presentViewController:alertVC animated:NO completion:nil];
}

//单击事件
- (void)tapAction
{
    [_maskView endEditing:YES];
}

//图片过滤去色
-(UIImage *)changeGrayImage:(UIImage *)oldImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = oldImage.size.width;
    int height = oldImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), oldImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

@end
