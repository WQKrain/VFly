//
//  MineViewController.m
//  JSFLuxuryCar
//
//  Created by joyingnet on 16/7/29.
//  Copyright © 2016年 joyingnet. All rights reserved.
//

#import "MineViewController.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "MineCell.h"

//#import "MyWalletViewController.h"
#import "VFMyWalletViewController.h"
//#import "SettingViewController.h"
#import "VFSettingViewController.h"

//#import "MyOrderModel.h"
#import "VFCollectorViewController.h"
#import "MyOrderTableViewCell.h"
//#import "MyDataViewController.h"//个人信息
#import "VFMyInfoViewController.h"
#import "VFCarApplyViewController.h"

#import "VIPViewController.h"
#import "PartnerViewController.h"
#import "WebViewVC.h"

//#import "IntegralViewController.h"
#import "VFIntegralViewController.h"
#import "ShowVipViewController.h"

//#import "EditAddressViewController.h"
#import "VFAddressController.h"
//#import "VFCouponsViewController.h"
#import "VFMyCouponViewController.h"
#import "VFNewOrderDetailViewController.h"
//
#import "ProblemViewController.h"
#import "VFCommonProblemController.h"
#import "OrderDetailModel.h"
#import "VFRealNameAuthenticationModel.h"
#import "VFObtainPlacesViewController.h"
#import "VFCustomerQualificationModel.h"
#import "MessageNoticeViewController.h"
#import "VFCartUserListViewController.h"    //用车人列表

#import "VFOrderListViewController.h"     //订单列表
#import "feedbackViewController.h"        //意见反馈
#import "VFUserInfoModel.h"

#import "VFLastOrderModel.h"
#import "VFAddUseCarUserViewController.h"

#import "VFMessageCountModel.h"            //未读消息数
#import "LoginModel.h"

#import "LoginViewController.h"
#import "VFLoginViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LoginViewControllerDelegate>
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)UIView *headerView;
@property (nonatomic , strong)UIView *footView;
@property (nonatomic , strong)UIButton *headerBtn;
@property (nonatomic , strong)UIImageView *headerImage;
@property (nonatomic , strong)UIButton *moneyButton;
@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)NSDictionary *dataDic;
@property (nonatomic , strong)NSArray *orderArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *shareAppTitle;
@property (nonatomic, strong) NSString *shareAppContent;
@property (nonatomic, strong) NSString *shareAppWeb;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) VFUserInfoModel *userInfoModel;

@property (nonatomic, strong) UILabel *messageCountlabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *backLogOutView;
@property (nonatomic, strong) UIImageView *backLogInView;
@property (nonatomic, strong) UILabel *localLabel;


@end

@implementation MineViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.dataArr = @[@[@"我的订单",@""]];
    [self createTableView];
    kWeakSelf;
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf loadData];
        });
    }];


}

- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -Status_Bar_Height, kScreenW, kScreenH-kTabBarH + Status_Bar_Height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.tableFooterView = [self footerView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[MyOrderTableViewCell class] forCellReuseIdentifier:@"MyOrderCell"];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    [self loadMessageCount];
}

- (void)loadMessageCount {
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (!token)
    {
        return;
    }
    [HttpManage unreadMessageSuccessBlock:^(NSDictionary *data) {
        if (data)
        {
            VFMessageCountModel *model = [[VFMessageCountModel alloc]initWithDic:data];
            VFMessageCountListModel *obj = [[VFMessageCountListModel alloc]initWithDic:model.message];
            NSArray<HConversation *> *conversastions = [[HChatClient sharedClient].chatManager loadAllConversations];
            if (conversastions && conversastions.count>0) {
                HConversation *message = conversastions[0];
                if ([obj.wallet intValue]>0 || [obj.order intValue]>0 || message.unreadMessagesCount>0) {
//                    _messageCountlabel.hidden = NO;
                }else{
//                    _messageCountlabel.hidden = YES;
                }
            }else{
                if ([obj.wallet intValue]>0 || [obj.order intValue]>0) {
//                    _messageCountlabel.hidden = NO;
                }else{
//                    _messageCountlabel.hidden = YES;
                }
            }
        }
        
    } withFailureBlock:^(NSError *error) {
        
    }];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)loadData {
    [VFHttpRequest getUserInfoSuccessBlock:^(NSDictionary *data) {
        NSLog(@">>>>>>>>%@",data);
        
        [self.tableView.mj_header endRefreshing];
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        _userInfoModel = [[VFUserInfoModel alloc]initWithDic:model.data];
        [[NSUserDefaults standardUserDefaults] setObject:_userInfoModel.phone forKey:kmobile];
        [[NSUserDefaults standardUserDefaults] setObject:_userInfoModel.userId forKey:UserId];
        [[NSUserDefaults standardUserDefaults] setObject:_userInfoModel.headimg forKey:kHeadImage];
        [self.headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_userInfoModel.headimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"加载"]];
        _nameLabel.text = _userInfoModel.nickname;
        _localLabel.text = _userInfoModel.cus_area;

        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        if (token)
        {
            self.backLogInView.hidden = NO;
            self.backLogOutView.hidden = YES;
        }
        else
        {
            self.backLogInView.hidden = YES;
            self.backLogOutView.hidden = NO;
        }
        
        [self.tableView reloadData];
        
    } withFailureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];

    }];
}


- (void)setting:(UIButton *)sender {
    VFSettingViewController *vc = [[VFSettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableView DataSource/Delegate
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        if (_userInfoModel.order.count == 0)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else
    {
        NSArray *arr = _dataArr[section];
        return arr.count;
    }
    return 0;
}


//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        NSString *cellIndentifier = @"MyOrderCell";
        MyOrderTableViewCell * orderCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (orderCell == nil) {
            orderCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        }

        if (_userInfoModel) {
            if (_userInfoModel.order.count !=0) {
                VFLastOrderModel *obj = [[VFLastOrderModel alloc]initWithDic:_userInfoModel.order[0]];
                orderCell.CarTitlelabel.text = [NSString stringWithFormat:@"%@ %@",obj.brand,obj.model];
                [orderCell.CarImage sd_setImageWithURL:[NSURL URLWithString:obj.car_img] placeholderImage:nil];
                orderCell.timeLabel.text = kFormat(@"¥%@/天", obj.re_day_rental);
                orderCell.statelabel.text = [NSString stringWithFormat:@"%@",obj.status_text];
            }
        }
        return orderCell;
    }
    else
    {
        NSString *identifier = @"Mine_Cell";
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        return cell;
    }
}

//选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            VFOrderListViewController *myOrder = [VFOrderListViewController new];
            [self.navigationController pushViewController:myOrder animated:YES];
        }
        else
        {
            VFLastOrderModel *obj = [[VFLastOrderModel alloc]initWithDic:_userInfoModel.order[0]];
            VFNewOrderDetailViewController *vc = [[VFNewOrderDetailViewController alloc]init];
            vc.orderID = obj.order_id;
            vc.isBack = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (void)checkPartner{
    kWeakself;
    if (_userInfoModel) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
        GlobalConfigModel *model = [[GlobalConfigModel alloc]initWithDic:dic];
        bUrlList *url = [[bUrlList alloc]initWithDic:model.burl];
        
        if ([_userInfoModel.partner intValue] == 1) {
            WebViewVC *vc = [[WebViewVC alloc]init];
            vc.urlStr = [NSString stringWithFormat:@"%@",url.main];
            vc.isForB = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if ([_userInfoModel.partner intValue] == 2){
            PartnerViewController *vc = [[PartnerViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            WebViewVC *vc = [[WebViewVC alloc]init];
            vc.urlStr = url.wait;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&indexPath.row == 1) {
        return 90;
    }else {
        return 64;
    }
    return 0.1;
}


- (UIView *)headerView {

    if (!_headerView)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSpaceH(255))];
        _headerView.backgroundColor = [UIColor blackColor];
        
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSpaceH(155))];
        self.topView.backgroundColor = [UIColor blueColor];
        [_headerView addSubview:self.topView];
        
        [self logInView];
        [self logOutView];
        
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        if (token)
        {
            self.backLogInView.hidden = NO;
            self.backLogOutView.hidden = YES;
        }
        else
        {
            self.backLogInView.hidden = YES;
            self.backLogOutView.hidden = NO;
        }
    
        
        //----------------------------------------------
        
        UIView *backBottomView = [[UIView alloc]init];
        backBottomView.frame = CGRectMake(0, kSpaceH(155), kScreenW, kSpaceH(100));
        backBottomView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:backBottomView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backBottomView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(16,16)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = backBottomView.bounds;
        maskLayer.path = maskPath.CGPath;
        backBottomView.layer.mask = maskLayer;

    
        NSArray *imageArr = @[[UIImage imageNamed:@"user_icon_wallet"],[UIImage imageNamed:@"user_icon_integral"],[UIImage imageNamed:@"user_icon_man"]];
        NSArray *titleArr = @[@"钱包",
                              @"积分",
                              @"合伙人"];
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = imageArr[i];
            [backBottomView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backBottomView.mas_top).offset(kSpaceH(25));
                make.left.mas_equalTo((kScreenW-kSpaceH(84))/6.0+i*(kSpaceH(28)+(kScreenW-kSpaceH(84))/3.0));
                make.width.height.mas_equalTo(kSpaceH(28));
            }];
            
            UILabel *title = [[UILabel alloc]init];
            title.text =titleArr[i];
            title.centerX = imageView.centerX;
            title.font = [UIFont fontWithName:kBlodFont size:kTextBigSize];
            title.textAlignment = NSTextAlignmentCenter;
            [backBottomView addSubview:title];
            
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kScreenW/3*i);
                make.top.equalTo(imageView.mas_bottom).offset(kSpaceH(10));
                make.width.mas_equalTo(kScreenW/3);
                make.height.mas_equalTo(kSpaceH(20));
            }];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.3]];
            button.tag= i;
            [button addTarget:self action:@selector(headerbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backBottomView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kScreenW/3*i);
                make.top.equalTo(imageView);
                make.bottom.equalTo(title);
                make.width.mas_equalTo(kScreenW/3);
            }];
        }

        UIView *lineView=  [[UIView alloc]init];
        lineView.backgroundColor = klineColor;
        [_headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }

    return _headerView;
}

- (void)logInView {
    
    self.backLogInView = [[UIImageView alloc]init];
    self.backLogInView.frame = self.topView.frame;
    self.backLogInView.image = [UIImage imageNamed:@"user_image_top"];
    self.backLogInView.userInteractionEnabled  =  YES;
    [self.topView addSubview:self.backLogInView];
    
    _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerBtn.layer.cornerRadius = kSpaceW(68)/2;
    _headerBtn.layer.masksToBounds = YES;
    [_headerBtn setBackgroundImage:[UIImage imageNamed:@"place_holer_750x500"] forState:UIControlStateNormal];
    [_headerBtn addTarget:self action:@selector(changeNickName) forControlEvents:UIControlEventTouchUpInside];
    [self.backLogInView addSubview:_headerBtn];
    
    _headerBtn.sd_layout
    .leftSpaceToView(self.backLogInView, 20)
    .bottomSpaceToView(self.backLogInView, 20)
    .widthIs(kSpaceW(68))
    .heightEqualToWidth();
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:kNewTitle];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor whiteColor];
    [self.backLogInView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .leftSpaceToView(self.backLogInView, 110)
    .bottomSpaceToView(self.backLogInView, kSpaceW(50))
    .heightIs(24)
    .widthIs(200);
    
    _localLabel = [[UILabel alloc]init];
    _localLabel.font = [UIFont systemFontOfSize:12];
    _localLabel.textAlignment = NSTextAlignmentLeft;
    _localLabel.textColor = HexColor(0x999999);
    [self.backLogInView addSubview:_localLabel];
    _localLabel.sd_layout
    .leftSpaceToView(self.backLogInView, 110)
    .bottomSpaceToView(self.backLogInView, kSpaceW(20))
    .heightIs(24)
    .widthIs(200);
    
    UIButton *carUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [carUserButton setTitle:@"用车人 >" forState:(UIControlStateNormal)];
    [carUserButton setBackgroundColor:[UIColor clearColor]];
    [carUserButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    carUserButton.titleLabel.font = [UIFont systemFontOfSize:12];
    carUserButton.layer.cornerRadius = 15;
    carUserButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [carUserButton addTarget:self action:@selector(carUserList:) forControlEvents:UIControlEventTouchUpInside];
    [self.backLogInView addSubview:carUserButton];
    carUserButton.sd_layout
    .rightSpaceToView(self.backLogInView, 20)
    .bottomSpaceToView(self.backLogInView, 40)
    .widthIs(60)
    .heightIs(30);
    

    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setTitle:@"设置" forState:(UIControlStateNormal)];
    [settingButton setBackgroundColor:[UIColor clearColor]];
    [settingButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    settingButton.titleLabel.font = [UIFont systemFontOfSize:14];
    settingButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [settingButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    [self.backLogInView addSubview:settingButton];
    settingButton.sd_layout
    .rightSpaceToView(self.backLogInView, 20)
    .topSpaceToView(self.backLogInView, 40)
    .widthIs(40)
    .heightIs(20);
    
    

}

- (void)logOutView {
    
    self.backLogOutView = [[UIImageView alloc]init];
    self.backLogOutView.frame = self.topView.frame;
    self.backLogOutView.image = [UIImage imageNamed:@"user_image_top"];
    self.backLogOutView.userInteractionEnabled  =  YES;
    [self.topView addSubview:self.backLogOutView];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.backLogOutView addGestureRecognizer:singleTap];
    
    UIImageView *headDefaultImageV = [[UIImageView alloc]init];
    headDefaultImageV.layer.cornerRadius = kSpaceW(68)/2;
    headDefaultImageV.layer.masksToBounds = YES;
    headDefaultImageV.image = [UIImage imageNamed:@"user_icon_head_none"];
    [self.backLogOutView addSubview:headDefaultImageV];
    headDefaultImageV.sd_layout
    .leftSpaceToView(self.backLogOutView, 20)
    .bottomSpaceToView(self.backLogOutView, 20)
    .widthIs(kSpaceW(68))
    .heightEqualToWidth();
    
    UILabel *loginLabel = [[UILabel alloc]init];
    loginLabel.font = [UIFont systemFontOfSize:kNewBigTitle];
    loginLabel.textAlignment = NSTextAlignmentLeft;
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.text = @"登录/注册";
    [self.backLogOutView addSubview:loginLabel];
    loginLabel.sd_layout
    .leftSpaceToView(self.backLogOutView, 120)
    .bottomSpaceToView(self.backLogOutView, kSpaceW(50))
    .heightIs(24)
    .widthIs(200);
    
    UILabel *loginMessageLabel = [[UILabel alloc]init];
    loginMessageLabel.font = [UIFont systemFontOfSize:kTextSize];
    loginMessageLabel.textAlignment = NSTextAlignmentLeft;
    loginMessageLabel.textColor = HexColor(0x999999);
    loginMessageLabel.text = @"注册登录开始用车";
    [self.backLogOutView addSubview:loginMessageLabel];
    loginMessageLabel.sd_layout
    .leftSpaceToView(self.backLogOutView, 120)
    .bottomSpaceToView(self.backLogOutView, kSpaceW(20))
    .heightIs(24)
    .widthIs(200);
    
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    VFLoginViewController *loginVC = [[VFLoginViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)jumpMessage {
    MessageNoticeViewController *vc = [[MessageNoticeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)carUserList:(UIButton *)sender {
    VFCartUserListViewController *vc = [[VFCartUserListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)footerView {
    if (!_footView)
    {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/2)];

        UIButton *button1 = [self setButtonFrame:CGRectMake(0, 0, kScreenW, 50) ImageView:[UIImage imageNamed:@"user_icon_coupon"] title:@"我的优惠券"];
        [button1 addTarget:self action:@selector(button1:) forControlEvents:(UIControlEventTouchUpInside)];
        [_footView addSubview:button1];
        
        UIButton *button2 = [self setButtonFrame:CGRectMake(0, 50, kScreenW, 50) ImageView:[UIImage imageNamed:@"user_icon_address"] title:@"常用地址"];
        [button2 addTarget:self action:@selector(button2:) forControlEvents:(UIControlEventTouchUpInside)];
        [_footView addSubview:button2];
        
        UIButton *button3 = [self setButtonFrame:CGRectMake(0, 100, kScreenW, 50) ImageView:[UIImage imageNamed:@"user_icon_collect"] title:@"我的收藏"];
        [button3 addTarget:self action:@selector(button3:) forControlEvents:(UIControlEventTouchUpInside)];
        [_footView addSubview:button3];
        
        UIButton *button4 = [self setButtonFrame:CGRectMake(0, 150, kScreenW, 50) ImageView:[UIImage imageNamed:@"user_icon_question"] title:@"常见问题"];
        [button4 addTarget:self action:@selector(button4:) forControlEvents:(UIControlEventTouchUpInside)];
        [_footView addSubview:button4];
        
    }
    return _footView;
}

- (void)button1:(UIButton *)button {
    VFMyCouponViewController *vc = [[VFMyCouponViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)button2:(UIButton *)button {
    VFAddressController *vc = [[VFAddressController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)button3:(UIButton *)button {
    VFCollectorViewController *vc = [[VFCollectorViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)button4:(UIButton *)button {
    VFCommonProblemController *vc = [[VFCommonProblemController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (UIButton *)setButtonFrame:(CGRect)frame ImageView:(UIImage *)image title:(NSString *)title {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 28, 28)];
    imageView.image = image;
    [button addSubview:imageView];

    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(60, 10, 150, 30);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = HexColor(0x212121);
    label.text = title;
    [button addSubview:label];

    UIImageView *pushImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_icon_go_hui"]];
    pushImageView.frame = CGRectMake(kScreenW - 36, 17, 16, 16);
    [button addSubview:pushImageView];
    
    
    return button;
}



- (void)headerbtnClick:(UIButton *)sender{
    
    if (sender.tag == 0)
    {
        VFMyWalletViewController *VC = [[VFMyWalletViewController alloc]init];
        VC.balance = self.userInfoModel.money;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (sender.tag == 2)
    {
        [self checkPartner];
    }
    else if (sender.tag == 1)
    {
        VFIntegralViewController *vc = [[VFIntegralViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)checkVip{
    kWeakself;
    [JSFProgressHUD showHUDToView:self.view];
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (tokenStr) {
        [HttpManage getUserInfoWithToken:tokenStr withSuccessBlock:^(NSDictionary *dic) {
            [JSFProgressHUD hiddenHUD:self.view];
                        
            LoginModel *model = [[LoginModel alloc]initWithDic:dic];
            if ([model.vipLevel isEqualToString:@"0"])
            {
                VIPViewController *vc = [[VIPViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                ShowVipViewController *vc =[[ShowVipViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        } withFailedBlock:^{
            [JSFProgressHUD hiddenHUD:self.view];
            [ProgressHUD showError:@"加载失败"];
        }];
    }
}

- (void)changeNickName {

    VFMyInfoViewController *vc = [[VFMyInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
