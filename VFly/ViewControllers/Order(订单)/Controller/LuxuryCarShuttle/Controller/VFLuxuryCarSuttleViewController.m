//
//  VFLuxuryCarSuttleViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFLuxuryCarSuttleViewController.h"
#import "VFSuttleListModel.h"
#import "VFSuttleTableViewCell.h"
#import "VFChooseSeatsViewController.h"
#import "LoginViewController.h"
@interface VFLuxuryCarSuttleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)NSString *header;
@end

@implementation VFLuxuryCarSuttleViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"豪车接送";
    self.UMPageStatistical = @"pickUp";
    _dataArr = [[NSMutableArray alloc]init];
    [self createView];
    [self loadData];
    self.navTitleLabel.text = _header;
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)loadData{
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage getShuttleListSuccessBlock:^(NSDictionary *dic) {
        [JSFProgressHUD hiddenHUD:self.view];
        VFSuttleListModel *model = [[VFSuttleListModel alloc]initWithDic:dic];
        for (NSDictionary *tempDic in model.shuttleList) {
            VFSuttleListArrModel *obj = [[VFSuttleListArrModel alloc]initWithDic:tempDic];
            [_dataArr addObject:obj];
            [self.tableView reloadData];
        }
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.header = _header;
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [self tableFooterView];
    [_tableView registerClass:[VFSuttleTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (UIView *)tableFooterView{
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    UILabel *alertLabel = [UILabel initWithTitle:@"※根据车库存留情况分配，不可指定车型，有特殊需要可在备注中说明，威风出行会尽量满足您的要求。" withFont:kTextSize textColor:kNewDetailColor];
    alertLabel.numberOfLines = 0;
    [footView addSubview:alertLabel];
    alertLabel.frame = CGRectMake(20, 0, kScreenW-40, 34);
    return footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFSuttleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VFSuttleListArrModel *model = _dataArr[indexPath.row];
    [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"place_holer_750x500"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
        VFSuttleListArrModel *model = _dataArr[indexPath.row];
        if (_isChange) {
            if ([self.delegate respondsToSelector:@selector(carLevelButtonClick:)]) {
                [self.delegate carLevelButtonClick:model];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            VFChooseSeatsViewController *vc = [[VFChooseSeatsViewController alloc]init];
            vc.carModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
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
