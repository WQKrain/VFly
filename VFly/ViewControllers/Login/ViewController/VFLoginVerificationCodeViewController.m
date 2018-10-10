//
//  VFLoginVerificationCodeViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/12.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFLoginVerificationCodeViewController.h"
#import "VFVerifCodeView.h"
#import "LoginModel.h"
#import "WebViewVC.h"
#import "VFUserInfoModel.h"

@interface VFLoginVerificationCodeViewController ()

@property (nonatomic, strong) UITextField *textField;    // 手机号 输入框
@property (nonatomic, strong) UIButton *sureBtn;         // 登录 按钮
@property (nonatomic, strong) VFVerifCodeView *vertificationCodeInputView;
@property (nonatomic, strong) UIButton *verifCodeButton; //倒计时按钮
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak) NSTimer *timer;
/*
 NSInteger count;
 NSTimer *timer;
 */


@end

@implementation VFLoginVerificationCodeViewController

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
    logoTitleLabel.text = @"输入验证码";
    [self.view addSubview:logoTitleLabel];
    logoTitleLabel.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, 120)
    .widthIs(200)
    .heightIs(40);
    
    UILabel *textLeftLabel = [[UILabel alloc]init];
    textLeftLabel.font = [UIFont systemFontOfSize:16];
    textLeftLabel.backgroundColor = [UIColor whiteColor];
    textLeftLabel.textAlignment = NSTextAlignmentLeft;
    textLeftLabel.textColor = HexColor(0xA8A8A8);
    textLeftLabel.text = @"验证码已发送到";
    [self.view addSubview:textLeftLabel];
    textLeftLabel.sd_layout
    .leftEqualToView(logoTitleLabel)
    .topSpaceToView(logoTitleLabel, 0)
    .heightIs(24);
    [textLeftLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *textRightLabel = [[UILabel alloc]init];
    textRightLabel.font = [UIFont systemFontOfSize:16];
    textRightLabel.backgroundColor = [UIColor whiteColor];
    textRightLabel.textAlignment = NSTextAlignmentLeft;
    textRightLabel.textColor = HexColor(0x0F0F0F);
    textRightLabel.text = [NSString stringWithFormat:@"%@",self.verificationCodeSting];
    [self.view addSubview:textRightLabel];
    textRightLabel.sd_layout
    .leftSpaceToView(textLeftLabel, 1)
    .topSpaceToView(logoTitleLabel, 0)
    .heightIs(24);
    [textLeftLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.vertificationCodeInputView = [[VFVerifCodeView alloc]initWithFrame:CGRectMake(20,250,kScreenW - 40,80)];
    // 验证码（显示数字）
    self.vertificationCodeInputView.secureTextEntry = NO;
    self.vertificationCodeInputView.numberOfVertificationCode = 6;
    [self.view addSubview:self.vertificationCodeInputView];
    [self.vertificationCodeInputView becomeFirstResponder];
    
    
    __weak __typeof__(self) weakSelf = self;
    self.vertificationCodeInputView.verifCodeBlock = ^(NSString *string) {
        [weakSelf logInWithVerifCode:string];
    };
    
    self.verifCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.verifCodeButton setTitle:@"60s" forState:UIControlStateNormal];
    [self.verifCodeButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.verifCodeButton.titleLabel setFont:[UIFont systemFontOfSize:kTitleBigSize]];
    [self.verifCodeButton addTarget:self action:@selector(getPhoneCode:) forControlEvents:UIControlEventTouchUpInside];
    self.verifCodeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.verifCodeButton];
    self.verifCodeButton.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.vertificationCodeInputView, 20)
    .heightIs(40);
    [self.verifCodeButton setupAutoSizeWithHorizontalPadding:2 buttonHeight:40];
    
    [self startTimer];
    
    
    
    
    
    
    
}

- (void)logInWithVerifCode:(NSString *)string {
    [JSFProgressHUD showHUDToView:self.view];
    kWeakSelf;
    NSString *pushID = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
    
    [VFHttpRequest loginParameter:@{@"mobile":self.verificationCodeSting,@"code":string,@"pushid":pushID?pushID:@""} successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
    
        VFBaseMode *obj = [[VFBaseMode alloc]initWithDic:data];
        if ([obj.code intValue] == 1)
        {
            [VFHttpRequest getUserInfoSuccessBlock:^(NSDictionary *data) {
                
                VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                VFUserInfoModel *userInfoModel = [[VFUserInfoModel alloc]initWithDic:model.data];
                [[NSUserDefaults standardUserDefaults] setObject:userInfoModel.phone forKey:kmobile];
                [[NSUserDefaults standardUserDefaults] setObject:userInfoModel.userId forKey:UserId];
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                
            } withFailureBlock:^(NSError *error) {
                [JSFProgressHUD hiddenHUD:self.view];
            }];
        }
        else
        {
            HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:obj.message];
            HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
            [alertCtrl addAction:Action];
            [self presentViewController:alertCtrl animated:NO completion:nil];
        }
    } withFailureBlock:^(NSError *error) {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"登录失败"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}

- (void)back:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getPhoneCode:(UIButton *)button {
    [self startTimer];
}

- (void)startTimer {
    self.count = 59;
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countReduce) userInfo:nil repeats:YES];
    }
}

- (void)countReduce {
    --self.count;
    
    [self.verifCodeButton setTitle:[NSString stringWithFormat:@"%lds",(long)self.count] forState:UIControlStateNormal];
    [self.verifCodeButton setEnabled:NO];
    if (self.count == 0)
    {
        [self stopTimer];
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.verifCodeButton setEnabled:YES];
    [self.verifCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
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
