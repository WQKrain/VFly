//
//  IntegralListViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "IntegralListViewController.h"
#import "IntegralModel.h"
#import "MoneyListTableViewCell.h"
#import "VFIntegralTableViewCell.h"
#import "IntegrlDetailViewController.h"

@interface IntegralListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)UILabel *rightLabel;
@property (nonatomic , assign)NSInteger page;
@property (nonatomic , strong)NSString *header;
@end

@implementation IntegralListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.UMPageStatistical = @"pointDetails";
    self.header = @"积分明细";
    self.view.backgroundColor = kWhiteColor;
    self.dataArr = [[NSMutableArray alloc]init];
    [self createView];
    [self loadData];
    [self createMJRefresh];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
    AdjustsScrollViewInsetNever(self, self.tableView);
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
    NSDictionary *dic = @{@"token":token,
                          @"limit":@"10",
                          @"page":@"0"};
    [HttpManage scoreLogParameter:dic success:^(NSDictionary *data) {
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        IntegralModel *model = [[IntegralModel alloc]initWithDic:data];
        for (NSDictionary *dic in model.logList) {
            IntegralListModel *obj = [[IntegralListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        if (_dataArr.count == 0) {
            [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_collection"] title:@"您还没有产生订单，没有积分哦"];
        }
        [_tableView reloadData];
        [weakSelf endRefresh];
    } failedBlock:^(NSError *error) {
        [weakSelf.tableView showEmptyViewWithType:0 image:[UIImage imageNamed:@""] title:@""];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    kWeakself;
    _page ++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",_page];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":token,
                          @"limit":@"10",
                          @"page":pageNum};

    [HttpManage scoreLogParameter:dic success:^(NSDictionary *data) {
        IntegralModel *model = [[IntegralModel alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"])
        {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            for (NSDictionary *dic in model.logList)
            {
                IntegralListModel *obj = [[IntegralListModel alloc]initWithDic:dic];
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
    [self.view addSubview:_tableView];
    _tableView.header = _header;

    [_tableView registerClass:[VFIntegralTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFIntegralTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    IntegralListModel *obj = _dataArr[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",obj.use];
    cell.topLabel.text = [CustomTool changTimeStr:obj.createTime];
    cell.detaillabel.text= obj.change;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IntegralListModel *obj = _dataArr[indexPath.row];
    IntegrlDetailViewController *vc = [[IntegrlDetailViewController alloc]init];
    vc.loginID = obj.integralId;
    [self.navigationController pushViewController:vc animated:YES];
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
