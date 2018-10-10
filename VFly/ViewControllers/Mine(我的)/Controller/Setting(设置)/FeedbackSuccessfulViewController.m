//
//  FeedbackSuccessfulViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "FeedbackSuccessfulViewController.h"

@interface FeedbackSuccessfulViewController ()

@end

@implementation FeedbackSuccessfulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backImage.image = [UIImage imageNamed:@"icon_close"];
    self.view.backgroundColor = kWhiteColor;
    [self createView];
}

- (void)createView{
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"image_complete"];
    [self.view addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(100);
    }];
    
    UILabel *titleLabel = [UILabel initWithTitle:@"感谢您的意见和建议" withFont:kTitleBigSize textColor:kdetailColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kTitleBigSize);
    }];

    UILabel *detailLabel = [UILabel initWithTitle:@"工作人员会尽快记录，积极改善" withFont:kTextSize textColor:kNewDetailColor];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kTextSize);
    }];

    UIButton *button = [UIButton newButtonWithTitle:@"确定"  sel:@selector(defaultLeftBtnClick) target:self cornerRadius:YES];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel.mas_bottom).offset(89);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(44);
    }];
}

- (void)defaultLeftBtnClick {
    NSAssert(self.navigationController, @"self.navigationController == nil");
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
