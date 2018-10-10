//
//  VFPaySuccessfulViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFPaySuccessfulViewController.h"
#import "VFOrdertailViewController.h"
#import "MyWalletViewController.h"
#import "ShowVipViewController.h"
#import "VFNewOrderDetailViewController.h"

@interface VFPaySuccessfulViewController ()

@end

@implementation VFPaySuccessfulViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backImage.image = [UIImage imageNamed:@"关闭"];
    [self createView];
}

- (void)createView{
    UIImageView *topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_success"]];
    [self.view addSubview:topImage];
    UILabel *topLabel = [UILabel initWithTitle:@"恭喜您支付成功" withFont:kTitleBigSize textColor:kdetailColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    
    UILabel *bottomLabel = [UILabel initWithTitle:kFormat(@"¥%@", _payMoney) withFont:kNewTitle textColor:kdetailColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    
    UIButton *backButton = [UIButton buttonWithTitle:@"返回首页"];
    [backButton addTarget:self action:@selector(backButtonClcik) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    UIButton *detailButton = [UIButton buttonWithTitle:@"查看订单"];
    [detailButton addTarget:self action:@selector(jumpOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.view addSubview:detailButton];
    
    
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.width.height.mas_equalTo(100);
        make.centerX.equalTo(self.view);
    }];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom).offset(30);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(kTitleBigSize);
        make.centerX.equalTo(self.view);
    }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(kNewTitle);
        make.centerX.equalTo(self.view);
    }];
    
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLabel.mas_bottom).offset(89);
        make.width.mas_equalTo((kScreenW-45)/2);
        make.height.mas_equalTo(44);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLabel.mas_bottom).offset(89);
        make.width.mas_equalTo((kScreenW-45)/2);
        make.height.mas_equalTo(44);
        make.left.equalTo(detailButton.mas_right).offset(15);
    }];
    
    if ([_moneyType intValue] == 6) {
        topLabel.text = @"余额充值成功";
        [detailButton setTitle:@"查看余额" forState:UIControlStateNormal];
    }else if ([_moneyType intValue] == 8){
        topLabel.text = @"会员预存款充值成功";
        backButton.hidden = YES;
        [detailButton setTitle:@"查看我的会员权益" forState:UIControlStateNormal];
        [detailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(165);
            make.top.equalTo(bottomLabel.mas_bottom).offset(89);
        }];
    }else{
        topLabel.text = @"恭喜您支付成功";
    }

}

- (void)defaultLeftBtnClick {
    if (_isBalance) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MyWalletViewController class]]) {
                MyWalletViewController *revise =(MyWalletViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
    }else if ([_moneyType intValue] == 8){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ShowVipViewController class]]) {
                ShowVipViewController *revise =(ShowVipViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
                return;
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)jumpOrderDetail{
    if (_isBalance) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MyWalletViewController class]]) {
                MyWalletViewController *revise =(MyWalletViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
    }else if ([_moneyType intValue] == 8){
        ShowVipViewController *vc = [[ShowVipViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        if (_isNew) {
            VFNewOrderDetailViewController *vc = [[VFNewOrderDetailViewController alloc]init];
            vc.orderID = self.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            VFOrdertailViewController *vc = [[VFOrdertailViewController alloc]init];
            vc.orderID = self.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)backButtonClcik{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
