//
//  LoginViewController.m
//  LuxuryCar
//
//  Created by joyingnet on 16/8/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BaseNavigationController.h"
#import "LoginViewController.h"

#import "GlobalConfigModel.h"
#import "LoginModel.h"
#import "WebViewVC.h"
#import "VFUserInfoModel.h"
static NSInteger timeMark;

@interface LoginViewController ()<UITextFieldDelegate>
{
    NSInteger index;
    NSInteger count;
    NSTimer *timer;
}

@property (nonatomic, strong) NSTimer *otherTimer;
@property (nonatomic, strong) UIImageView *loginBgImgView; // 背景

@property (strong, nonatomic) UIImageView *logoImgView;  // logo
@property (strong, nonatomic) UILabel *getLabel;         // 获取验证码
@property (strong, nonatomic) UITextField *textField;    // 手机号 输入框
@property (strong, nonatomic) UITextField *codeField;    // 验证码 输入框
@property (strong, nonatomic) UIButton *sureBtn;         // 登录 按钮
@property (nonatomic, strong) UIView *alertBgView;       // 授权背景视图
@property (strong, nonatomic) UIButton *alertBtn;        // 是否授权 按钮
@property (nonatomic, strong) UILabel *alertTitle;       // 我已阅读并同意
@property (nonatomic, strong) UIButton *protocolContent; // 协议内容 按钮
@property (nonatomic, assign) BOOL  isAnimating;
@property (nonatomic, strong) UIButton *codeButton;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [JSFProgressHUD hiddenHUD:self.view];
    timeMark = count;
}

- (void)defaultLeftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//push 进来时隐藏 TabBar
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.UMPageStatistical = @"login";
    // 创建姿子视图
    [self createCustomSubviews];
    self.alertBtn.selected = YES;
    
    if (timeMark) {
        [self startOtherTimer];
        count = timeMark;
        [self countReduce];
    }
    
    self.view.backgroundColor = kWhiteColor;
    
    [self.textField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.codeField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    // 监听键盘弹出隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createCustomSubviews{
    _logoImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Layer-3"]];
    [self.view addSubview:_logoImgView];
    [_logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(110);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(125);
    }];
    NSArray *imageArr = @[[UIImage imageNamed:@"icon_PhoneNumber"],[UIImage imageNamed:@"icon_YanZhengMa"]];
    NSArray *lfeftArr = @[@"手机号",@"校验码"];
    NSArray *placeholderArr = @[@"请输入手机号",@"请输入校验码"];
    for (int i=0; i<2; i++) {
        UIView *inputView = [[UIView alloc]init];
        [self.view addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_logoImgView.mas_bottom).offset(45+i*64);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(kScreenW);
            make.height.mas_equalTo(64);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = klineColor;
        [inputView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(inputView.mas_left).offset(15);
            make.bottom.equalTo(inputView).offset(-1);
            make.width.mas_equalTo(kScreenW-30);
            make.height.mas_equalTo(1);
        }];
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:imageArr[i]];
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [inputView addSubview:leftImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(inputView);
            make.width.height.mas_equalTo(22);
        }];
        
        UILabel *leftLabel = [UILabel initWithTitle:lfeftArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        [inputView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageView.mas_right).offset(5);
            make.centerY.equalTo(inputView);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.placeholder = placeholderArr[i];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font = [UIFont systemFontOfSize:kTitleBigSize];
        [inputView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right).offset(10);
            make.centerY.equalTo(inputView);
            if (i== 0) {
                make.width.mas_equalTo(kScreenW-80);
            }else{
                make.width.mas_equalTo(kScreenW-175);
            }
            make.height.mas_equalTo(50);
        }];
        
        switch (i) {
            case 0:
                _textField = textField;
                break;
            case 1:{
                _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_codeButton setTitleColor:kMainColor forState:UIControlStateNormal];
                [_codeButton.titleLabel setFont:[UIFont systemFontOfSize:kTitleBigSize]];
                [_codeButton addTarget:self action:@selector(getPhoneCode:) forControlEvents:UIControlEventTouchUpInside];
                [inputView addSubview:_codeButton];
                [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(inputView.mas_right).offset(-100);
                    make.centerY.equalTo(inputView);
                    make.width.mas_equalTo(85);
                    make.height.mas_equalTo(64);
                }];
                
                _codeField = textField;
            }
                break;
            default:
                break;
        }
    }
    
    UIButton *loginButton = [UIButton newButtonWithTitle:@"登录"  sel:@selector(loginButtonCilck) target:self cornerRadius:YES];
    _sureBtn = loginButton;
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeField.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *agreenmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreenmentButton setImage:[UIImage imageNamed:@"icon_checkbox_off"] forState:UIControlStateNormal];
    [agreenmentButton setImage:[UIImage imageNamed:@"icon_checkbox_on"] forState:UIControlStateSelected];
    agreenmentButton.selected = YES;
    [agreenmentButton addTarget:self action:@selector(agreentmentButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreenmentButton];
    _alertBtn = agreenmentButton;
    [agreenmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((kScreenW-282)/2);
        make.top.equalTo(loginButton.mas_bottom).offset(22);
        make.width.height.mas_equalTo(22);
    }];
    
    UILabel *readingLabel = [UILabel initWithTitle:@"阅读并同意" withFont:kTitleBigSize textColor:kdetailColor];
    [self.view addSubview:readingLabel];
    [readingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreenmentButton.mas_right).offset(5);
        make.top.equalTo(loginButton.mas_bottom);
        make.height.mas_equalTo(66);
        make.width.mas_equalTo(85);
    }];
    
    UIButton *agreenUrl = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreenUrl setTitle:@"《威风出行用户协议》" forState:UIControlStateNormal];
    [agreenUrl setTitleColor:kMainColor forState:UIControlStateNormal];
    [agreenUrl.titleLabel setFont:[UIFont systemFontOfSize:kTitleBigSize]];
    [agreenUrl addTarget:self action:@selector(agreenUrl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreenUrl];
    [agreenUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(readingLabel.mas_right);
        make.top.equalTo(loginButton.mas_bottom);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(66);
    }];
}



- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.isAnimating) {
        // 为背景添加波动效果
        // 设定为缩放
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        // 动画选项设定
        animation.duration = 5; // 动画持续时间
        animation.repeatCount = MAXFLOAT; // 重复次数
        animation.autoreverses = YES; // 动画结束时执行逆动画
        // 缩放倍数
        animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
        animation.toValue = [NSNumber numberWithFloat:1.1];   // 结束时的倍率
        // 添加动画
        [self.loginBgImgView.layer addAnimation:animation forKey:@"Login-Scale-Layer"];
        
        self.isAnimating = NO;
    }
}

#pragma mark - Private Methods

- (void)agreentmentButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)agreenUrl:(UIButton *)sender
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    GlobalConfigModel *obj = [[GlobalConfigModel alloc]initWithDic:dic];
    WebViewVC *fdVC = [WebViewVC new];
    fdVC.urlStr = obj.cUser;
    fdVC.isPresent = YES;
    fdVC.urlTitle = @"用户协议";
    [self presentViewController:fdVC animated:YES completion:nil];
}

- (void)getPhoneCode:(UIButton *)sender
{
    kWeakself;
     index = arc4random()%899999+100000;
    //正则判断
    NSString *regTel = @"^1[345789]{1}\\d{9}$";
    NSRegularExpression *regularEx = [[NSRegularExpression alloc] initWithPattern:regTel options:NSRegularExpressionCaseInsensitive error:NULL];
    
    _numberStr = self.textField.text;
    NSArray *items = [regularEx matchesInString:_numberStr options:NSMatchingReportProgress range:NSMakeRange(0, _numberStr.length)];
    if (items.count != 0) {
        for (NSTextCheckingResult *r in items) {
            
            NSString *result = [_numberStr substringWithRange:r.range];
            [JSFProgressHUD showHUDToView:self.view];
            [VFHttpRequest smsParameter:@{@"mobile":result,@"type":@"1"} successBlock:^(NSDictionary *data) {
                VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                if ([model.code intValue] == 1) {
                    [weakSelf startTimer];
                }else{
                    HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.message];
                    HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
                        [timer invalidate];
                        self.getLabel.text = @"获取验证码";
                        self.getLabel.userInteractionEnabled = YES;
                    }];
                    [alertCtrl addAction:Action];
                    [weakSelf presentViewController:alertCtrl animated:NO completion:nil];
                }
                [JSFProgressHUD hiddenHUD:self.view];
            } withFailureBlock:^(NSError *error) {
                [JSFProgressHUD hiddenHUD:self.view];

            }];
        }
    } else
    {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请输入正确的手机号"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
    }
}

- (void)loginButtonCilck
{
    if (!_alertBtn.selected) {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请先同意用户协议"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
        return;
    }
    
    [self.view endEditing:YES];
    kWeakself;
    if ([_textField.text isEqualToString:@""] || [_codeField.text isEqualToString:@""])
    {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"输入信息有误，请核实后重新输入"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
    }
    else
    {
        [JSFProgressHUD showHUDToView:self.view];
        NSString *pushID = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
        [VFHttpRequest loginParameter:@{@"mobile":self.textField.text,@"code":self.codeField.text,@"pushid":pushID?pushID:@""} successBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            VFBaseMode *obj = [[VFBaseMode alloc]initWithDic:data];
            if ([obj.code intValue] == 1) {
                [VFHttpRequest getUserInfoSuccessBlock:^(NSDictionary *data) {
                    VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                    VFUserInfoModel *userInfoModel = [[VFUserInfoModel alloc]initWithDic:model.data];
                    [[NSUserDefaults standardUserDefaults] setObject:userInfoModel.phone forKey:kmobile];
                    [[NSUserDefaults standardUserDefaults] setObject:userInfoModel.userId forKey:UserId];
                } withFailureBlock:^(NSError *error) {
                    
                }];
                
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    if ([weakSelf.delegate respondsToSelector:@selector(loginViewControllerCallback)]) {
                        [weakSelf.delegate loginViewControllerCallback];
                    }
                }];
            }else{
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
}

//返回按钮
- (IBAction)goBackBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 限制输入框长度
- (void)textFieldChangeAction:(UITextField *)textField
{
    if(textField == self.textField)
    {
        if(textField.text.length >= 11){
            textField.text = [textField.text substringToIndex:11];
        }
    }
    else if (textField == self.codeField){
        if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)keyBoardWillShow:(NSNotification *)info
{
    CGFloat diff_Height = SpaceH(169)-SpaceH(146);
    [UIView animateWithDuration:.25 animations:^{
        self.logoImgView.transform = CGAffineTransformMake(.76, 0.0, 0.0, .76, 0.0, -diff_Height);
    }];
}

- (void)keyBoardWillHide:(NSNotification *)info
{
    [UIView animateWithDuration:.25 animations:^{
        self.logoImgView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - NSTimer相关

- (void)startTimer {
    count = 60;
    if (!timer)
    {
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countReduce) userInfo:nil repeats:YES];
    }
}

- (void)startOtherTimer
{
    if (nil == self.otherTimer)
    {
        self.otherTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countReduce) userInfo:nil repeats:YES];
    }
}

- (void)countReduce{
    timeMark = --count;
    
    [_codeButton setTitle:[NSString stringWithFormat:@"%lds",(long)count] forState:UIControlStateNormal];
    [_codeButton setEnabled:NO];
    if (count==0) {
        [self stopTimer];
        [_codeButton setEnabled:YES];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)stopTimer {
    [timer invalidate];
    timer = nil;
    [self.otherTimer invalidate];
    [self setOtherTimer:nil];
    
    self.getLabel.text = @"获取验证码";
    self.getLabel.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Getters/Setters
@end
