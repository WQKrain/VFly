//
//  VFNoticeViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/18.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFNoticeViewController.h"
#import "VFNoticeTableViewCell.h"
#import "MessageNoticeModel.h"

@interface VFNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , assign)NSInteger  page;
@property (nonatomic , strong)NSString *header;

@end

@implementation VFNoticeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"通知消息";
    _page = 1;
    _dataArr = [[NSMutableArray alloc]init];
    [self createView];
    [self loadData];
    [self createMJRefresh];
    AdjustsScrollViewInsetNever(self,self.tableView);
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:_tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

-(void)loadData{
    kWeakself;
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    NSDictionary *dic = @{@"limit":@"10",@"page":@"1"};
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage getNoticeMessageParameter:dic successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        MessageNoticeModel *model = [[MessageNoticeModel alloc]initWithDic:data];
        for (NSDictionary *dic in model.messageList) {
            MessageNoticeListModel *obj = [[MessageNoticeListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        if (_dataArr.count == 0) {
            [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_message"] title:@"竟然一条消息也没有"];
        }else{
            [weakSelf.tableView reloadData];
        }
        [weakSelf endRefresh];
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
        [weakSelf.tableView showEmptyViewWithType:0 image:nil title:nil];
    }];
}

- (void)loadMoreData{
    kWeakself;
    _page ++;
    NSString *p = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *dic = @{@"limit":@"10",@"page":p};
    
    [HttpManage getNoticeMessageParameter:dic successBlock:^(NSDictionary *data) {
        MessageNoticeModel *model = [[MessageNoticeModel alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            for (NSDictionary *dic in model.messageList) {
                MessageNoticeListModel *obj = [[MessageNoticeListModel alloc]initWithDic:dic];
                [weakSelf.dataArr addObject:obj];
            }
            [weakSelf.tableView reloadData];
            [self endRefresh];
        }
    } withFailureBlock:^(NSError *error) {
        
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
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[VFNoticeTableViewCell class] forCellReuseIdentifier:@"cell"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenW-50)*6/13+163+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MessageNoticeListModel *obj = _dataArr[indexPath.row];
    [cell.markImage sd_setImageWithURL:[NSURL URLWithString:obj.image]];
    cell.titeLabel.text = obj.title;
    cell.detailLabel.text = obj.text;
    cell.timelabel.text = [CustomTool changYearStr:obj.createTime];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
