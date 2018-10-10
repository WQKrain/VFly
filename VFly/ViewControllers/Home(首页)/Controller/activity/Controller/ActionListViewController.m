//
//  ActionListViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ActionListViewController.h"
#import "RecentActivitiesModel.h"
#import "WebViewVC.h"
#import "VFNoticeTableViewCell.h"
@interface ActionListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , assign)NSInteger  page;
@property (nonatomic , strong)NSString *header;
@end

@implementation ActionListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"newsList";
    self.header = @"活动资讯";
    _page = 1;
    _dataArr = [[NSMutableArray alloc]init];
    [self createView];
    [self loadData];
    [self createMJRefresh];
    AdjustsScrollViewInsetNever(self, _tableView);
//    self.navigationItem.titleView = [UILabel initWithNavTitle:_header];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

-(void)loadData{
    kWeakself;
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    NSDictionary *dic = @{@"limit":@"10",@"page":@"1"};
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage getHomeActivitiesParameter:dic SuccessBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        RecentActivitiesModel *model = [[RecentActivitiesModel alloc]initWithDic:data];
        for (NSDictionary *dic in model.newsList) {
            RecentActivitiesListModel *obj = [[RecentActivitiesListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        [weakSelf.tableView reloadData];
        [weakSelf endRefresh];
    } withFailureBlock:^(NSString *result_msg) {
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}

- (void)loadMoreData{
    kWeakself;
    _page ++;
    NSString *p = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *dic = @{@"limit":@"10",@"page":p};
    [HttpManage getHomeActivitiesParameter:dic SuccessBlock:^(NSDictionary *data) {
        RecentActivitiesModel *model = [[RecentActivitiesModel alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            for (NSDictionary *dic in model.newsList) {
                RecentActivitiesListModel *obj = [[RecentActivitiesListModel alloc]initWithDic:dic];
                [weakSelf.dataArr addObject:obj];
            }
            [weakSelf.tableView reloadData];
            [self endRefresh];
        }
    } withFailureBlock:^(NSString *result_msg) {
        
    }];
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

- (void)createView{
    _tableView = [[BaseTableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.header = _header;
//    [_tableView registerNib:[UINib nibWithNibName:@"ActionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[VFNoticeTableViewCell class] forCellReuseIdentifier:@"cell"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenW-30)*6/13+141;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell = [[VFNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    RecentActivitiesListModel *obj = _dataArr[indexPath.row];
    [cell.markImage sd_setImageWithURL:[NSURL URLWithString:obj.image]];
    cell.titeLabel.text = obj.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailLabel.text = obj.actionDescription;
    cell.timelabel.text = kFormat(@"活动时间:%@", [CustomTool changYearStr:obj.time]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebViewVC *vc= [WebViewVC new];
    RecentActivitiesListModel *obj = _dataArr[indexPath.row];
    vc.urlStr = obj.url;
    vc.urlTitle = @"活动资讯";
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



