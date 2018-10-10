//
//  MyWalletViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MyWalletViewController.h"
#import "HCBankCardViewController.h"
#import "VFBananaListViewController.h"
#import "paymentViewController.h"
#import "DrawMoneyModel.h"
#import "VFCouponsViewController.h"
#import "DrawMoneyAlertViewController.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)UIView *headerView;
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)UILabel *moneylabel;
@property (nonatomic , strong)NSArray *listImageArr;
@end

@implementation MyWalletViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"myWallet";
    [self customNavBarItem];
    _dataArr = @[@[@"银行卡",@"优惠券"]];
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self headerView];
//    AdjustsScrollViewInsetNever(self, _tableView);
    _tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
}

- (void)loadData{
    [HttpManage getMoneySuccess:^(NSDictionary *data) {
        NSLog(@"___________%@",data);
        
        
        DrawMoneyModel *model = [[DrawMoneyModel alloc]initWithDic:data];
        _moneylabel.text = [NSString stringWithFormat:@"¥%@",model.money];
    } failedBlock:^{
        
    }];
}


- (void)customNavBarItem
{
    //创建导航栏右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 25);
    [rightBtn setTitle:@"明细" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(CustomerService) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)CustomerService{
    VFBananaListViewController *vc = [[VFBananaListViewController alloc]init];
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,396)];
        _headerView.backgroundColor = kWhiteColor;
        NSArray *imageArr= @[[UIImage imageNamed:@"icon_charge"],[UIImage imageNamed:@"icon_withdraw"]];
        NSArray *labelArr= @[@"充值",@"提现"];
        
        
        UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,232)];
        topImage.image = [UIImage imageNamed:@"purse_image_background"];
        topImage.contentMode =  UIViewContentModeScaleAspectFill;
        [_headerView addSubview:topImage];
        
        anyButton *backButton = [anyButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, Status_Bar_Height, 80, 40);
        [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        [backButton changeImageFrame:CGRectMake(15, 31, 22, 22)];
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:backButton];
        
        
        anyButton *detailButton = [anyButton buttonWithType:UIButtonTypeCustom];
        detailButton.frame = CGRectMake(kScreenW-80, Status_Bar_Height, 80, 40);
        [detailButton setTitle:@"明细" forState:UIControlStateNormal];
        [detailButton.titleLabel setFont:[UIFont systemFontOfSize:kTitleBigSize]];
        [detailButton changeTitleFrame:CGRectMake(30, 31, 40, 22)];
        [detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:detailButton];
        
        UILabel *titleLabel = [UILabel initWithTitle:@"我的钱包" withFont:kNewBigTitle textColor:kWhiteColor];
        titleLabel.frame = CGRectMake(15, 75, kScreenW, kNewBigTitle);
        [_headerView addSubview:titleLabel];
        
        UILabel *moneyLabel = [UILabel initWithTitle:kFormat(@"¥%@", _balance)  withFont:kNewMoneyTitle textColor:kWhiteColor];
        _moneylabel = moneyLabel;
        moneyLabel.frame = CGRectMake(15, titleLabel.bottom+30, kScreenW, kNewMoneyTitle);
        [_headerView addSubview:moneyLabel];
        
        
        for (int i= 0; i<2; i++) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2.0 *i, 232, kScreenW/2, 149)];
            [_headerView addSubview:bgView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(0, 0, kScreenW/2, SpaceH(250));
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            
            UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 60, 60)];
            iconImage.centerX = button.centerX;
            iconImage.image = imageArr[i];
            [bgView addSubview:iconImage];
            

            UILabel *label = [UILabel initWithTitle:labelArr[i] withFont:kTitleBigSize textColor:kdetailColor];
            label.frame = CGRectMake(0, iconImage.bottom+13, kScreenW/2, kTitleBigSize);
            label.textAlignment = NSTextAlignmentCenter;
            [bgView addSubview:label];
        }
        
        UIView *lineView =[UIView initWithLineView];
        lineView.frame = CGRectMake(15, _headerView.bottom-16, kScreenW-30, 1);
        [_headerView addSubview:lineView];
        
    }
    return _headerView;
}

- (void)detailButtonClick{
    VFBananaListViewController *vc = [[VFBananaListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{
            paymentViewController *vc = [[paymentViewController alloc]init];
            vc.isNew = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            DrawMoneyAlertViewController *vc = [[DrawMoneyAlertViewController alloc]init];

            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArr = _dataArr[section];
    return tempArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *identifier = @"Mine_Cell";
    if (cell == nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    cell.textLabel.textColor = kdetailColor;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HCBankCardViewController *vc = [[HCBankCardViewController alloc]init];
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        VFCouponsViewController *vc = [[VFCouponsViewController alloc]init];
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
