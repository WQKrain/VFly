//
//  DrawMoneyAlertViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "DrawMoneyAlertViewController.h"

@interface DrawMoneyAlertViewController ()
@property (nonatomic , strong)GlobalConfigModel *obj;
@end

@implementation DrawMoneyAlertViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"withdraw";
    self.backImage.image = [UIImage imageNamed:@"icon_close"];
    self.titleStr = @"提现";
    self.view.backgroundColor = kWhiteColor;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    _obj = [[GlobalConfigModel alloc]initWithDic:dic];
    [self createView];
}

- (void)createView{
    UILabel *alertLabel = [UILabel initWithTitle:@"提现请联系客服" withFont:kTitleBigSize textColor:kdetailColor];
    [self.view addSubview:alertLabel];
    
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(144+kStatutesBarH);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(kTitleBigSize);
    }];
    
    UILabel *phoneLabel = [UILabel initWithTitle:@"400-117-8880" withFont:kNewTitle textColor:kdetailColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:phoneLabel];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(alertLabel.mas_bottom).offset(55);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kNewTitle);
    }];
    
    UIButton *button = [UIButton newButtonWithTitle:@"" sel:@selector(doneBtnClick) target:self cornerRadius:NO];
    button.imageEdgeInsets = UIEdgeInsetsMake(11, 0, 11, 0);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[UIImage imageNamed:@"icon_call"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(phoneLabel.mas_bottom).offset(55);
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(44);
    }];
}

- (void)doneBtnClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_obj.customerServiceTel]]];
}

- (void)alert{
    
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
