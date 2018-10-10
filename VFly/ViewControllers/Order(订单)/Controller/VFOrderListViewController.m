//
//  VFOrderListViewController.m
//  VFly
//
//  Created by Hcar on 2018/4/14.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFOrderListViewController.h"
#import "VFOrderListTableViewCell.h"
#import "VFOrderListModel.h"
#import "VFNewOrderDetailViewController.h"
#import "MyOrderViewController.h"
#import "VFEvaluationOrderViewController.h"
#import "VFChoosePayViewController.h"
#import "VFPayRemainingMoneyViewController.h"
#import "VFNewRenewalViewController.h"
#import "VFOrderListPromptView.h"

@interface VFOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

//自驾订单nav展示的四个选择按钮view及其之上的控件
@property (nonatomic, strong) UIView *driveOrderState;
@property (nonatomic, strong) UIView *topMarkView;
@property (nonatomic, strong) UIButton *topSelectButton;

//自驾订单表头展示的四个选择按钮view及其之上的控件
@property (nonatomic, strong) UIView *headerDriveOrderState;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) NSInteger index;

@end

@implementation VFOrderListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"订单列表";
    [self.rightButton setImage:[UIImage imageNamed:@"icon_previous"] forState:UIControlStateNormal];
    _page = 1;
    _index = 500;
    [self customTableView];
    [self createMJRefresh];
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options: HYHidenControlOptionLeft |HYHidenControlOptionTitle];
    [self createNavView];
    AdjustsScrollViewInsetNever(self, _tableView);
    NSString *info = [[NSUserDefaults standardUserDefaults]objectForKey:kOrderAlertShow];
    if (![info isEqualToString:@"1"]) {
        VFOrderListPromptView *view= [[VFOrderListPromptView alloc]init];
        [self.view addSubview:view];
        [view show];
    }
}

- (void)defaultRightBtnClick{
    MyOrderViewController *vc = [[MyOrderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData{
    kWeakself;
    NSString * status = kFormat(@"%ld", _topSelectButton.tag-10+1);
    NSDictionary *dic = @{@"page":@"1",@"page_num":@"10",@"status":status};
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    [VFHttpRequest orderListParameter:dic successBlock:^(NSDictionary *data) {
        [weakSelf.tableView removeEmptyView];
        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        for (NSDictionary *dic in model.data) {
            VFOrderListModel *obj = [[VFOrderListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = [NSMutableArray arrayWithArray:tempArr];
        if (_dataArr.count == 0) {
            [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_orders"] title:@"暂无此类订单"];
            [weakSelf.tableView noContentViewFrame:CGRectMake(0, kNavTitleH+45, kScreenW, kScreenH-kNavTitleH-45)];
            [self.tableView noContentViewTop:@"50"];
        }
        [self endRefresh];
        [_tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
        [weakSelf.tableView showEmptyViewWithType:0 image:nil title:nil];
        [self endRefresh];
    }];
}

- (void)endRefresh{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
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
}

- (void)createMJRefresh{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)loadMoreData{
    
    _page++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *dic = @{@"page":pageNum,@"page_num":@"10",@"status":kFormat(@"%ld", _topSelectButton.tag-10+1)};
    kWeakSelf;
    [VFHttpRequest orderListParameter:dic successBlock:^(NSDictionary *data) {
        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        for (NSDictionary *dic in model.data) {
            VFOrderListModel *obj = [[VFOrderListModel alloc]initWithDic:dic];
            [_dataArr addObject:obj];
        }
        [self endRefresh];
        [self.tableView reloadData];

    } withFailureBlock:^(NSError *error) {
        [weakSelf.tableView showEmptyViewWithType:0 image:nil title:nil];
        [ProgressHUD showError:@"加载失败"];
        [_tableView.mj_header endRefreshing];
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VFOrderListModel *obj = _dataArr[indexPath.row];
    VFNewOrderDetailViewController *vc = [[VFNewOrderDetailViewController alloc]init];
    vc.orderID = obj.order_id;
    vc.isBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIView *)createFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 122)];
    UILabel *showlabel = [UILabel initWithTitle:@"没有更多了~" withFont:kTextSize textColor:kNewDetailColor];
    showlabel.frame = CGRectMake(15, 12, kScreenW-30, 17);
    showlabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:showlabel];
    return footView;
}

- (void)customTableView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = [self createTableHeaderView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerClass:[VFOrderListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

#pragma mark---------tableView 的代理事件------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[VFOrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    VFOrderListModel *obj = _dataArr[indexPath.row];
    cell.model = obj;
    kWeakSelf;
    cell.buttonClickBlock = ^(NSInteger tag) {
        switch (tag) {
            case 0:
                [weakSelf deleteOrder:obj.order_id];
                break;
            case 1:
                if ([obj.status isEqualToString:@"101"]) {
                    [weakSelf payDepositMoney:obj.order_id type:obj.should_pay_id];
                }else if([obj.status isEqualToString:@"221"]){
                     [weakSelf continueRentCar:obj.order_id endTime:obj.canPay];
                }else if([obj.status isEqualToString:@"211"]){
                    [weakSelf payRemainingMoney:obj.order_id];
                }else{
                    
                }
                break;
            case 2:
                [weakSelf continueRentCar:obj.order_id endTime:obj.canRenew];
                break;
            case 3:
                [weakSelf returnCar:obj.order_id];
                break;
            case 4:
                [weakSelf evaluationRentCar:obj.order_id];
                break;
            default:
                break;
        }
    };
    
    return cell;
}

- (void)deleteOrder:(NSString *)orderID{
    kWeakSelf;
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定删除吗"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        [JSFProgressHUD showHUDToView:self.view];
        [VFHttpRequest deleteOrderParameter:orderID SuccessBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            [EasyTextView showSuccessText:@"删除成功"];
            [weakSelf loadData];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];

        }];
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:NO completion:nil];
}

//评价
- (void)evaluationRentCar:(NSString *)orderID{
    VFEvaluationOrderViewController *vc = [[VFEvaluationOrderViewController alloc]init];
    vc.orderID = orderID;
    vc.isNew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//支付订金
- (void)payDepositMoney:(NSString *)orderID type:(NSString *)type{
    
    VFChoosePayViewController *vc = [[VFChoosePayViewController alloc]init];
    vc.orderID = orderID;
    vc.moneyType = type;
    [self.navigationController pushViewController:vc animated:YES];
}

//支付尾款
- (void)payRemainingMoney:(NSString *)orderID{
    
    VFPayRemainingMoneyViewController *vc = [[VFPayRemainingMoneyViewController alloc]init];
    vc.orderID = orderID;
    vc.isNew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



//还车
- (void)returnCar:(NSString *)orderID{
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定还车吗"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    kWeakSelf;
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        [JSFProgressHUD showHUDToView:self.view];
        [VFHttpRequest carReturnOrderID:orderID successBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            [EasyTextView showSuccessText:@"提交成功"];
            [weakSelf loadData];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
            [ProgressHUD showError:@"提交失败"];
        }];
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


//续租
- (void)continueRentCar:(NSString *)orderID endTime:(NSString *)endTime{
    VFNewRenewalViewController *vc = [[VFNewRenewalViewController alloc]init];
    vc.orderID = orderID;
    if ([endTime intValue] != 1) {
        vc.canPay = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFOrderListModel *obj = _dataArr[indexPath.row];
    NSInteger stats = [obj.status intValue];
    int height;
    int noClickHeight;
    height = 405;
    noClickHeight = 360;
    
    if (stats == 101) {
        return height;
    }else if (stats == 211){
        
        if ([obj.canPay isEqualToString:@"0"]) {
            return noClickHeight;
        }else{
            return height;
        }
    }
    else if (stats == 201){
        
        return noClickHeight;
        
    }else if (stats == 221){
        if ([obj.canRenew isEqualToString:@"1"]) {
            return height;
        }else{
            return height;
        }
        
    }else if (stats == 311){
        if ([obj.canEvaluation isEqualToString:@"0"]) {
            return height;
            
        }else{
            return noClickHeight;
        }
    }else{
        return noClickHeight;
    }
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
    
    return _headerView;
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
