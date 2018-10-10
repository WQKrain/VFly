//
//  VFOverdueCouponsViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFOverdueCouponsViewController.h"
#import "CouponsTableViewCell.h"
#import "couponModel.h"

@interface VFOverdueCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , assign)NSInteger page;
@property (nonatomic , strong)NSString *header;
@end

@implementation VFOverdueCouponsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"过期优惠券";
    _dataArr =[[NSMutableArray alloc]init];
    _page = 1;
    [self createView];
    [self loadData];
     AdjustsScrollViewInsetNever(self, _tableView);
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)loadData{
    kWeakSelf;
    [VFHttpRequest couponListParameter:@{@"type":@"0"} successBlock:^(NSDictionary *data) {
        NSLog(@">>>>>>>>>>>%@",data);

        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        if (model.data.count == 0) {
            [_tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_Coupon"] title:@"暂无优惠券，跟客服小姐姐撩一张试试？"];
        }else{
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in model.data) {
                newCouponListModel *obj = [[newCouponListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            _dataArr = tempArr;
        }
        [weakSelf.tableView reloadData];
        [weakSelf endRefreshTableView:_tableView];
    } withFailureBlock:^(NSError *error) {
        [weakSelf endRefreshTableView:_tableView];
        [ProgressHUD showError:@"加载失败"];
    }];
}

- (void)loadMoreDataState:(NSInteger)state page:(NSInteger)page{
    page++;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *dic = @{@"token":token,@"status":@"3",@"page":pageNum,@"limit":@"10"};
    kWeakself;
    [HttpManage couponParameter:dic success:^(NSDictionary *data) {
        couponModel *model = [[couponModel alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"]) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        for (NSDictionary *dic in model.couponList) {
            couponListModel *obj = [[couponListModel alloc]initWithDic:dic];
            [_dataArr addObject:obj];
        }
        [_tableView reloadData];
        [weakSelf endRefreshTableView:_tableView];
    } failedBlock:^(NSError *error) {
        [weakSelf endRefreshTableView:_tableView];
        [ProgressHUD showError:@"加载失败"];
    }];
}

-(void)endRefreshTableView:(UITableView *)tableView{
    [tableView.mj_footer endRefreshing];
    [tableView.mj_header endRefreshing];
}

- (void)beginRefershTableView:(UITableView *)tableView{
    [tableView.mj_header beginRefreshing];
}


- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.header = _header;
     _tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[CouponsTableViewCell class] forCellReuseIdentifier:@"cell"];
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self loadMoreDataState:1 page:_page];
//    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}


- (void)buttonClick{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kScreenW-56)*256/640+30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = kWhiteColor;
    couponListModel *list =_dataArr[indexPath.row];
    cell.topImage.image = [UIImage imageNamed:@"image_Coupon_inable"];
    cell.bottonLabel.text = [NSString stringWithFormat:@"%@～%@",list.startTime,list.endTime];
    cell.topLabel.text = [NSString stringWithFormat:@"¥%@",list.money];
    cell.detaillabel.text = [NSString stringWithFormat:@"满%@元可用",list.mk];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
