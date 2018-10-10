//
//  VFBananaListViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/10.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFBananaListViewController.h"
#import "BananaDetailModel.h"
#import "VFIntegralTableViewCell.h"
#import "VFBananaDetailViewController.h"

@interface VFBananaListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@property (nonatomic , assign)NSInteger page;
@property (nonatomic , strong)NSString *header;
@end

@implementation VFBananaListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.UMPageStatistical = @"balanceDetails";
    self.header = @"余额明细";
    self.dataArr = [[NSMutableArray alloc]init];
    [self loadData];
    [self createView];
    [self createMJRefresh];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
    AdjustsScrollViewInsetNever(self, _tableView);
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
    [HttpManage getWalletLogParameter:dic Success:^(NSDictionary *data) {
        [weakSelf.tableView removeEmptyView];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        BananaDetailModel *model = [[BananaDetailModel alloc]initWithDic:data];

        for (NSDictionary *dic in model.logList) {
            BananaDetailListModel *obj = [[BananaDetailListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        
        if (_dataArr.count == 0) {
            [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_order"] title:@"您还没有消费哦"];
        }
        [_tableView reloadData];
        [weakSelf endRefresh];
    } withFailedBlock:^{
        [weakSelf.tableView showEmptyViewWithType:0 image:[UIImage imageNamed:@""] title:@""];
    }];
}

- (void)loadMoreData{
    kWeakself;
    _page ++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",_page];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":token,@"limit":@"10",@"page":pageNum};
    [HttpManage getWalletLogParameter:dic Success:^(NSDictionary *data) {
        BananaDetailModel *model = [[BananaDetailModel alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            for (NSDictionary *dic in model.logList) {
                BananaDetailListModel *obj = [[BananaDetailListModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            [weakSelf.tableView reloadData];
            [weakSelf endRefresh];
        }
    } withFailedBlock:^{
        
    }];
}



- (void)createView{
    _tableView = [[BaseTableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.header = _header;
    //    [_tableView registerNib:[UINib nibWithNibName:@"BananaDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VFIntegralTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    BananaDetailListModel *obj = _dataArr[indexPath.row];
    cell.titleLabel.text = obj.des;
    cell.topLabel.text = [CustomTool changTimeStr:obj.createTime];
    cell.detaillabel.text= obj.change;
    return cell;
    
    //    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    //    }
    //    BananaDetailListModel *obj = _dataArr[indexPath.row];
    //    cell.textLabel.text= [NSString stringWithFormat:@"%@",[CustomTool changMonthStr:obj.createTime]];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",obj.des,obj.change];
    //    cell.textLabel.font = [UIFont systemFontOfSize:kTextSize];
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:kTextSize];
    //    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VFBananaDetailViewController *vc = [[VFBananaDetailViewController alloc]init];
    //self.hidesBottomBarWhenPushed = YES;
    BananaDetailListModel *obj = _dataArr[indexPath.row];
    vc.logId = obj.logId;
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
