//
//  VFMyWalletViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFMyWalletViewController.h"
#import "BananaDetailModel.h"
#import "VFIntegralTableViewCell.h"
#import "VFBananaDetailViewController.h"
#import "VFBananaListViewController.h"
#import "paymentViewController.h"

@interface VFMyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *headerView;


@end

@implementation VFMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.dataArr = [[NSMutableArray alloc]init];
    
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    [self loadData];
    [self createView];
    [self createMJRefresh];
    [self setNav];
    AdjustsScrollViewInsetNever(self, _tableView);
}

- (void)setNav {
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatutesBarH + 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc]init];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.frame = CGRectMake(0, 0, 64, kStatutesBarH + 44);
    [navView addSubview:backButton];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_icon_back_black"]];
    [backButton addSubview:backImageView];
    backImageView.sd_layout
    .leftSpaceToView(backButton, 20)
    .bottomSpaceToView(backButton, 0)
    .heightIs(24)
    .widthIs(24);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"钱包";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [HttpManage getWalletLogParameter:dic Success:^(NSDictionary *data) {

        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        BananaDetailModel *model = [[BananaDetailModel alloc]initWithDic:data];
        
        for (NSDictionary *dic in model.logList) {
            BananaDetailListModel *obj = [[BananaDetailListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        
        if (_dataArr.count == 0)
        {
        }
        [_tableView reloadData];
        [weakSelf endRefresh];
    } withFailedBlock:^{

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
    [HttpManage getWalletLogParameter:dic Success:^(NSDictionary *data) {
        BananaDetailModel *model = [[BananaDetailModel alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"])
        {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            for (NSDictionary *dic in model.logList)
            {
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
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableHeaderView = [self headerView];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[VFIntegralTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (void)rechange:(UIButton *)sender {
    paymentViewController *vc = [[paymentViewController alloc]init];
    vc.isNew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoBankList:(UIButton *)sender {
    VFBananaListViewController *vc = [[VFBananaListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)headerView {
    if (!_headerView)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSpaceH(300))];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIView *walletBackView = [[UIView alloc]init];
        walletBackView.backgroundColor = HexColor(0xF54C51);
        walletBackView.frame = CGRectMake(20, 20, kScreenW - 40, kSpaceH(170));
        walletBackView.layer.cornerRadius = 5.f;
        [_headerView addSubview:walletBackView];
        
        UILabel *myWalletTitleLabel = [[UILabel alloc]init];
        myWalletTitleLabel.frame = CGRectMake(20, kSpaceH(24), 120, 20);
        myWalletTitleLabel.backgroundColor = [UIColor clearColor];
        myWalletTitleLabel.textColor = [UIColor whiteColor];
        myWalletTitleLabel.textAlignment = NSTextAlignmentLeft;
        myWalletTitleLabel.text = @"我的钱包余额：";
        myWalletTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        [walletBackView addSubview:myWalletTitleLabel];
        
        UILabel *myWalletMoneyLabel = [[UILabel alloc]init];
        myWalletMoneyLabel.frame = CGRectMake(20, kSpaceH(68), 200, 30);
        myWalletMoneyLabel.backgroundColor = [UIColor clearColor];
        myWalletMoneyLabel.textColor = [UIColor whiteColor];
        myWalletMoneyLabel.textAlignment = NSTextAlignmentLeft;
        myWalletMoneyLabel.text = [NSString stringWithFormat:@"%@",self.balance];
        myWalletMoneyLabel.font = [UIFont boldSystemFontOfSize:28];
        [walletBackView addSubview:myWalletMoneyLabel];
        
        UIButton *rechargeButton = [[UIButton alloc]init];
        rechargeButton.backgroundColor = [UIColor clearColor];
        [rechargeButton setTitle:@"充值" forState:(UIControlStateNormal)];
        [rechargeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        rechargeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        rechargeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [rechargeButton addTarget:self action:@selector(rechange:) forControlEvents:(UIControlEventTouchUpInside)];
        rechargeButton.frame = CGRectMake(30, 120, 64, 30);
        [walletBackView addSubview:rechargeButton];
        //------------------------
        UIButton *bankCardButton = [[UIButton alloc]init];
        bankCardButton.backgroundColor = [UIColor whiteColor];
        bankCardButton.frame = CGRectMake(20, kSpaceH(180), kScreenW - 40, kSpaceH(60));
        [bankCardButton addTarget:self action:@selector(gotoBankList:) forControlEvents:(UIControlEventTouchUpInside)];
        [_headerView addSubview:bankCardButton];
        
        UILabel *bankCardLabel = [[UILabel alloc]init];
        bankCardLabel.frame = CGRectMake(0, 0, kScreenW - 40, kSpaceH(60));
        bankCardLabel.backgroundColor = [UIColor clearColor];
        bankCardLabel.textColor = [UIColor blackColor];
        bankCardLabel.textAlignment = NSTextAlignmentLeft;
        bankCardLabel.text = @"我的银行卡";
        bankCardLabel.font = [UIFont boldSystemFontOfSize:18];
        [bankCardButton addSubview:bankCardLabel];
        
        UIImageView *pushImageV = [[UIImageView alloc]init];
        pushImageV.image = [UIImage imageNamed:@"page_icon_go_hui"];
        [bankCardButton addSubview:pushImageV];
        pushImageV.sd_layout
        .rightSpaceToView(bankCardButton, 0)
        .topSpaceToView(bankCardButton, kSpaceH(17))
        .heightIs(kSpaceH(16))
        .widthIs(kSpaceH(16));
        
        UILabel *myWalletDetailTitleLabel = [[UILabel alloc]init];
        myWalletDetailTitleLabel.frame = CGRectMake(20, kSpaceH(240), 200, kSpaceH(60));
        myWalletDetailTitleLabel.backgroundColor = [UIColor clearColor];
        myWalletDetailTitleLabel.textColor = [UIColor blackColor];
        myWalletDetailTitleLabel.textAlignment = NSTextAlignmentLeft;
        myWalletDetailTitleLabel.text = @"钱包明细";
        myWalletDetailTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_headerView addSubview:myWalletDetailTitleLabel];
    }
    return _headerView;
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
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    BananaDetailListModel *obj = _dataArr[indexPath.row];
    cell.titleLabel.text = obj.des;
    cell.topLabel.text = [CustomTool changTimeStr:obj.createTime];
    cell.detaillabel.text= obj.change;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VFBananaDetailViewController *vc = [[VFBananaDetailViewController alloc]init];
    BananaDetailListModel *obj = _dataArr[indexPath.row];
    vc.logId = obj.logId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
