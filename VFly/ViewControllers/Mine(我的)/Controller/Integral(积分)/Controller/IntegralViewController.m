//
//  IntegralViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/24.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralListViewController.h"
#import "LoginModel.h"
#import "IntegralShowTableViewCell.h"
#import "VFProbleDetailViewController.h"
#import <WebKit/WebKit.h>

@interface IntegralViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic , strong)UIButton *selsetButton;
@property (nonatomic , strong)UITableView *tabeleView;
@property (nonatomic , strong)UILabel *rightLabel;
@property (nonatomic , strong)UILabel *showLabel;
@property (nonatomic , strong)NSArray *bottomImageArr;
@property (nonatomic , strong)UIWebView *webV;
@property (nonatomic , strong)UIScrollView *rightSCrollView;

@property (nonatomic , strong)UIScrollView *scrollView;
@property (nonatomic , strong)UIView *markView;
@property (nonatomic , strong)UIButton *probleButton;
@end

@implementation IntegralViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"pointHomePage";
    self.view.backgroundColor = kWhiteColor;
    [self createView];
    [self loadData];
    [self replaceDefaultNavBar:[[UIView alloc]init]];
    AdjustsScrollViewInsetNever(self, _scrollView);
}

- (void)CustomerService{
    VFProbleDetailViewController *vc = [[VFProbleDetailViewController alloc]init];
    vc.name = @"积分问题";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
        [HttpManage getUserInfoWithToken:token withSuccessBlock:^(NSDictionary *dic) {
            LoginModel *model = [[LoginModel alloc]initWithDic:dic];
            _showLabel.text = model.score;
            [_showLabel sizeToFit];
        } withFailedBlock:^{
            [JSFProgressHUD hiddenHUD:self.view];
            [ProgressHUD showError:@"加载失败"];
        }];
    }
}

- (void)createView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _scrollView.contentSize = CGSizeMake(0, kScreenH);
    [self.view addSubview:_scrollView];
    
    //加载本地html文件
    NSString* path = [[NSBundle mainBundle] pathForResource:@"integral" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    _webV =[[UIWebView alloc] initWithFrame:CGRectMake(0, kScreenH *0.6+1, kScreenW, kScreenH-kScreenH*0.6)];
    _webV.delegate = self;
    [_scrollView addSubview:_webV];
    [_webV loadRequest:request];
    _webV.hidden = YES;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH*0.6)];
    [_scrollView addSubview:headerView];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:headerView.frame];
    topImage.image = isIPhoneX?[UIImage imageNamed:@"background_JiFen_long"]:[UIImage imageNamed:@"background_JiFen_short"];
    [headerView addSubview:topImage];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, kStatutesBarH, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 0);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *pointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pointBtn.frame = CGRectMake(kScreenW-60, kStatutesBarH, 44, 44);
    [pointBtn setTitle:@"明细" forState:UIControlStateNormal];
    [pointBtn addTarget:self action:@selector(pointDetailbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pointBtn];
    
    UILabel *titleLabel = [UILabel initWithTitle:@"积分" withFont:kNewBigTitle textColor:kWhiteColor];
    titleLabel.frame = CGRectMake(15, kStatutesBarH+44, kScreenW, 40);
    [titleLabel setFont:[UIFont fontWithName:kBlodFont size:kNewBigTitle]];
    [self.view addSubview:titleLabel];
    
    UIImageView *roundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_point"]];
    [headerView addSubview:roundImageView];
    [roundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.mas_equalTo(kStatutesBarH + kSpaceW(103));
        make.width.height.mas_equalTo(kSpaceW(149));
    }];
    
    _showLabel = [UILabel initWithTitle:@"" withFont:kNewMoneyTitle textColor:kWhiteColor];
    [roundImageView addSubview:_showLabel];
    [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(roundImageView);
        make.width.mas_lessThanOrEqualTo(roundImageView);
        make.height.mas_equalTo(kSpaceW(77));
    }];
    
    UILabel *currentIntegral = [UILabel initWithTitle:@"当前积分" withFont:kTextBigSize textColor:kWhiteColor];
    currentIntegral.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:currentIntegral];
    [currentIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showLabel.mas_bottom);
        make.height.mas_equalTo(20);
        make.left.right.equalTo(roundImageView);
    }];
    
    _probleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_probleButton setImage:[UIImage imageNamed:@"JiFen_image_problem"] forState:UIControlStateNormal];
    [_probleButton addTarget:self action:@selector(CustomerService) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_probleButton];
    [_probleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(roundImageView);
        make.width.height.mas_equalTo(kSpaceW(50));
    }];
    
    NSArray *titleArr = @[@"积分福利",@"积分相关"];
    for (int i=0; i<2; i++) {
        UIButton *choosebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choosebtn.frame = CGRectMake(i*(kScreenW/2), headerView.bottom-48, kScreenW/2, 48);
        [choosebtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [choosebtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [choosebtn setTitleColor:kNewPointSelectColor forState:UIControlStateSelected];
        [choosebtn setTintColor:kChoosebtnColor];
        choosebtn.tag= i;
        if (i==0) {
            choosebtn.selected = YES;
            _selsetButton = choosebtn;
        }
        [choosebtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:choosebtn];
    }
    
    _markView = [[UIView alloc]initWithFrame:CGRectMake(((kScreenW/2)-56)/2, kScreenH*0.6, 56, 1)];
    _markView.backgroundColor = kNewSelectColor;
    [_scrollView addSubview:_markView];
    
    _tabeleView = [[UITableView alloc]init];
    _tabeleView.frame = CGRectMake(0, headerView.bottom+1, kScreenH*0.6, kScreenH-kScreenH*0.6);
    _tabeleView.delegate = self;
    _tabeleView.dataSource = self;
    _tabeleView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [_tabeleView registerNib:[UINib nibWithNibName:@"IntegralShowTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_scrollView addSubview:_tabeleView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.height = webViewHeight;
    _scrollView.contentSize = CGSizeMake(kScreenW, kScreenH*0.6+webViewHeight);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 300)];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = kViewBgColor;
    [sectionHeader addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(271);
    }];
    
    UILabel *topTitleLabel = [UILabel initWithTitle:@"积分当钱用" withFont:kTitleSize textColor:kTitleBoldColor];
    [topTitleLabel setFont:[UIFont fontWithName:kBlodFont size:kTitleSize]];
    [bgView addSubview:topTitleLabel];
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(35);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *topLabel = [UILabel initWithTitle:@"每1000积分可抵扣租100元租金" withFont:kTextSize textColor:kdetailColor];
    [bgView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topTitleLabel);
        make.top.equalTo(topTitleLabel.mas_bottom);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *bottomTitleLabel = [UILabel initWithTitle:@"兑换合伙人邀请码" withFont:kTitleSize textColor:kTitleBoldColor];
    [bottomTitleLabel setFont:[UIFont fontWithName:kBlodFont size:kTitleSize]];
    [bgView addSubview:bottomTitleLabel];
    [bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(topLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *bottomLabel = [UILabel initWithTitle:@"您可使用1000积分兑换成威风合伙人的邀请码" withFont:kTextSize textColor:kdetailColor];
    [bgView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomTitleLabel);
        make.top.equalTo(bottomTitleLabel.mas_bottom);
        make.height.mas_equalTo(22);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"JiFen_image_more"]];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(243);
        make.height.mas_equalTo(80);
    }];
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 271;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntegralShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.contentView.backgroundColor = kWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftImageView.image = _bottomImageArr[0][indexPath.row];
    cell.topLabel.text = _bottomImageArr[1][indexPath.row];
    cell.bottomLabel.text = _bottomImageArr[2][indexPath.row];
    
    cell.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    cell.shadowView.layer.shadowOpacity = 0.15;
    cell.shadowView.layer.shadowRadius = 8.0;
    return cell;
}


- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pointDetailbtnClick{
    IntegralListViewController *vc = [[IntegralListViewController alloc]init];
    //self.hidesBottomBarWhenPushed = YES;
    vc.integral = _showLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnClick:(UIButton *)sender{
    if (sender.tag == 0) {
        _webV.hidden = YES;
        _tabeleView.hidden = NO;
        _markView.frame = CGRectMake(((kScreenW/2)-56)/2, kScreenH*0.6, 56, 1);
    }else{
        _tabeleView.hidden = YES;
        _webV.hidden = NO;
        _markView.frame = CGRectMake(((kScreenW/2)-56)/2+kScreenW/2, kScreenH*0.6, 56, 1);
    }
    _selsetButton.selected = NO;
    
    sender.selected = YES;
    _selsetButton = sender;
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
