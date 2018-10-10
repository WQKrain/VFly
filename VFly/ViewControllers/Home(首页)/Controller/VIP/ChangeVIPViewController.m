//
//  ChangeVIPViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/17.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ChangeVIPViewController.h"

@interface ChangeVIPViewController ()

@end

@implementation ChangeVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titletext;
    self.view.backgroundColor = [UIColor grayColor];
    [self createView];
}

- (void)createView{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(kScreenW-kSpaceW(86));
        make.height.mas_equalTo(kScreenH-kSpaceH(260));
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_state_sucess"];
    [bgView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.top).offset(kSpaceH(66));
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(kSpaceW(88));
        make.height.mas_equalTo(kSpaceW(88));
    }];
    
    UILabel *successLabel = [[UILabel alloc]init];
    successLabel.text = _successLabel;
    successLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:successLabel];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(kSpaceH(30));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(bgView.mas_width);
        make.height.mas_equalTo(kSpaceH(20));
    }];
    
    UILabel *alertlabel = [[UILabel alloc]init];
    alertlabel.font = [UIFont systemFontOfSize:kTextSize];
    alertlabel.text = _alertLabel;
    alertlabel.numberOfLines = 0;
    alertlabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:alertlabel];
    
    [alertlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successLabel.mas_bottom).offset(kSpaceH(30));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(bgView.mas_width);
        make.height.mas_equalTo(kSpaceH(50));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundColor:kMainColor];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bgView.mas_bottom).offset(kSpaceH(-30));
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(kSpaceW(223));
        make.height.mas_equalTo(kSpaceW(44));
    }];

}

- (void)btnClick{
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
