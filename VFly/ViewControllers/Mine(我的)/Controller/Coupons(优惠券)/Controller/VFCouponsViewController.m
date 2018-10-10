//
//  VFCouponsViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFCouponsViewController.h"
#import "CouponsTableViewCell.h"
#import "couponModel.h"
#import "VFOverdueCouponsViewController.h"

@interface VFCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)NSString *header;
@end

@implementation VFCouponsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"过期券" style:UIBarButtonItemStylePlain target:self action:@selector(defaultRightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"coupons";
    self.header = @"优惠券";
    [self.rightButton setTitle:@"查看过期券" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:kTextBlueColor forState:UIControlStateNormal];
    _dataArr =[[NSMutableArray alloc]init];
    [self createView];
    [self loadDataState];
    AdjustsScrollViewInsetNever(self, _tableView);
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options: HYHidenControlOptionTitle];
}

- (void)defaultRightBtnClick{
    VFOverdueCouponsViewController *vc= [[VFOverdueCouponsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadDataState{
    kWeakSelf;
    [VFHttpRequest couponListParameter:@{@"type":@"1"} successBlock:^(NSDictionary *data) {
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
    [self.tableView registerClass:[CouponsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataState];
    }];
//    _tableView.tableFooterView = [self tableFooterView];
    _tableView.tableFooterView = [[UIView alloc]init];
}

- (UIView *)tableFooterView{
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 81)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenW, 81);
    [button setTitle:@"查看过期券" forState:UIControlStateNormal];
    [button setTitleColor:kNewDetailColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:kTitleBigSize]];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    return footView;
}

- (void)buttonClick{
    VFOverdueCouponsViewController *vc= [[VFOverdueCouponsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kScreenW-16)*272/722+16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = kWhiteColor;
    newCouponListModel *list =_dataArr[indexPath.row];
    NSInteger style = [list.style integerValue];
    switch (style) {
        case 0:
            cell.topImage.image = [UIImage imageNamed:@"image_Coupon_Invalid"];
            break;
        case 1:
            cell.topImage.image = [UIImage imageNamed:@"image_Coupon_red"];
            break;
        case 2:
            cell.topImage.image = [UIImage imageNamed:@"image_Coupon_blue"];
            break;
        case 3:
            cell.topImage.image = [UIImage imageNamed:@"image_Coupon_yellow"];
            break;
        default:
            break;
    }
    
    cell.bottonLabel.text = [NSString stringWithFormat:@"%@～%@",[CustomTool changMonthStr:list.startTime],[CustomTool changMonthStr:list.endTime]];
    cell.topLabel.text = [NSString stringWithFormat:@"¥%@",list.money];
    cell.detaillabel.text = [NSString stringWithFormat:@"满%@元可用",list.mk];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNotification *notification =[NSNotification notificationWithName:@"jumpRent" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
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
