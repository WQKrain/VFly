//
//  VFFeedBackSuccessController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFFeedBackSuccessController.h"

@interface VFFeedBackSuccessController ()

@end

@implementation VFFeedBackSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self setupView];

}

- (void)setupView {
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"common_icon_right"];
    [self.view addSubview:imageView];
    imageView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .widthIs(90)
    .heightIs(90);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = HexColor(0xE62327);
    titleLabel.text = @"提交成功，感谢您的反馈";
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(imageView, 20)
    .heightIs(30);
    
    UIButton *sureButton = [[UIButton alloc]init];
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    sureButton.layer.cornerRadius = 5.f;
    [sureButton setBackgroundColor:HexColor(0xE62327)];
    [self.view addSubview:sureButton];
    [sureButton addTarget:self action:@selector(sure:) forControlEvents:(UIControlEventTouchUpInside)];
    sureButton.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .bottomSpaceToView(self.view, 60)
    .heightIs(50);
    
}

- (void)sure:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
