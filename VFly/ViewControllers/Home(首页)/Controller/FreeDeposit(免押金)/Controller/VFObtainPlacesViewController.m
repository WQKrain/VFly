//
//  VFObtainPlacesViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/30.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFObtainPlacesViewController.h"
#import "VFFreeDepositGarageViewController.h"
#import "VFObtainPlacesTableViewCell.h"
#import "VFCustomerQualificationModel.h"
#import "WebViewVC.h"
#import "VFRealNameAuthenticationModel.h"
#import "VFIdentityAuthenticationViewController.h"
#import "VFAvailableModel.h"
#import "VFfreedepositTopsModel.h"
#import "WebViewVC.h"
#import "LoginViewController.h"
#import "YCAlertView.h"

@interface VFObtainPlacesViewController ()<UITableViewDelegate,UITableViewDataSource,VFIdentityAuthenticationViewDelegate>{
    CGFloat _titleHeight;
    dispatch_group_t _groupEnter;
}
@property (nonatomic , strong)UIButton *selectButton;
@property (nonatomic , strong)UIView *markView;
@property (nonatomic , strong)UIView *centerView;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)UIScrollView *bigScrollView;
@property (nonatomic ,strong)UILabel *promptLbel;
@property (nonatomic ,strong)NSString *content;
@property (nonatomic ,strong)UILabel *contentLabel;

@property (nonatomic ,strong)UIImageView *shadowImageView;

@property (nonatomic ,strong)UIButton *bottomButton;

@property (nonatomic ,strong)UILabel *instructionsLabel;
@property (nonatomic ,strong)UIButton *agreenButton;
@property (nonatomic ,strong)UIButton *agreenUrlBtn;
@property (nonatomic ,strong)VFCustomerQualificationModel *customerQualificationModel;
@property (nonatomic ,strong)VFCustomerQualificationDetailModel *DetailModel;


@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong)UILabel *showNumLabel;

@property (nonatomic ,strong)NSMutableArray *topsDataArr;
@property (nonatomic ,strong)VFAvailableModel *availableModel;

@property (nonatomic ,strong)UIView *changeHeaderView;
@property (nonatomic ,strong)UIView *headerView;
@property (nonatomic ,strong)UIView *animationView;
@end

@implementation VFObtainPlacesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWeakSelf;
    //获取免押金排行榜
    [HttpManage getFreedepositTopsSuccessBlock:^(NSDictionary *data) {
        HCBaseMode *baseModel = [[HCBaseMode alloc]initWithDic:data];
        if ([baseModel.code isEqualToString:@"0"]) {
            VFfreedepositTopsModel *model = [[VFfreedepositTopsModel alloc]initWithDic:baseModel.data];
            for (NSDictionary *dic in model.tops) {
                VFfreedepositTopsListModel *obj = [[VFfreedepositTopsListModel alloc]initWithDic:dic];
                [_topsDataArr addObject:obj];
            }
            [_tableView reloadData];
        }else{
            
        }
    } withFailureBlock:^(NSError *error) {
    }];
    [JSFProgressHUD showHUDToView:self.view];
    dispatch_queue_t queueEnter = dispatch_get_global_queue(0, 0);
    dispatch_async(queueEnter, ^{
        _groupEnter = dispatch_group_create();
        dispatch_group_async(_groupEnter, queueEnter, ^{
            [weakSelf loadRealNameState];
        });
        dispatch_group_async(_groupEnter, queueEnter, ^{
            [weakSelf loadData];
        });
        dispatch_group_async(_groupEnter, queueEnter, ^{
            [weakSelf loadCreditState];
        });
        dispatch_group_notify(_groupEnter, queueEnter, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [JSFProgressHUD hiddenHUD:weakSelf.view];
                [weakSelf addData];
            });
            
        });
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)startAnimationtMethod{
    //UIView动画
    [UIView beginAnimations:nil context:nil];//第一个参数：动画的标识符 字符串类型 可以理解为动画的名字  第二个参数：用来传值
    //对动画效果的一些设定
    [UIView setAnimationDuration:0.3];//设置动画的时长
    [UIView setAnimationRepeatAutoreverses:NO];//是否执行反动画效果（从哪来 回哪去）
    //设置最终状态
    _animationView.frame = CGRectMake(0, kScreenH-kSafeBottomH-50-50, kScreenW, 50);
    //透明度设定
    _animationView.alpha=1;
    //提交动画
    [UIView commitAnimations];
}

- (void)addData{
    if ([_customerQualificationModel.qualification_status isEqualToString:@"0"]) {
        //未认证界面展示
        if ([_availableModel.available intValue]<=0) {
            [_bottomButton setTitle:@"平台本月免押次数已用完，下个月再来哟" forState:UIControlStateNormal];
            [self cerateBeforView];
            _promptLbel.hidden = NO;
            _instructionsLabel.hidden = YES;
            _agreenButton.hidden = YES;
            _agreenUrlBtn.hidden = YES;
        }else{
            [_bottomButton setTitle:@"立即申请免押额度" forState:UIControlStateNormal];
            [self cerateBeforView];
            _promptLbel.hidden = NO;
            _instructionsLabel.hidden = YES;
            _agreenButton.hidden = YES;
            _agreenUrlBtn.hidden = YES;
        }
    }else if ([_customerQualificationModel.qualification_status isEqualToString:@"1"]){
        //审核中界面展示
        [self cerateBeforView];
        [_bottomButton setTitle:@"您的免押申请正在审核中…" forState:UIControlStateNormal];
        _bottomButton.alpha = 0.4;
        _promptLbel.hidden = NO;
        _instructionsLabel.hidden = YES;
        _agreenButton.hidden = YES;
        _agreenUrlBtn.hidden = YES;
    }else if([_customerQualificationModel.qualification_status isEqualToString:@"2"]){
        [_bottomButton setTitle:kFormat(@"您的免押金授信为%@万.立即抢名额", [CustomTool removeFloatAllZero:_DetailModel.available]) forState:UIControlStateNormal];
        [self createAfterView];
        _bottomButton.alpha = 1;
        _promptLbel.hidden = YES;
        _instructionsLabel.hidden = NO;
        _agreenButton.hidden = NO;
        _agreenUrlBtn.hidden = NO;
    }else if([_customerQualificationModel.qualification_status isEqualToString:@"3"]){
        [_bottomButton setTitle:@"立即申请免押额度" forState:UIControlStateNormal];
        [self cerateBeforView];
        _promptLbel.hidden = NO;
        _instructionsLabel.hidden = YES;
        _agreenButton.hidden = YES;
        _agreenUrlBtn.hidden = YES;
        //创建做动画view
        _animationView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-kSafeBottomH-50, kScreenW, 50)];
        _animationView.alpha = 0;
        _animationView.backgroundColor = RGBA(34, 34, 34, 0.8);
        [self.view addSubview:_animationView];
        [_animationView sendSubviewToBack:_bottomButton];
        
        UILabel *showLabel = [UILabel initWithTitle:@"您的免押额度已过7天有效期，需重新申请" withFont:kTextBigSize textColor:kWhiteColor];
        [_animationView addSubview:showLabel];
        [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.bottom.mas_equalTo(0);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"知道了" forState:UIControlStateNormal];
        [button setTitleColor:kButtonTextBlueColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(animationViewButtonClcik) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:kTextBigSize]];
        [_animationView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showLabel.mas_right).offset(29);
            make.top.bottom.mas_equalTo(0);
        }];
        [self.view insertSubview:_animationView belowSubview:_bottomButton];
        
//        [self performSelector:@selector(startAnimationtMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.3];
        [self startAnimationtMethod];
        [self performSelector:@selector(timerMethod) withObject:nil/*可传任意类型参数*/ afterDelay:5.0];
    }else{
        
    }
    
    if (![_customerQualificationModel.qualification_status isEqualToString:@"2"]) {
        [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kScreenW/75.0*30+130);
        }];
        
        [_shadowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kScreenW/75.0*30+125);
        }];
    }else{
        [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kScreenW/75.0*66+14);
        }];
        
        [_shadowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kScreenW/75.0*66+9);
        }];
    }
    
    _topLabel.text = kFormat(@"平 台 本 月 可 免 押 金 %@ 次", _availableModel.quantity);
    _showNumLabel.text = kFormat(@"剩余%@次", _availableModel.available);
}

- (void)timerMethod{
    [self animationViewButtonClcik];
}


- (void)animationViewButtonClcik{
    //UIView动画
    [UIView beginAnimations:nil context:nil];//第一个参数：动画的标识符 字符串类型 可以理解为动画的名字  第二个参数：用来传值
    //对动画效果的一些设定
    [UIView setAnimationDuration:1.5];//设置动画的时长
    [UIView setAnimationRepeatAutoreverses:NO];//是否执行反动画效果（从哪来 回哪去）
    //设置最终状态
    _animationView.frame = CGRectMake(0, kScreenH-kSafeBottomH-50, kScreenW, 50);
    //透明度设定
    _animationView.alpha=0;
    //提交动画
    [UIView commitAnimations];
}

//获取用户授信情况
- (void)loadCreditState{
    dispatch_group_enter(_groupEnter);
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
        [HttpManage getCustomerQualificationSuccessBlock:^(NSDictionary *data) {
            HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
            if ([model.code isEqualToString:@"0"]) {
                _customerQualificationModel = [[VFCustomerQualificationModel alloc]initWithDic:model.data];
                 _DetailModel = [[VFCustomerQualificationDetailModel alloc]initWithDic:_customerQualificationModel.qualification];
            }else{
                [CustomTool alertViewShow:model.info];
            }
            dispatch_group_leave(_groupEnter);
        } withFailureBlock:^(NSError *error) {
            dispatch_group_leave(_groupEnter);
        }];
    }else{
        _promptLbel.hidden = NO;
        [_bottomButton setTitle:@"立即申请免押额度" forState:UIControlStateNormal];
    }
}

- (void)loadRealNameState{
    
    dispatch_group_enter(_groupEnter);
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpManage realNameAuthenticationStateWithToken:token withSuccessBlock:^(NSDictionary *data) {
        VFRealNameAuthenticationModel *model = [[VFRealNameAuthenticationModel alloc]initWithDic:data];
        [[NSUserDefaults standardUserDefaults]setObject:model.cardStatus forKey:RealNameState];
        [[NSUserDefaults standardUserDefaults]setObject:model.drivingLicenceStatus forKey:DriverLicenseState];
        
        dispatch_group_leave(_groupEnter);
        
    } withFailureBlock:^(NSError *error) {
        
        dispatch_group_leave(_groupEnter);
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topsDataArr = [[NSMutableArray alloc]init];
    _content = @"1.每次审核后，额度有效期为7天。为让客户享受更优质的服务，将按月发放一定数量的免押金名额，名额抢完即止。\n2.新名额发放的时间在第二个月的1号早上0点，如，2018-03-01 00:00 发放出3月份的名额。\n3.使用免押金功能，您还需要支付一笔服务费。\n4.第一次使用免押金方式租车的用户，需提供相关信用资料，以便我们审批能减免押金的额度。\n5.选车下单后，请及时支付订金，只有支付订金，系统才会为您保留免押金的名额。\n6.若有疑问，您可以联系APP在线客服，或客服热线400-117-8880。\n7.为保障客户权益，提升客户用车体验，威风出行保留对免押金租车业务的最终解释权。";
    _titleHeight = [CustomTool getSpaceLabelHeightwithContentString:_content];


    _bigScrollView = [[UIScrollView alloc]init];
    [self.bigScrollView setContentSize:CGSizeMake(0, 229+kScreenW)];
    AdjustsScrollViewInsetNever(self, self.bigScrollView);
    [self.view addSubview:_bigScrollView];
    [_bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-50-kSafeBottomH);
        make.width.mas_equalTo(kScreenW);
        make.top.mas_equalTo(kNavBarH);
    }];
    [self createView];
    [self createCenterView];
    [self creatTableView];
    [self createDetailScrollView];
}

- (void)loadData{
    dispatch_group_enter(_groupEnter);
    //获取免押金剩余名额
    [HttpManage getFreedepositAvailableSuccessBlock:^(NSDictionary *data) {
        HCBaseMode *baseModel = [[HCBaseMode alloc]initWithDic:data];
        if ([baseModel.code isEqualToString:@"0"]) {
            _availableModel = [[VFAvailableModel alloc]initWithDic:baseModel.data];
        }
        dispatch_group_leave(_groupEnter);
    } withFailureBlock:^(NSError *error) {
        dispatch_group_leave(_groupEnter);
    }];
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)createDetailScrollView{
    _scrollView = [[UIScrollView alloc]init];
    [_centerView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(44);
        make.height.mas_equalTo(118);
    }];
    
    _scrollView.contentSize=CGSizeMake(0, _titleHeight);
    _contentLabel = [UILabel initWithTitle:_content withFont:kTextSize textColor:kdetailColor];
    
    [UILabel changeLineSpaceForLabel:_contentLabel WithSpace:8];
    _contentLabel.numberOfLines = 0;
    [_scrollView addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.equalTo(_scrollView);
    }];
    
    _scrollView.hidden = YES;
}


- (void)createCenterView{
    _shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QiangMingE_background"]];
    [_bigScrollView addSubview:_shadowImageView];
    [_shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(kScreenW-20);
        make.top.mas_equalTo(kScreenW/75*66+9);
        make.height.mas_equalTo(200);
    }];
    
    _centerView = [[UIView alloc]init];
    [_bigScrollView addSubview:_centerView];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW-30);
        make.top.mas_equalTo(kScreenW/75*66+14);
        make.height.mas_equalTo(190);
    }];
    
    NSArray *titleArr = @[@"消费排行榜",@"免押金玩法"];
    for (int i=0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:kMainColor forState:UIControlStateSelected];
        [button setTitleColor:kTitleBoldColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextSize]];
        [button addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        if (i==0) {
            button.selected = YES;
            _selectButton = button;
        }else{
           button.selected = NO;
        }
        [_centerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.width.mas_equalTo((kScreenW-30)/2);
            make.left.mas_equalTo((kScreenW-30)/2*i);
            make.height.mas_equalTo(44);
        }];
    }
    
    _markView = [[UIView alloc]init];
    _markView.backgroundColor = kMainColor;
    [_centerView addSubview:_markView];
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(((kScreenW-30)/2-61)/2);
        make.top.mas_equalTo(36);
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"QiangMingE_icon_more"] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:self action:@selector(transformButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(27);
    }];
    
    _promptLbel = [UILabel initWithTitle:@"最高20万额度，极速审批，资料越全，信用越高" withFont:kTextBigSize textColor:kdetailColor];
    [_promptLbel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
    _promptLbel.hidden = YES;
    [_bigScrollView addSubview:_promptLbel];
    [_promptLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bigScrollView);
        make.top.equalTo(_centerView.mas_bottom).offset(29);
        make.height.mas_equalTo(20);
    }];

    _instructionsLabel = [UILabel initWithTitle:@"成功支付订金才能为您预留免押金名额" withFont:kTextSize textColor:kdetailColor];
    _instructionsLabel.hidden = YES;
    [_bigScrollView addSubview:_instructionsLabel];
    [_instructionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bigScrollView);
        make.top.equalTo(_centerView.mas_bottom).offset(22);
        make.height.mas_equalTo(17);
    }];
    
    _agreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreenButton setImage:[UIImage imageNamed:@"icon_checkbox_on"] forState:UIControlStateSelected];
    [_agreenButton setImage:[UIImage imageNamed:@"icon_checkbox_off"] forState:UIControlStateNormal];
    _agreenButton.hidden = YES;
    [_bigScrollView addSubview:_agreenButton];
    [_agreenButton addTarget:self action:@selector(agreenmrntButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _agreenButton.selected = YES;
    [_agreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((kScreenW-166)/2);
        make.top.equalTo(_instructionsLabel.mas_bottom).offset(5);
        make.width.height.mas_equalTo(22);
    }];
    
    _agreenUrlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreenUrlBtn setTitleColor:kTextBlueColor forState:UIControlStateNormal];
    _agreenUrlBtn.titleLabel.font = [UIFont systemFontOfSize:kTextSize];
    [_agreenUrlBtn setTitle:@"同意《免押金服务协议》" forState:UIControlStateNormal];
    [_agreenUrlBtn addTarget:self action:@selector(jumpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bigScrollView addSubview:_agreenUrlBtn];
    _agreenUrlBtn.hidden = YES;
    [_agreenUrlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreenButton.mas_right).offset(10);
        make.top.equalTo(_instructionsLabel.mas_bottom);
        make.height.mas_equalTo(34);
    }];
    
}

- (void)jumpButtonClick{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    GlobalConfigModel *obj = [[GlobalConfigModel alloc]initWithDic:dic];
    WebViewVC *vc = [[WebViewVC alloc]init];
    vc.urlStr = obj.freeDepositUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)agreenmrntButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}


- (void)transformButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.transform=CGAffineTransformMakeRotation(M_PI);
        [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_titleHeight+78);
        }];
        [self.bigScrollView setContentSize:CGSizeMake(0, 229+kScreenW+_titleHeight-108)];
        [_shadowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_titleHeight+78+20);
        }];
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_titleHeight);
        }];
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_titleHeight);
        }];
    }else{
        sender.transform=CGAffineTransformMakeRotation(0);
        [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(190);
        }];
        [self.bigScrollView setContentSize:CGSizeMake(0, 229+kScreenW)];
        [_shadowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
        }];
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(118);
        }];
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(118);
        }];
    }
}

- (void)creatTableView{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_centerView addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[VFObtainPlacesTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(44);
        make.height.mas_equalTo(118);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _topsDataArr.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 27;
    }else{
        return 32;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFObtainPlacesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[VFObtainPlacesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    if (indexPath.row == 0) {
        cell.indexRow = @"0";
        cell.indexlabel.text =@"排名";
        cell.namelabel.text = @"姓名";
        cell.moneylabel.text = @"总计消费";
    }else{
        VFfreedepositTopsListModel *obj = _topsDataArr[indexPath.row-1];
        cell.indexRow = @"1";
        cell.indexlabel.text = obj.sort;
        cell.namelabel.text = obj.name;
        cell.moneylabel.text = obj.total_deductions;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)chooseButtonClick:(UIButton *)sender{
    _selectButton.selected = NO;
    sender.selected = YES;
    _selectButton = sender;
    [_markView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(((kScreenW-30)/2-61)/2+(kScreenW-30)/2*sender.tag);
    }];
    
    if (sender.tag == 1) {
        _tableView.hidden = YES;
        _scrollView.hidden = NO;
    }else{
        _tableView.hidden = NO;
        _scrollView.hidden = YES;
    }
    
}

- (void)createView{
    _bottomButton = [UIButton newButtonWithTitle:@"" sel:@selector(buttonClcik) target:self cornerRadius:NO];
    [self.view addSubview:_bottomButton];
    [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kSafeBottomH);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark-----已获取授信额度的view
- (void)createAfterView{
    //清除自定义导航
    [self replaceDefaultNavBar:[[UIView alloc]init]];
    //创建view
    [_bigScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
    if (!_changeHeaderView) {
        _changeHeaderView = [[UIView alloc]init];
        [_bigScrollView addSubview:_changeHeaderView];
        [_changeHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kScreenW/75*66);
        }];
        
        UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_ShouXin"]];
        [_changeHeaderView addSubview:headerImage];
        [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenW);
            make.height.mas_equalTo(kScreenW/75*66);
        }];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClcik) forControlEvents:UIControlEventTouchUpInside];
        [_bigScrollView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatutesBarH);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(52);
            make.height.mas_equalTo(48);
        }];
        
        UIImageView *leftImage = [[UIImageView alloc]init];
        [leftImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:kHeadImage]]];
        leftImage.layer.masksToBounds = YES;
        leftImage.layer.cornerRadius = 17;
        leftImage.layer.borderColor = kMainColor.CGColor;
        leftImage.layer.borderWidth = 1;
        [_changeHeaderView addSubview:leftImage];
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(82);
            make.width.height.mas_equalTo(34);
        }];
        
        UILabel *namelabel = [UILabel initWithTitle:kFormat(@"Hi，%@", _DetailModel.name) withFont:kTextBigSize textColor:kWhiteColor];
        [_changeHeaderView addSubview:namelabel];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImage.mas_right).offset(15);
            make.top.mas_equalTo(79);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *stateLabel = [UILabel initWithTitle:@"恭喜您，成功获得免押授信" withFont:kTextBigSize textColor:kWhiteColor];
        [_changeHeaderView addSubview:stateLabel];
        [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(namelabel);
            make.top.equalTo(namelabel.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *showMoneyText = [UILabel initWithTitle:@"当前可用额度" withFont:kTextBigSize textColor:kWhiteColor];
        [showMoneyText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
        [_changeHeaderView addSubview:showMoneyText];
        [showMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImage);
            make.top.equalTo(leftImage.mas_bottom).offset(33);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *showMoneyLabel = [UILabel initWithTitle:kFormat(@"¥%@", _DetailModel.available) withFont:kTextSize textColor:kWhiteColor];
        [_changeHeaderView addSubview:showMoneyLabel];
        [showMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showMoneyText);
            make.top.equalTo(showMoneyText.mas_bottom);
            make.height.mas_equalTo(50);
        }];
        NSRange range = [showMoneyLabel.text rangeOfString:_DetailModel.available];
        [CustomTool setTextColor:showMoneyLabel FontNumber:[UIFont fontWithName:@"Helvetica-Bold" size:36] AndRange:range AndColor:kWhiteColor];
        
        NSString *str;
        if ([_DetailModel.freezing intValue]>0) {
            str = kFormat(@"总额度¥%@ 已使用¥%@●还车后恢复",_DetailModel.credit_line,_DetailModel.freezing);
        }else{
            str = kFormat(@"已使用¥%@", _DetailModel.freezing);
        }
        UILabel *usedMoneyLabel = [UILabel initWithTitle:str withFont:kTextBigSize textColor:kWhiteColor];
        [_changeHeaderView addSubview:usedMoneyLabel];
        [usedMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showMoneyLabel);
            make.top.equalTo(showMoneyLabel.mas_bottom);
            make.height.mas_equalTo(17);
        }];
        
        NSString *endTimeInterval = [CustomTool toDateChangTimeStr:_DetailModel.expired_at formatter:@"yyyy-MM-dd HH:mm:ss"];
        NSString *endTime = [CustomTool changTimeStr:endTimeInterval formatter:@"yyyy/MM/dd"];
        
        //计算时间戳差值
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSDate *endDate = [dateFormatter dateFromString:endTime];
        NSDate *startDate = [NSDate date];
        NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
        int days = ((int)time)/(3600*24);
    
        UILabel *effectiveDateLabel = [UILabel initWithTitle:kFormat(@"有效期至%@，剩余%d天", endTime,days) withFont:kTextBigSize textColor:kWhiteColor];
        [_changeHeaderView addSubview:effectiveDateLabel];
        [effectiveDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(usedMoneyLabel);
            make.top.equalTo(usedMoneyLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(17);
        }];
    }
}

- (void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-----未获取授信额度的view
- (void)cerateBeforView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/75*30+125)];
        [_bigScrollView addSubview:_headerView];
//        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(0);
//            make.top.mas_equalTo(0);
//            make.height.mas_equalTo(kScreenW/75*30+125);
//        }];
        UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QiangMingE_banner"]];
        [_headerView addSubview:headerImage];
        [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenW);
            make.height.mas_equalTo(kScreenW/75*30);
        }];
        
        _topLabel = [UILabel initWithTitle:@"" withFont:kTextSize textColor:kTitleBoldColor];
        [_topLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextSize]];
        [_headerView addSubview:_topLabel];
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerImage.mas_bottom).offset(36);
            make.height.mas_equalTo(17);
            make.centerX.equalTo(_bigScrollView);
        }];
        
        UIView *topLine = [[UIView alloc]init];
        topLine.backgroundColor = kTitleBoldColor;
        [_headerView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topLabel);
            make.height.mas_equalTo(1);
            make.top.equalTo(_topLabel.mas_bottom).offset(10);
        }];
        
        UIView *centerView = [[UIView alloc]init];
        [_headerView addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(topLine);
            make.height.mas_equalTo(28);
            make.top.equalTo(topLine.mas_bottom);
        }];
        
        _showNumLabel = [UILabel initWithFont:20 textColor:kTitleBoldColor];
        [centerView addSubview:_showNumLabel];
        [_showNumLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        _showNumLabel.textAlignment = NSTextAlignmentCenter;
        [_showNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QiangMingE_image1"]];
        leftImage.contentMode = UIViewContentModeScaleAspectFit;
        [centerView addSubview:leftImage];
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(10);
        }];
        
        UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QiangMingE_image1"]];
        rightImage.contentMode = UIViewContentModeScaleAspectFit;
        [centerView addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(10);
        }];
        
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = kTitleBoldColor;
        [_headerView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topLabel);
            make.height.mas_equalTo(1);
            make.top.equalTo(centerView.mas_bottom);
        }];
    }
}

#pragma mark------------------信息认证界面的代理方法----------------
- (void)identityAuthenticationVCcomplete{
    //跳转到填写表单界面
    WebViewVC *vc = [[WebViewVC alloc]init];
    vc.urlStr = @"https://wechat.weifengchuxing.com/forApp/noDeposit/noDeposit.html?token=";
    vc.needToken = YES;
    vc.noNav = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)buttonClcik{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    kWeakSelf;
    if (token) {
        if (_agreenButton.selected) {
            if (_customerQualificationModel) {
                NSString *realName = [[NSUserDefaults standardUserDefaults]objectForKey:RealNameState];
                NSString *driverLicense = [[NSUserDefaults standardUserDefaults]objectForKey:DriverLicenseState];

                if ([realName isEqualToString:@"1"] && [driverLicense isEqualToString:@"1"]) {
                    if ([_customerQualificationModel.qualification_status isEqualToString:@"0"]) {
                        WebViewVC *vc = [[WebViewVC alloc]init];
                        vc.urlStr = @"https://wechat.weifengchuxing.com/forApp/noDeposit/noDeposit.html?token=";
                        vc.needToken = YES;
                        vc.noNav = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else if ([_customerQualificationModel.qualification_status isEqualToString:@"1"]){

                    }else if ([_customerQualificationModel.qualification_status isEqualToString:@"2"]){
                        VFFreeDepositGarageViewController *vc = [[VFFreeDepositGarageViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else{
                        YCAlertView *alertview = [[YCAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 170) withTitle:@"请选择" alertMessage:@"" confrimBolck:^{
                            WebViewVC *vc = [[WebViewVC alloc]init];
                            vc.urlStr = @"https://wechat.weifengchuxing.com/forApp/noDeposit/noDeposit.html?token=";
                            vc.needToken = YES;
                            vc.noNav = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        } cancelBlock:^{
                            [HttpManage resetQualifyParameter:@{@"token":token} success:^(NSDictionary *data) {
                                HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                                if ([model.code isEqualToString:@"0"]) {
                                    //刷新UI
                                    [_bottomButton setTitle:@"您的免押申请正在审核中…" forState:UIControlStateNormal];
                                    _bottomButton.alpha = 0.4;
                                    _promptLbel.hidden = NO;
                                    _instructionsLabel.hidden = YES;
                                    _agreenButton.hidden = YES;
                                    _agreenUrlBtn.hidden = YES;
                                }else{
                                    [ProgressHUD showError:@"请求错误"];
                                }
                            } failedBlock:^(NSError *error) {

                            }];
                        }];
                        [alertview show];
                    }
                }else{
                    VFIdentityAuthenticationViewController *vc = [[VFIdentityAuthenticationViewController alloc]init];
                    vc.delegate = self;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }else{
            [CustomTool alertViewShow:@"请先同意服务协议哦"];
        }
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
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
