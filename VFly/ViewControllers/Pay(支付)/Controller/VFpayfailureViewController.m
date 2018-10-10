//
//  VFpayfailureViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFpayfailureViewController.h"

@interface VFpayfailureViewController ()

@end

@implementation VFpayfailureViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backImage.image = [UIImage imageNamed:@"关闭"];
}

- (void)createView{
    UIImageView *topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_fail"]];
    [self.view addSubview:topImage];
    UILabel *topLabel = [UILabel initWithTitle:self.showInfo withFont:kTitleBigSize textColor:kdetailColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    UILabel *bottomLabel = [UILabel initWithTitle:@"请尝试其他付款方式" withFont:kTextSize textColor:kNewDetailColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];

    UIButton *backButton = [UIButton newButtonWithTitle:@"知道了"  sel:@selector(backButtonClcik) target:self cornerRadius:YES];
    [self.view addSubview:backButton];
    
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
        make.top.equalTo(topLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(kTextSize);
        make.centerX.equalTo(self.view);
    }];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLabel.mas_bottom).offset(89);
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
}

- (void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
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
