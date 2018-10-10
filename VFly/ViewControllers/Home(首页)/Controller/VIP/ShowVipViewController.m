//
//  ShowVipViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ShowVipViewController.h"
#import "paymentViewController.h"
#import "DepositListViewController.h"
#import "VipInfoModel.h"
#import "VIPViewController.h"
#import "WebViewVC.h"
#import "VFProbleDetailViewController.h"
#import "LoginModel.h"

@interface ShowVipViewController ()
@property (nonatomic , strong)NSArray *vipArr;
@property (nonatomic , strong)NSArray *iconArr;
@property (nonatomic , strong)UIView *centerView;

@property (nonatomic , strong)UILabel *moneyLabel;
@property (nonatomic , strong)UILabel *remainingDays;
@property (nonatomic , strong)UILabel *vipLabel;
@property (nonatomic , strong)UIImageView *rightImageView;
@property (nonatomic , strong)UIImageView *headerImage;
@property (nonatomic , strong)UIImageView *bottomView;

@property (nonatomic , strong)UILabel *namelabel;
@property (nonatomic , strong)UIView *topView;
@property (nonatomic , strong)UIImageView *VIPIcon;
@property (nonatomic , strong)UIButton *updateButton;

@property (nonatomic , strong)UIScrollView *scrollView;
@property (nonatomic , strong)VipInfoModel *vipModel;

@end

@implementation ShowVipViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"memberHome";
    _iconArr = @[[UIImage imageNamed:@"icon_level1"],[UIImage imageNamed:@"icon_level2"],[UIImage imageNamed:@"icon_level3"]];
    _vipArr = @[@"威风会员",@"铂金会员",@"黑金会员"];
    self.title = @"会员";
    [self.navRightImage setImage:[UIImage imageNamed:@"icon_question2@2x"]];
    [self loadData];
//    [self customNavBarItem];
}

- (void)defaultLeftBtnClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)defaultRightBtnClick {
    VFProbleDetailViewController *vc = [[VFProbleDetailViewController alloc]init];
    vc.name = @"会员问题";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData{
    kWeakSelf;
    [HttpManage getVipInfoSuccess:^(NSDictionary *data) {
        _vipModel = [[VipInfoModel alloc]initWithDic:data];
        [weakSelf createView];
        [_headerImage sd_setImageWithURL:[NSURL URLWithString:_vipModel.avatar] placeholderImage:nil];
        NSInteger vip = [_vipModel.vipLevel integerValue];
        _namelabel.text= [NSString stringWithFormat:@"%@",_vipModel.name];
        _VIPIcon.image = _iconArr[vip-1];
        [_namelabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [_namelabel sizeToFit];
            make.width.mas_equalTo(_namelabel.width);
        }];
        
        _vipLabel.text = [NSString stringWithFormat:@"%@ %@到期",_vipArr[vip-1],_vipModel.expireTime];
        _moneyLabel.text = [NSString stringWithFormat:@"预存款 ¥%@",[CustomTool positiveFormat:_vipModel.vipMoney]];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_vipModel.vipImage]];
        [_bottomView sd_setImageWithURL:[NSURL URLWithString:_vipModel.tqImage]];
    } failedBlock:^(NSError *error) {
        
    }];
}

- (void)createView{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH-59-44-kStatutesBarH);
    _scrollView.contentSize = CGSizeMake(0, 706);
    [self.view addSubview:_scrollView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-49-kSafeBottomH, kScreenW, 49)];
    bottomView.backgroundColor = kBarBgColor;
    [self.view addSubview:bottomView];
    
    _updateButton = [UIButton newButtonWithTitle:@"立即升级" sel:@selector(updatBtnClick:) target:self cornerRadius:NO];
    _updateButton.frame =CGRectMake(kScreenW-132, 0, 132, 49);
    [bottomView addSubview:_updateButton];
    
    
    UILabel *topLabel = [UILabel initWithTitle:@"升级为黑金会员" withFont:kTextBigSize textColor:kWhiteColor];
    topLabel.frame = CGRectMake(15, 0, kScreenW-162, 49);
    [bottomView addSubview:topLabel];

    UILabel *bottomLabel = [UILabel initWithTitle:@"享受更高权益" withFont:kTextSmallSize textColor:kWhiteColor];
    bottomLabel.frame = CGRectMake(15, topLabel.bottom+7, 100, kTextSmallSize);
    [bottomView addSubview:bottomLabel];
    bottomLabel.hidden = YES;
    
    switch ([_vipModel.vipLevel intValue]) {
        case 1:
            topLabel.text = @"升级为铂金会员、黑金会员享受更高权益";
            break;
        case 2:
            topLabel.text = @"升级为黑金会员享受更高权益";
            break;
        case 3:
            topLabel.text = @"您已是最高级别会员";
            _updateButton.hidden = YES;
            break;
        default:
            break;
    }
    //右边背景图片
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-158, 84, 158, 184)];
    [_scrollView addSubview:_rightImageView];
    
    //最上边显示个人会员信息的视图
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 60)];
    [self.view addSubview:_topView];
    
    _headerImage = [[UIImageView alloc]init];
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = 33;
    [_scrollView addSubview:_headerImage];
    
    [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView);
        make.width.height.mas_equalTo(66);
        make.centerX.equalTo(self.view);
    }];
    
    _namelabel = [UILabel initWithFont:kNewTitle textColor:kdetailColor];
    [_scrollView addSubview:_namelabel];
    [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImage.mas_bottom).offset(10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(kNewTitle);
        make.centerX.equalTo(_headerImage);
    }];

    _VIPIcon  = [[UIImageView alloc]init];
    [_scrollView addSubview:_VIPIcon];
    [_VIPIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImage.mas_bottom).offset(7);
        make.left.equalTo(_namelabel.mas_right).offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    _vipLabel = [[UILabel alloc]init];
    _vipLabel.font = [UIFont systemFontOfSize:kTextSize];
    _vipLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_vipLabel];
    [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_namelabel.mas_bottom).offset(10);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(kTextSize);
        make.left.equalTo(self.view).offset(15);
    }];
    
    //中间显示当前会员及本信息的视图
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.bottom+10, kScreenW, 93)];
    _centerView.backgroundColor = [UIColor colorWithRed:165/255.0 green:49/255.0 blue:50/255.0 alpha:0.8];
//    [self.view addSubview:_centerView];
    
    _moneyLabel = [UILabel initWithTitle:[NSString stringWithFormat:@"预存款 ¥%@",[CustomTool positiveFormat:@"3000000"]] withFont:20 textColor:kdetailColor];
    [_scrollView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_vipLabel.mas_bottom).offset(50);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *payButton = [UIButton newButtonWithTitle:@"充值" sel:@selector(payButtonClick) target:self cornerRadius:YES];
    [bottomView addSubview:_updateButton];
    [_scrollView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyLabel);
        make.top.equalTo(_moneyLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *detailButton = [UIButton buttonWithTitle:@"明细"];
    [detailButton addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_scrollView addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payButton);
        make.left.equalTo(payButton.mas_right).offset(10);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
    }];
    
//    _remainingDays = [UILabel initWithTitle:@"剩余免费用车天数0天" withFont:18 textColor:kdetailColor];
//    [_scrollView addSubview:_remainingDays];
//    [_remainingDays mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(payButton);
//        make.top.mas_equalTo(payButton.mas_bottom).offset(30);
//        make.width.mas_equalTo(kScreenW-30);
//        make.height.mas_equalTo(18);
//    }];
    
    _bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 300, kScreenW, kScreenW/375.0*348)];
    [_scrollView addSubview:_bottomView];
}

- (void)updatBtnClick:(UIButton *)sender{
    if ([_vipModel.vipLevel isEqualToString:@"3"]) {
        return;
    }else{
        VIPViewController *vc = [[VIPViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)payButtonClick{
    paymentViewController *vc =[[paymentViewController alloc]init];
    vc.vip = YES;
     [self.navigationController pushViewController:vc animated:YES];
}

- (void)detailBtnClick{
    DepositListViewController *vc = [[DepositListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
