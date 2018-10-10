//
//  SettingViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "SettingViewController.h"
#import "feedbackViewController.h"
#import "aboutViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSArray *dataArr;
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"setting";
    _dataArr = @[@"意见反馈",@"关于我们"];
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.bounces = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(114);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    self.tableView.tableHeaderView = [self createHeaderView];
    self.tableView.tableFooterView = [self createFooterView];
}

- (UIView *)createFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 94)];
    UIButton *newButton = [UIButton newButtonWithTitle:@"退出登录"  sel:@selector(logoutButtonClick) target:self cornerRadius:YES];
    
    [footerView addSubview:newButton];
    [newButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(kScreenW-30);
    }];
    return footerView;
}

- (void)logoutButtonClick{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (UIView *)createHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 163)];
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"setting_image_logo"];
    [headerView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(130);
        make.width.mas_equalTo(99);
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    UILabel *version = [UILabel initWithTitle:kFormat(@"version:%@", app_Version)  withFont:kTextSize textColor:kdetailColor];
    version.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:version];
    
    [version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(icon.mas_bottom).offset(15);
        make.height.mas_equalTo(kTextSize);
        make.width.mas_equalTo(100);
    }];
    return headerView;
}

- (void)logOutBtnClick {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:access_Token];
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSNotification *notification =[NSNotification notificationWithName:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    

    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
              @"cell"];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    cell.textLabel.textColor = kdetailColor;
    if (indexPath.row == 2) {
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kTextSize];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){
        feedbackViewController *vc = [[feedbackViewController alloc]init];
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        aboutViewController *vc = [[aboutViewController alloc]init];
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self logOutBtnClick];
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
