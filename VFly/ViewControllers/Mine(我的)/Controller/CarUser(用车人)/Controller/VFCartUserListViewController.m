//
//  VFCartUserListViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCartUserListViewController.h"
//#import "VFUseCarUserTableViewCell.h"
#import "VFCarUserListCell.h"
#import "VFUseCarUseeListModel.h"
#import "VFAddUseCarUserViewController.h"
#import "VFIdentityAuthenticationViewController.h"
#import "WebViewVC.h"

@interface VFCartUserListViewController ()<UITableViewDelegate,UITableViewDataSource,VFCarUserListCellDelegate>
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)UITableView *tabeleView;

@end

@implementation VFCartUserListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSArray alloc]init];
    
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self setNav];
    [self createView];
}

- (void)setNav{
    
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
    titleLabel.text = @"用车人";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)loadData{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [VFHttpRequest usePeopleParameter:@{@"token":token} successBlock:^(NSDictionary *data) {
        NSLog(@"________________%@",data);
        
        VFBaseListMode *obj = [[VFBaseListMode alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in obj.data) {
            VFUseCarUseeListModel *model = [[VFUseCarUseeListModel alloc]initWithDic:dic];
            [tempArr addObject:model];
        }
        _dataArr = tempArr;
        [_tabeleView reloadData];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)createView{
    _tabeleView = [[UITableView alloc]init];
    _tabeleView.delegate = self;
    _tabeleView.dataSource = self;
    _tabeleView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tabeleView];
    [_tabeleView registerClass:[VFCarUserListCell class] forCellReuseIdentifier:@"VFCarUserListCell"];
    [_tabeleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFUseCarUseeListModel *model = _dataArr[indexPath.row];
    VFCarUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFCarUserListCell"];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenW);
    if (cell == nil)
    {
        cell = [[VFCarUserListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VFCarUserListCell"];
    }
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = model;
    return cell;
}



- (void)VFCarUserListCellClick:(NSInteger)tag model:(VFUseCarUseeListModel *)model {

    if (tag == 0)
    {
        if ([model.card_face isEqualToString:@""] || [model.driving_licence isEqualToString:@""]) {
            VFIdentityAuthenticationViewController *vc = [[VFIdentityAuthenticationViewController alloc]init];
            vc.userID = model.useman_id;
            if ([model.card_face isEqualToString:@""]) {
                vc.card_status = @"0";
            }else{
                vc.card_status = @"1";
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        WebViewVC *vc = [[WebViewVC alloc]init];
        vc.urlStr = kFormat(@"https://wechat.weifengchuxing.com/forApp/noDeposit_v2/noDeposit.html?useman_id=%@&token=",model.useman_id);
        vc.needToken = YES;
        vc.noNav = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
