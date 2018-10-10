//
//  VFValidationCodeViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFValidationCodeViewController.h"
#import "VFPaySuccessfulViewController.h"
#import "VFpayfailureViewController.h"

@interface VFValidationCodeViewController (){
    int _count;
}
@property (nonatomic , strong)UILabel *showCodeLabel;
@property (nonatomic , strong)UIButton *getCode;
@property (nonatomic , strong)UITextField *codeTextField;

@end

@implementation VFValidationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"验证手机号";
    [self createView];
}

- (void)createView{
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kmobile];
    NSString *show = kFormat(@"本次操作需要短信确认，请输入%@收到的短信验证码", phone);
    UILabel *phonelabel = [UILabel initWithTitle:show withFont:kTitleBigSize textColor:kdetailColor];
    phonelabel.numberOfLines = 0;
    phonelabel.frame = CGRectMake(15, 174, kScreenW-30, 56);
    [self.view addSubview:phonelabel];
    
    UILabel *leftlable = [UILabel initWithTitle:@"校验码" withFont:kTitleBigSize textColor:kdetailColor];
    leftlable.frame = CGRectMake(15, phonelabel.bottom+49, 50, kTitleBigSize);
    [self.view addSubview:leftlable];
    
    _codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(leftlable.right+10, phonelabel.bottom+35, kScreenW-160, 44)];
    _codeTextField.font = [UIFont systemFontOfSize:kTitleBigSize];
    _codeTextField.placeholder = @"请输入验证码";
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_codeTextField];
    
    _showCodeLabel = [UILabel initWithTitle:@"获取验证码" withFont:kTitleBigSize textColor:kMainColor];
    _showCodeLabel.frame = CGRectMake(kScreenW-110, phonelabel.bottom+35, 95, 44);
    _showCodeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_showCodeLabel];
    
    _getCode = [UIButton buttonWithType:UIButtonTypeCustom];
    _getCode.frame = CGRectMake(kScreenW-100, phonelabel.bottom, 85, 100);
    [_getCode addTarget:self action:@selector(getCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCode];
    
    UIView *lineView=  [[UIView alloc]initWithFrame:CGRectMake(15, phonelabel.bottom+94, kScreenW-30, 1)];
    lineView.backgroundColor = klineColor;
    [self.view addSubview:lineView];
    
    UIButton *applyButton = [UIButton newButtonWithTitle:@"确定"  sel:@selector(applyButtonClick) target:self cornerRadius:YES];
    
    applyButton.frame = CGRectMake((kScreenW-165)/2, lineView.bottom+30, 165, 44);
    [self.view addSubview:applyButton];
}


- (void)getCodeButton:(UIButton *)sender{
    [self performSelectorInBackground:@selector(theCountdown) withObject:nil];
    sender.enabled = NO;
    NSString *mobile= [[NSUserDefaults standardUserDefaults]objectForKey:kmobile];
    
    if (_isNew) {
        [VFHttpRequest smsParameter:@{@"type":@"3",@"mobile":mobile} successBlock:^(NSDictionary *data) {
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            if ([model.code intValue] == 1) {
                
            }else{
                
            }
        } withFailureBlock:^(NSError *error) {
            
        }];
        
    }else{
        [HttpManage getPhoneCodeWith:mobile action:@"3" withBlock:^(NSString *code) {
            if ([code isEqualToString:@"ok"]) {
                
            }else{
                
            }
        } withFailedBlock:^{
        }];
    }
}

- (void)theCountdown{
    for(int i=59;i>=0;i--)
    {
        _count = i;
        // 回调主线程
        [self performSelectorOnMainThread:@selector(showTimeChange) withObject:nil waitUntilDone:YES];
        sleep(1);
    }
}

- (void)showTimeChange
{
    _showCodeLabel.text=[NSString stringWithFormat:@"%d秒后重发",_count];
    _showCodeLabel.textColor= kNewDetailColor;
    if (_count==0) {
        _showCodeLabel.text =@"获取验证码";
        _showCodeLabel.textColor= kMainColor;
        _getCode.enabled = YES;
    }
}

- (void)applyButtonClick{
    
    if ([_codeTextField.text isEqualToString:@""] || [_codeTextField.text length] != 6) {
        [CustomTool alertViewShow:@"验证码不符合规范"];
        return;
    }
    
    NSString *score;
    if ([_useIntegral intValue]>0) {
        score = @"1";
    }else{
        score = @"0";
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic;
    
    if (_isNew) {
        
        if ([_useCouponsID intValue]>0) {
            
            if ([self.doPayFee intValue] == 0) {
                //0元支付
                dic =  @{@"orderId":self.orderID,@"should_pay_id":_moneyType,@"func":@"1",@"code":_codeTextField.text,@"couponId":_useCouponsID?_useCouponsID:@"",@"score":score,@"payFee":_doPayFee};
            }else{
                dic =  @{@"orderId":self.orderID,@"should_pay_id":_moneyType,@"func":_func,@"code":_codeTextField.text,@"couponId":_useCouponsID?_useCouponsID:@"",@"score":score,@"payFee":_doPayFee};
            }
        }else{
            
            if ([self.doPayFee intValue] == 0) {
                //0元支付
                dic =  @{@"orderId":self.orderID,@"should_pay_id":_moneyType,@"func":@"1",@"code":_codeTextField.text,@"score":score,@"payFee":_doPayFee,@"version":@"v2"};
            }else{
//                dic = @{@"orderId":self.orderID,@"should_pay_id":_moneyType,@"func":_func,@"code":_codeTextField.text,@"score":score,@"payFee":_doPayFee,@"version":@"v2"};
                dic = @{@"orderId":self.orderID,@"should_pay_id":_moneyType,@"func":_func,@"code":_codeTextField.text,@"score":score,@"payFee":_doPayFee,@"version":@"v2"};
            }
        }
        
        [JSFProgressHUD showHUDToView:self.view];
        [VFHttpRequest walletPayParameter:dic SuccessBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            VFBaseMode *obj = [[VFBaseMode alloc]initWithDic:data];
            if ([obj.code intValue] == 1) {
                VFPaySuccessfulViewController *vc = [[VFPaySuccessfulViewController alloc]init];
                vc.orderId = self.orderID;
                vc.moneyType = self.moneyType;
                vc.payMoney = self.doPayFee;
                vc.isNew = _isNew;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                VFpayfailureViewController *vc =[[VFpayfailureViewController alloc]init];
                vc.showInfo = obj.message;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
            VFpayfailureViewController *vc =[[VFpayfailureViewController alloc]init];
            vc.showInfo = @"支付失败";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        
    }else{
        
        if ([self.doPayFee intValue] == 0) {
            //0元支付
            dic =  @{@"token":token,@"orderId":self.orderID,@"moneyType":_moneyType,@"func":@"3",@"code":_codeTextField.text,@"couponId":_useCouponsID?_useCouponsID:@"",@"score":score,@"payFee":_doPayFee};
        }else{
            dic =  @{@"token":token,@"orderId":self.orderID,@"moneyType":_moneyType,@"func":_func,@"code":_codeTextField.text,@"couponId":_useCouponsID?_useCouponsID:@"",@"score":score,@"payFee":_doPayFee};
        }
        
        [JSFProgressHUD showHUDToView:self.view];
        [HttpManage walletPayParameter:dic With:^(NSString *info) {
            [JSFProgressHUD hiddenHUD:self.view];
            if ([info isEqualToString:@"ok"]) {
                VFPaySuccessfulViewController *vc = [[VFPaySuccessfulViewController alloc]init];
                vc.orderId = self.orderID;
                vc.moneyType = self.moneyType;
                vc.payMoney = self.doPayFee;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                VFpayfailureViewController *vc =[[VFpayfailureViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.showInfo = info;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failedBlock:^{
            
        }];
        
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
