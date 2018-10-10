//
//  VFLoginViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/12.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFLoginViewController.h"
#import "VFLoginVerificationCodeViewController.h"

@interface VFLoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;    // 手机号 输入框

@property (strong, nonatomic) UIButton *sureBtn;         // 登录 按钮

@end

@implementation VFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    [self setupView];
    
}

- (void)setupView {
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatutesBarH + 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc]init];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.frame = CGRectMake(0, 0, 100, kStatutesBarH + 44);
    [navView addSubview:backButton];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"关闭";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [backButton addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(backButton, 20)
    .bottomSpaceToView(backButton, 0)
    .heightIs(24)
    .widthIs(80);
    
    //----------
    
    
    UILabel *logoTitleLabel = [[UILabel alloc]init];
    logoTitleLabel.font = [UIFont boldSystemFontOfSize:28];
    logoTitleLabel.backgroundColor = [UIColor whiteColor];
    logoTitleLabel.textAlignment = NSTextAlignmentLeft;
    logoTitleLabel.textColor = HexColor(0x212121);
    logoTitleLabel.text = @"手机号登录";
    [self.view addSubview:logoTitleLabel];
    logoTitleLabel.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, 120)
    .widthIs(200)
    .heightIs(40);

    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.font = [UIFont systemFontOfSize:16];
    leftLabel.backgroundColor = [UIColor whiteColor];
    leftLabel.textAlignment = NSTextAlignmentRight;
    leftLabel.textColor = HexColor(0xA8A8A8);
    leftLabel.text = @"+86";
    [self.view addSubview:leftLabel];
    leftLabel.sd_layout
    .leftSpaceToView(self.view, 20)
    .centerYIs(kScreenH / 2 - 50)
    .widthIs(40)
    .heightIs(24);
    
    self.textField = [[UITextField alloc]init];
    self.textField.placeholder = @"请输入手机号";
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.font = [UIFont systemFontOfSize:kTitleBigSize];
    [self.view addSubview:self.textField];
    self.textField.sd_layout
    .leftSpaceToView(leftLabel, 10)
    .centerYIs(kScreenH / 2 - 50)
    .rightSpaceToView(self.view, 20)
    .heightIs(24);
    [self.textField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = klineColor;
    [self.view addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(self.textField, 2)
    .heightIs(1);
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    self.sureBtn.backgroundColor = HexColor(0xA8A8A8);
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.userInteractionEnabled = NO;
    [self.sureBtn addTarget:self action:@selector(sure:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.sureBtn];
    self.sureBtn.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(lineView, 20)
    .heightIs(44);
}

- (void)sure:(UIButton *)sender {

    kWeakself;
    //正则判断
    NSString *regTel = @"^1[345789]{1}\\d{9}$";
    NSRegularExpression *regularEx = [[NSRegularExpression alloc] initWithPattern:regTel options:NSRegularExpressionCaseInsensitive error:NULL];

    NSArray *items = [regularEx matchesInString:self.textField.text
                                        options:NSMatchingReportProgress
                                          range:NSMakeRange(0, self.textField.text.length)];

    if (items.count != 0)
    {

        NSString *result = self.textField.text;
        [JSFProgressHUD showHUDToView:self.view];
        [VFHttpRequest smsParameter:@{@"mobile":result,@"type":@"1"} successBlock:^(NSDictionary *data) {
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            if ([model.code intValue] == 1)
            {
                VFLoginVerificationCodeViewController *loginVerVC = [[VFLoginVerificationCodeViewController alloc]init];
                loginVerVC.verificationCodeSting = self.textField.text;
                [self.navigationController pushViewController:loginVerVC animated:YES];
            }
            else
            {
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.message];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {

                }];
                [alertCtrl addAction:Action];
                [weakSelf presentViewController:alertCtrl animated:NO completion:nil];
            }
            [JSFProgressHUD hiddenHUD:self.view];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
        }];



        /*
        for (NSTextCheckingResult *r in items) {

            NSString *result = [self.textField.text substringWithRange:r.range];
            [JSFProgressHUD showHUDToView:self.view];
            [VFHttpRequest smsParameter:@{@"mobile":result,@"type":@"1"} successBlock:^(NSDictionary *data) {
                VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                if ([model.code intValue] == 1)
                {
                    VFLoginVerificationCodeViewController *loginVerVC = [[VFLoginVerificationCodeViewController alloc]init];
                    loginVerVC.verificationCodeSting = self.textField.text;
                    [self.navigationController pushViewController:loginVerVC animated:YES];
                }
                else
                {
                    HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.message];
                    HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {

                    }];
                    [alertCtrl addAction:Action];
                    [weakSelf presentViewController:alertCtrl animated:NO completion:nil];
                }
                [JSFProgressHUD hiddenHUD:self.view];
            } withFailureBlock:^(NSError *error) {
                [JSFProgressHUD hiddenHUD:self.view];
            }];
        }
        */
    }
    else
    {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请输入正确的手机号"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
    }
    

    
}








- (void)back:(UIButton *)button {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 限制输入框长度
- (void)textFieldChangeAction:(UITextField *)textField {
    if(textField == self.textField)
    {
        if(textField.text.length >= 11)
        {
            textField.text = [textField.text substringToIndex:11];
            self.sureBtn.userInteractionEnabled = YES;
            self.sureBtn.backgroundColor = HexColor(0xE62327);
        }
        else
        {
            self.sureBtn.backgroundColor = HexColor(0xA8A8A8);
            self.sureBtn.layer.masksToBounds = NO;
        }
    }
}






@end
