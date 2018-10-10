//
//  VFIntegralViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFIntegralViewController.h"
#import "IntegralModel.h"

#import "VFIntegralTableViewCell.h"
#import "VFIntegrlDetailController.h"
#import "VFIntegralAboutViewController.h"

@interface VFIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *myIntegralLabel;

@end

@implementation VFIntegralViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = kWhiteColor;
    self.dataArr = [[NSMutableArray alloc]init];
    [self createView];
    [self loadData];
    [self createMJRefresh];
    AdjustsScrollViewInsetNever(self, self.tableView);
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
    [HttpManage scoreLogParameter:dic success:^(NSDictionary *data) {
        
        NSLog(@">>>>>>>%@",data);
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        IntegralModel *model = [[IntegralModel alloc]initWithDic:data];
        for (NSDictionary *dic in model.logList)
        {
            IntegralListModel *obj = [[IntegralListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        if (_dataArr.count == 0)
        {
        }
        [_tableView reloadData];
        [weakSelf endRefresh];
    } failedBlock:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
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
    
    [HttpManage scoreLogParameter:dic success:^(NSDictionary *data) {
        IntegralModel *model = [[IntegralModel alloc]initWithDic:data];
        if ([model.remainder isEqualToString:@"0"])
        {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            for (NSDictionary *dic in model.logList)
            {
                IntegralListModel *obj = [[IntegralListModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            [weakSelf.tableView reloadData];
            [weakSelf endRefresh];
        }
        
    } failedBlock:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)createView {
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self headerView];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[VFIntegralTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)about:(UIButton *)sender {
    VFIntegralAboutViewController *aboutVC = [[VFIntegralAboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (UIView *)headerView {
    if (!_headerView)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSpaceH(400))];
        _headerView.backgroundColor = [UIColor blackColor];
        
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSpaceH(200))];
        backgroundImageView.image = [UIImage imageNamed:@"integral_image_top"];
        backgroundImageView.userInteractionEnabled = YES;
        [_headerView addSubview:backgroundImageView];
        
        UIButton *backButton = [[UIButton alloc]init];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
        backButton.frame = CGRectMake(0, 0, 64, kStatutesBarH + 44);
        [backgroundImageView addSubview:backButton];
        
        UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_icon_back_white"]];
        [backButton addSubview:backImageView];
        backImageView.sd_layout
        .leftSpaceToView(backButton, 20)
        .bottomSpaceToView(backButton, 0)
        .heightIs(24)
        .widthIs(24);
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"积分";
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [backgroundImageView addSubview:titleLabel];
        
        UIButton *aboutButton = [[UIButton alloc]init];
        aboutButton.backgroundColor = [UIColor clearColor];
        [aboutButton setTitle:@"关于" forState:(UIControlStateNormal)];
        [aboutButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        aboutButton.titleLabel.font = [UIFont systemFontOfSize:14];
        aboutButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [aboutButton addTarget:self action:@selector(about:) forControlEvents:(UIControlEventTouchUpInside)];
        aboutButton.frame = CGRectMake(kScreenW - 84, 20, 64, kStatutesBarH + 44);
        [backgroundImageView addSubview:aboutButton];
        
        UILabel *myIntTextLabel = [[UILabel alloc]init];
        myIntTextLabel.frame = CGRectMake(20, kSpaceH(120), 100, 20);
        myIntTextLabel.backgroundColor = [UIColor clearColor];
        myIntTextLabel.textColor = [UIColor whiteColor];
        myIntTextLabel.textAlignment = NSTextAlignmentCenter;
        myIntTextLabel.text = @"我的积分：";
        myIntTextLabel.font = [UIFont boldSystemFontOfSize:16];
        [backgroundImageView addSubview:myIntTextLabel];
        
        self.myIntegralLabel = [[UILabel alloc]init];
        self.myIntegralLabel.frame = CGRectMake(20, kSpaceH(130), kScreenW - 40, kSpaceH(80));
        self.myIntegralLabel.backgroundColor = [UIColor clearColor];
        self.myIntegralLabel.textColor = [UIColor whiteColor];
        self.myIntegralLabel.textAlignment = NSTextAlignmentLeft;
        self.myIntegralLabel.text = @"123123";
        self.myIntegralLabel.font = [UIFont boldSystemFontOfSize:30];
        [backgroundImageView addSubview:self.myIntegralLabel];
        
        
        
        //---------------------------------
        UIView *backBottomView = [[UIView alloc]init];
        backBottomView.frame = CGRectMake(0, kSpaceH(200), kScreenW, kSpaceH(200));
        backBottomView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:backBottomView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backBottomView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(16,16)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = backBottomView.bounds;
        maskLayer.path = maskPath.CGPath;
        backBottomView.layer.mask = maskLayer;
        
        UILabel *topTitleLabel = [[UILabel alloc]init];
        topTitleLabel.textAlignment = NSTextAlignmentLeft;
        topTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        topTitleLabel.backgroundColor = [UIColor clearColor];
        topTitleLabel.textColor = [UIColor blackColor];
        topTitleLabel.textAlignment = NSTextAlignmentCenter;
        topTitleLabel.text = @"积分福利";
        [backBottomView addSubview:topTitleLabel];
        topTitleLabel.sd_layout
        .leftSpaceToView(backBottomView, 20)
        .topSpaceToView(backBottomView, 20)
        .heightIs(24);
        [topTitleLabel setSingleLineAutoResizeWithMaxWidth:0];
        
        
        UILabel *bottomTitleLabel = [[UILabel alloc]init];
        bottomTitleLabel.textAlignment = NSTextAlignmentLeft;
        bottomTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        bottomTitleLabel.backgroundColor = [UIColor clearColor];
        bottomTitleLabel.textColor = [UIColor blackColor];
        bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
        bottomTitleLabel.text = @"积分明细";
        [backBottomView addSubview:bottomTitleLabel];
        bottomTitleLabel.sd_layout
        .leftSpaceToView(backBottomView, 20)
        .bottomSpaceToView(backBottomView, 20)
        .heightIs(24);
        [bottomTitleLabel setSingleLineAutoResizeWithMaxWidth:0];
        
        
        UIView *welfareView = [[UIView alloc]init];
        welfareView.frame = CGRectMake(20, 64, kScreenW / 3 * 2, 90);
        welfareView.backgroundColor = HexColor(0xFAFAFA);
        welfareView.layer.cornerRadius = 5.0;
        [backBottomView addSubview:welfareView];
        
        UILabel *welfareTitLabel = [[UILabel alloc]init];
        welfareTitLabel.textAlignment = NSTextAlignmentLeft;
        welfareTitLabel.font = [UIFont boldSystemFontOfSize:16];
        welfareTitLabel.backgroundColor = [UIColor clearColor];
        welfareTitLabel.textColor = [UIColor blackColor];
        welfareTitLabel.textAlignment = NSTextAlignmentCenter;
        welfareTitLabel.text = @"兑换合伙人邀请码";
        [welfareView addSubview:welfareTitLabel];
        welfareTitLabel.sd_layout
        .leftSpaceToView(welfareView, 20)
        .topSpaceToView(welfareView, 20)
        .heightIs(24);
        [welfareTitLabel setSingleLineAutoResizeWithMaxWidth:0];
        
        UILabel *welfareTextLabel = [[UILabel alloc]init];
        welfareTextLabel.textAlignment = NSTextAlignmentLeft;
        welfareTextLabel.font = [UIFont boldSystemFontOfSize:12];
        welfareTextLabel.backgroundColor = [UIColor clearColor];
        welfareTextLabel.textColor = HexColor(0xA8A8A8);
        welfareTextLabel.textAlignment = NSTextAlignmentLeft;
        welfareTextLabel.text = @"使用1000积分兑换威风合伙人邀请码";
        [welfareView addSubview:welfareTextLabel];
        welfareTextLabel.numberOfLines = 0;
        welfareTextLabel.sd_layout
        .leftSpaceToView(welfareView, 20)
        .topSpaceToView(welfareView, 44)
        .widthIs(kScreenW / 3 * 2 - 30)
        .heightIs(24);
        
    }
    return _headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VFIntegralTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    IntegralListModel *obj = _dataArr[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",obj.use];
    cell.topLabel.text = [CustomTool changTimeStr:obj.createTime];
    
    if ([obj.change rangeOfString:@"-"].location != NSNotFound)
    {
        cell.detaillabel.text= [NSString stringWithFormat:@"%@",obj.change];
        cell.detaillabel.textColor = HexColor(0xE62327);
    }
    else
    {
        cell.detaillabel.text= [NSString stringWithFormat:@"+%@",obj.change];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IntegralListModel *obj = _dataArr[indexPath.row];
    VFIntegrlDetailController *vc = [[VFIntegrlDetailController alloc]init];
    vc.loginID = obj.integralId;

    if ([obj.change rangeOfString:@"-"].location != NSNotFound)
    {
        vc.isAdd = @"1";
    }
    else
    {
        vc.isAdd = @"2";

    }
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
