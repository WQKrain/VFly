//
//  VFAddressController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFAddressController.h"
#import "VFAddressCell.h"
#import "VFChooseAddressModel.h"

@interface VFAddressController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong)NSArray *addressArr;

@property (nonatomic, strong) UIView *noAddressView;
@property (nonatomic, strong) UIButton *noAddressButton;
@property (nonatomic, strong) UIButton *cartButton;

@end

@implementation VFAddressController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self setNav];
    _page = 1;

    self.addressArr = [[NSArray alloc]init];
    [self createView];
    [self createMJRefresh];
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
    titleLabel.text = @"常用地址";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
}

- (void)back:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)createMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)loadData{
    kWeakself;
    [VFHttpRequest addressParameter:@{} successBlock:^(NSDictionary *data) {
        [self.noAddressView removeFromSuperview];
        VFBaseListMode *obj = [[VFBaseListMode alloc]initWithDic:data];
        NSLog(@"____________%@",obj.date);
        
        _addressArr = obj.data;
        if (_addressArr.count == 0)
        {
            [weakSelf setupNoDataView];
        }
        [_tableView reloadData];
        [self endRefresh];
        
    } withFailureBlock:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
}



- (void)setupNoDataView {
    
    self.noAddressView = [[UIView alloc]init];
    self.noAddressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noAddressView];
    self.noAddressView.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(100)
    .centerYEqualToView(self.view);
    
    self.noAddressButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, kScreenW - 40, 30)];
    [self.noAddressButton setTitleColor:HexColor(0xABABAB) forState:(UIControlStateNormal)];
    [self.noAddressButton setTitle:@"暂无收藏车辆" forState:(UIControlStateNormal)];
    [self.noAddressButton setBackgroundColor:[UIColor whiteColor]];
    [self.noAddressView addSubview:self.noAddressButton];
    
    
    self.cartButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 60, kScreenW - 40, 40)];
    self.cartButton.backgroundColor = [UIColor whiteColor];
    [self.cartButton setTitle:@"前往车库 >" forState:(UIControlStateNormal)];
    [self.cartButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [self.cartButton addTarget:self action:@selector(goToCart:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.noAddressView addSubview:self.cartButton];
    
}

- (void)goToCart:(UIButton *)sender {
    //进入车库
    NSNotification *notification =[NSNotification notificationWithName:@"jumpRent" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createView{
    _tableView = [[BaseTableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[VFAddressCell class] forCellReuseIdentifier:@"VFAddressCell"];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VFAddressCell"];
    cell.backgroundColor = kBackgroundColor;
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"VFAddressCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VFChooseAddressModel *obj = [[VFChooseAddressModel alloc]initWithDic:_addressArr[indexPath.row]];
    cell.addressLabel.text = obj.address;

    return cell;
}













@end
