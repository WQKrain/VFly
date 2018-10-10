//
//  MessageNoticeViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MessageNoticeViewController.h"
#import "MessageNoticeTableViewCell.h"
#import "MessageNoticeModel.h"
#import "VFNoticeViewController.h"
#import "VFOrderMesViewController.h"
#import "VFBillMesViewController.h"
#import "VFMessageCountModel.h"
#import "LoginViewController.h"
#import "WebViewVC.h"
#import "VFRegistHXModel.h"

@interface MessageNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , assign)NSInteger page;

@property (nonatomic , strong)UILabel *leftLabel;
@property (nonatomic , strong)UILabel *centerLabel;
@property (nonatomic , strong)UILabel *rightLabel;
@property (nonatomic , strong)NSArray<HConversation *> *conversastions;
@property (nonatomic , strong)VFDefaultPageView *pageView;
@property (nonatomic , strong)NSString *header;
@end

@implementation MessageNoticeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.leftButton.hidden = NO;
    [self loadMessageCount];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    _dataArr = [[NSMutableArray alloc]init];
    _page = 0;
    [self createView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.bounces = NO;
    [self loadData];
    
}

- (void)loadMessageCount{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (!token) {
        return;
    }
    
    [VFHttpRequest messageUnreadParameter:nil successBlock:^(NSDictionary *data) {
        
        NSLog(@">>>>>>>%@",data);
        
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        if ([model.code intValue] == 1) {
            VFMessageCountListModel *obj = [[VFMessageCountListModel alloc]initWithDic:model.data];
            if ([obj.wallet intValue] == 0)
            {
                _leftLabel.hidden = YES;
            }
            else
            {
                _leftLabel.hidden = NO;
                _leftLabel.text = kFormat(@"%@", obj.wallet);
            }
            
            if ([obj.order intValue] == 0)
            {
                _centerLabel.hidden = YES;
            }
            else
            {
                _centerLabel.hidden = NO;
                _centerLabel.text = kFormat(@"%@", obj.order);
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}


/*
- (UIView *)createHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/3+kNavTitleH)];
    NSArray *dataArr = @[[UIImage imageNamed:@"icon_mesage_bill"],[UIImage imageNamed:@"icon_message_DingDan"],[UIImage imageNamed:@"icon_Message_notice"]];
    NSArray *titleArr = @[@"账单消息",@"订单消息",@"通知消息"];
    
    UILabel *label = [UILabel initWithNavTitle:_header];
    label.frame = CGRectMake(15, 0, kScreenW-30, kNavTitleH);
    label.font = [UIFont systemFontOfSize:kNewBigTitle];
    [headerView addSubview:label];
    
    for (int i=0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*(kScreenW/3), kNavTitleH, kScreenW/3, kScreenW/3)];
        [headerView addSubview:view];
        
        anyButton *button = [anyButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kScreenW/3, kScreenW/3);
        [button setTitleColor:kdetailColor forState:UIControlStateNormal];
        [button setImage:dataArr[i] forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button changeImageFrame:CGRectMake((kScreenW/3-kSpaceW(51))/2, kSpaceW(18), kSpaceW(51), kSpaceW(51))];
        [button changeTitleFrame:CGRectMake(0, kSpaceW(69)+10, kScreenW/3, kTitleBigSize)];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UILabel *badgeLabel = [UILabel initWithFont:kTextBigSize textColor:kWhiteColor];
        badgeLabel.frame = CGRectMake(kSpaceW(75), kSpaceW(15), 16, 16);
        badgeLabel.backgroundColor = kNewSelectColor;
        badgeLabel.layer.cornerRadius = 8;
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:badgeLabel];
        badgeLabel.hidden = YES;
        switch (i) {
                case 0:
                _leftLabel = badgeLabel;
                break;
                case 1:
                _centerLabel = badgeLabel;
                break;
                case 2:
                _rightLabel = badgeLabel;
                break;
            default:
                break;
        }
        
    }
    return headerView;
}

- (void)buttonClick:(UIButton *)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (!token) {
        if (sender.tag == 0 || sender.tag == 1) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
            return;
        }
    }
    
    switch (sender.tag) {
        case 0:
        {
            VFBillMesViewController *vc = [[VFBillMesViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            VFOrderMesViewController *vc = [[VFOrderMesViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            VFNoticeViewController *vc = [[VFNoticeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
*/

- (void)createMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    }];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)loadData{
    [_pageView removeFromSuperview];
    _conversastions = [[HChatClient sharedClient].chatManager loadAllConversations];
    if (_conversastions.count == 0)
    {
    }
    [_tableView reloadData];
}

- (void)createView {
    _tableView = [[BaseTableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, kNavBarH, SCREEN_WIDTH_S, kScreenH);
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[MessageNoticeTableViewCell class] forCellReuseIdentifier:@"MessageNoticeTableViewCell"];
    
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
    titleLabel.text = @"消息";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
}

- (void)back:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MessageNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageNoticeTableViewCell"];
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
    }
    
    
    if (indexPath.row == 0)
    {
        MessageNoticeTableViewCell * noticeCell = [tableView dequeueReusableCellWithIdentifier:@"MessageNoticeTableViewCell"];
        noticeCell.backgroundColor = [UIColor whiteColor];
        if (noticeCell == nil)
        {
            noticeCell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
        }
        noticeCell.markImage.image = [UIImage imageNamed:@"message_icon_one"];
        noticeCell.titeLabel.text = @"账单信息";
        noticeCell.detailLabel.text = @"查看账单信息";
        
        return noticeCell;

    }
    else if (indexPath.row == 1)
    {
        MessageNoticeTableViewCell * noticeCell = [tableView dequeueReusableCellWithIdentifier:@"MessageNoticeTableViewCell"];
        noticeCell.backgroundColor = [UIColor whiteColor];
        if (noticeCell == nil)
        {
            noticeCell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
        }
        noticeCell.markImage.image = [UIImage imageNamed:@"message_icon_two"];
        noticeCell.titeLabel.text = @"订单信息";
        noticeCell.detailLabel.text = @"查看订单信息";

        return noticeCell;

    }
    else if (indexPath.row == 2)
    {
        MessageNoticeTableViewCell * noticeCell = [tableView dequeueReusableCellWithIdentifier:@"MessageNoticeTableViewCell"];
        noticeCell.backgroundColor = [UIColor whiteColor];
        if (noticeCell == nil)
        {
            noticeCell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
        }
        noticeCell.markImage.image = [UIImage imageNamed:@"message_icon_three"];
        noticeCell.titeLabel.text = @"客服信息";
        noticeCell.detailLabel.text = @"有问题随时可以来撩客服哦...";
        
        
        

        
        /*
        if (_conversastions.count !=0) {
            HConversation *message = _conversastions[indexPath.row];
            EMMessageBody *msgBody = message.latestMessage.body;
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    NSAttributedString *text = [[HDEmotionEscape sharedInstance] attStringFromTextForChatting:((EMTextMessageBody *)msgBody).text textFont:[UIFont systemFontOfSize:15]];
                    cell.detailLabel.attributedText = text;
                    
//                    cell.timelabel.text= [CustomTool changMonthStr:kFormat(@"%lld", message.latestMessage.timestamp/1000)];
                    if (message.unreadMessagesCount>0) {
                        cell.mesCountlabel.hidden = NO;
                        cell.mesCountlabel.text = kFormat(@"%d", message.unreadMessagesCount);
                    }else{
                        cell.mesCountlabel.hidden = YES;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        */
        
        
        return noticeCell;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        VFBillMesViewController *vc = [[VFBillMesViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        VFOrderMesViewController *vc = [[VFOrderMesViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        if([HChatClient sharedClient].isLoggedInBefore)
        {
            HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
            UINavigationController *chatNav=[[UINavigationController alloc]initWithRootViewController:chatVC];
            [weakSelf presentViewController:chatNav animated:YES completion:nil];
        }
        else
        {
            //未登录
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kHXUsernameAndPsw];
            if (dic) {
                VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:dic];
                HChatClient *client = [HChatClient sharedClient];
                [client loginWithUsername:model.username password:model.password];
            }else{
                [HttpManage getHxUserSuccessBlock:^(NSDictionary *data) {
                    NSLog(@">>>>>>>B");
                    
                    VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:data];
                    [[NSUserDefaults standardUserDefaults]setObject:@{@"activated":model.activated,@"created":model.created,@"modified":model.modified,@"password":model.password,@"type":model.type,@"username":model.username,@"uuid":model.uuid} forKey:kHXUsernameAndPsw];
                    HChatClient *client = [HChatClient sharedClient];
                    HError *error = [client loginWithUsername:model.username password:model.password];
                    if (!error) { //登录成功
                        HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
                        [weakSelf.navigationController pushViewController:chatVC animated:YES];
                    } else { //登录失败
                        return;
                    }
                } withFailureBlock:^(NSError *error) {
                    
                }];
            }
        }
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
