//
//  DepositListViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "DepositListViewController.h"
#import "MoneyListTableViewCell.h"
#import "VipLogModel.h"

@interface DepositListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)UILabel *rightLabel;

@property (nonatomic , assign)NSInteger page;
@property (nonatomic , strong)NSString *header;
@end

@implementation DepositListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.UMPageStatistical = @"memberBalanceDetails";
    self.header = @"预存款明细";
    self.dataArr = [[NSMutableArray alloc]init];
    [self loadData];
    [self createView];
    [self createMJRefresh];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)createMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)loadData{
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":token,@"limit":@"10",@"page":@"0"};
    
    [HttpManage vipLogParameter:dic success:^(NSDictionary *data) {
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        VipLogModel *model = [[VipLogModel alloc]initWithDic:data];
        for (NSDictionary *dic in model.logList) {
            VipLogListModel *obj = [[VipLogListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        if (_dataArr.count == 0) {
            [_tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_Coupon"] title:@"您没有预存款交易记录"];
        }
        [_tableView reloadData];
        [weakSelf endRefresh];
    } failedBlock:^(NSError *error) {
        [_tableView showEmptyViewWithType:1 image:nil title:nil];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    kWeakself;
    _page ++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",_page];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":token,@"limit":@"10",@"page":pageNum};
    
    [HttpManage vipLogParameter:dic success:^(NSDictionary *data) {
        VipLogModel *model = [[VipLogModel alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            for (NSDictionary *dic in model.logList) {
                VipLogListModel *obj = [[VipLogListModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            [weakSelf.tableView reloadData];
            [weakSelf endRefresh];
        }
    } failedBlock:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
}



- (void)createView{
    _tableView = [[BaseTableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.header = _header;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MoneyListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (UIView *)createTableHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    view.backgroundColor = kWhiteColor;
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 43)];
    leftLabel.text = @"剩余预存款";
    leftLabel.font = [UIFont systemFontOfSize:kTextBigSize];
    leftLabel.textColor = ktextGrayClolr;
    [view addSubview:leftLabel];
    
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-200, 0, 190, 43)];
    _rightLabel.textColor = ktitleColor;
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = [UIFont systemFontOfSize:kTextBigSize];
    [view addSubview:_rightLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kScreenW, 1)];
    lineView.backgroundColor = kBackgroundColor;
    [view addSubview:lineView];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = kBackgroundColor;
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    VipLogListModel *obj = _dataArr[indexPath.row];
    cell.topLabel.text = obj.change;
    cell.instructionsLabel.text = obj.des;
    cell.timeLabel.text = [CustomTool changYearStr:obj.createTime];
    cell.integralLabel.text = obj.balance;
    cell.integral.text = @"剩余金额";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
