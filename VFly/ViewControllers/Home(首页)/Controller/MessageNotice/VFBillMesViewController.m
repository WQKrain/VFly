//
//  VFBillMesViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/18.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFBillMesViewController.h"
#import "VFBillTableViewCell.h"
#import "VFOrderAndWalletMessageMOdel.h"
#import "RentCarViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"

@interface VFBillMesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , assign)NSInteger  page;

@property (nonatomic , strong)NSArray *colorArr;
@property (nonatomic , strong)NSArray *titleArr;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典

@property (nonatomic, strong) UIView *noDataView;

@end

@implementation VFBillMesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _colorArr = @[HexColor(0xe72528),HexColor(0xe72528),HexColor(0x3498db),HexColor(0x9b59b6),HexColor(0x1abc96),HexColor(0x5968f2),HexColor(0xff692e),HexColor(0xa8a8a8),HexColor(0x494949),HexColor(0xe72528),HexColor(0x3498db),HexColor(0x9b59b6)];
    _titleArr = @[@"",@"预订",@"待付",@"待退",@"出车",@"用车",@"成功",@"关闭",@"异常",@"充值",@"提现",@"消费"];
    _dataArr = [[NSMutableArray alloc]init];
    [self createView];
    [self loadData];
    [self createMJRefresh];
    AdjustsScrollViewInsetNever(self,self.tableView);
    
    
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
}

-(void)loadData{
    kWeakself;
    NSDictionary *dic = @{@"page_num":@"10",@"page":@"1",@"cate":@"1"};
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    [JSFProgressHUD showHUDToView:self.view];
    [VFHttpRequest userMessageParameter:dic successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        if ([model.code intValue] == 1)
        {
            for (NSDictionary *dic in model.data)
            {
                VFOrderAndWalletMessageListModel *obj = [[VFOrderAndWalletMessageListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            _dataArr = tempArr;
            if (_dataArr.count == 0)
            {
//                [self setupNoDataView];

                [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_message"] title:@"竟然一条消息也没有"];
            }
            else
            {
                [weakSelf.tableView reloadData];
            }
            [weakSelf endRefresh];
        }
        else
        {
//            [self setupNoDataView];

            [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_message"] title:@"竟然一条消息也没有"];
        }
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
        [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_message"] title:@"竟然一条消息也没有"];
//        [self setupNoDataView];
    }];
}

- (void)loadMoreData{
    kWeakself;
    _page ++;
    NSString *p = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *dic = @{@"limit":@"10",
                          @"page":p,
                          @"cate":@"1"};
    [VFHttpRequest userMessageParameter:dic successBlock:^(NSDictionary *data) {
        VFOrderAndWalletMessageMOdel *model = [[VFOrderAndWalletMessageMOdel alloc]initWithDic:data];
        for (NSDictionary *dic in model.messageList) {
            VFOrderAndWalletMessageListModel *obj = [[VFOrderAndWalletMessageListModel alloc]initWithDic:dic];
            [_dataArr addObject:obj];
        }
        [weakSelf.tableView reloadData];
        [weakSelf endRefresh];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)setupNoDataView {
    

    _noDataView = [[UIView alloc]init];
    _noDataView.frame = CGRectMake(50, kScreenH / 2 - 50, kScreenW - 100, 100);
    _noDataView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_noDataView];
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.frame = CGRectMake(0, 20, kScreenW - 100, 20);
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = HexColor(0x999999);
    textLabel.text = @"暂无账单消息";
    [_noDataView addSubview:textLabel];
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 50, kScreenW - 100, 50);
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(goToCars:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:@"前往车库 >" forState:(UIControlStateNormal)];
    [button setTitleColor:HexColor(0xE62327) forState:(UIControlStateNormal)];
    [_noDataView addSubview:button];
    
    
}


- (void)goToCars:(UIButton *)button {

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *controller = app.window.rootViewController;
     MainTabBarController *rvc = (MainTabBarController *)controller;
    [rvc setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];

}





- (void)createMJRefresh{
    kWeakSelf;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
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
    
    [_tableView registerClass:[VFBillTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
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
    titleLabel.text = @"账单消息";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
    
    
    
    
}

- (void)back:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 78;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFBillTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    VFOrderAndWalletMessageListModel *model = _dataArr[indexPath.row];
    cell.statelabel.text = _titleArr[model.otherStatus];
    UIColor *color = _colorArr[model.otherStatus];
    cell.statelabel.backgroundColor = color;
    cell.titeLabel.text = model.text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timelabel.text = [CustomTool changMonthStr:model.createTime];
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
