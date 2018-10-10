//
//  VFSettingViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/12.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFSettingViewController.h"

#import "VFSettingPushCell.h"
#import "VFSettingDefault1Cell.h"
#import "VFSettingDefault2Cell.h"
#import "VFSettingLogoutCell.h"

#import "VFAboutVFlyController.h"
#import "VFRentCartAgreementController.h"
#import "VFFeedBackController.h"

@interface VFSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *settingTableView;


@end

@implementation VFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    
    [self setupTableView];
    [self setupNavigationView];
    
}


- (void)setupTableView {
    
    self.settingTableView = [[UITableView alloc]init];
    self.settingTableView.frame = CGRectMake(0, kNavBarH, kScreenW, kScreenH - kNavBarH);
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.settingTableView];
    [self.settingTableView registerClass:[VFSettingPushCell class] forCellReuseIdentifier:@"VFSettingPushCell"];
    [self.settingTableView registerClass:[VFSettingDefault1Cell class] forCellReuseIdentifier:@"VFSettingDefault1Cell"];
    [self.settingTableView registerClass:[VFSettingDefault2Cell class] forCellReuseIdentifier:@"VFSettingDefault2Cell"];
    [self.settingTableView registerClass:[VFSettingLogOutCell class] forCellReuseIdentifier:@"VFSettingLogOutCell"];
    
}






#pragma mark - setting NavigationBar
- (void)setupNavigationView {
    
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
    .bottomSpaceToView(backButton, 10)
    .heightIs(24)
    .widthIs(24);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        return 2;
    }
    else if (section == 3)
    {
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2)
    {
        return 50;
    }
    else if (indexPath.section == 3)
    {
        return 80;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            VFSettingDefault1Cell *cacheCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault1Cell"];
            if (cacheCell == nil)
            {
                cacheCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault1Cell"];
            }
            cacheCell.titleLabel.text = @"清理缓存";
            cacheCell.infomationLabel.text = @"0.00MB";
            
            return cacheCell;
        }
//        else if (indexPath.row == 1)
//        {
//            VFSettingPushCell *pushCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingPushCell"];
//            if (pushCell == nil)
//            {
//                pushCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingPushCell"];
//            }
//            pushCell.pushSwitch.hidden = YES;
//
//            return pushCell;
//        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            VFSettingDefault1Cell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault1Cell"];
            if (infoCell == nil)
            {
                infoCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault1Cell"];
            }
            infoCell.titleLabel.text = @"关于威风出行";
            infoCell.infomationLabel.text = @"v2.6.8";
            
            return infoCell;
        }
        else if (indexPath.row == 1)
        {

            VFSettingDefault2Cell *rentCarCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault2Cell"];
            if (rentCarCell == nil)
            {
                rentCarCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault2Cell"];
            }
            rentCarCell.titleLabel.text = @"威风出行租车协议";
            
            return rentCarCell;
        }
    }
    else if (indexPath.section == 2)
    {

        if (indexPath.row == 0)
        {
            VFSettingDefault2Cell *rentCarCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault2Cell"];
            if (rentCarCell == nil)
            {
                rentCarCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault2Cell"];
            }
            rentCarCell.titleLabel.text = @"评价威风出行";
            
            return rentCarCell;
        }
        else if (indexPath.row == 1)
        {
            VFSettingDefault2Cell *rentCarCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault2Cell"];
            if (rentCarCell == nil)
            {
                rentCarCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingDefault2Cell"];
            }
            rentCarCell.titleLabel.text = @"意见反馈";
            
            return rentCarCell;
        }
    }
    else if (indexPath.section == 3)
    {
        VFSettingLogOutCell *logOutCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingLogOutCell"];
        if (logOutCell == nil)
        {
            logOutCell = [tableView dequeueReusableCellWithIdentifier:@"VFSettingLogOutCell"];
        }
        kWeakSelf;
        logOutCell.logoutHander = ^{
            [weakSelf logout];
        };
        
        return logOutCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //清理缓存
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            //关于威风出行
            VFAboutVFlyController *aboutVC = [[VFAboutVFlyController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //w威风出行租车协议
            VFRentCartAgreementController *rentVC = [[VFRentCartAgreementController alloc]init];
            [self.navigationController pushViewController:rentVC animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            //评价威风出行
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppUrl]];

        }
        else if(indexPath.row == 1)
        {
            //意见反馈
            VFFeedBackController *feendVC = [[VFFeedBackController alloc]init];
            [self.navigationController pushViewController:feendVC animated:YES];
        }
        
    }
    
}

#pragma mark - 退出登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        [self logOutBtnClick];
    }
}

- (void)logout {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)logOutBtnClick {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:access_Token];
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSNotification *notification =[NSNotification notificationWithName:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
