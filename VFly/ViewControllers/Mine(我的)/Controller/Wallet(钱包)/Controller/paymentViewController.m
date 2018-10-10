//
//  paymentViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "paymentViewController.h"
#import "VFChoosePayViewController.h"
#import "VFOldChoosePayViewController.h"
#import "VFPaymentModel.h"

@interface paymentViewController ()
@property (strong, nonatomic)NSString *orderID;
@property (nonatomic , strong)UITextField *textField;
@property (nonatomic , strong)VFPaymentModel *paymentObj;

@end

@implementation paymentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"充值";
    self.UMPageStatistical = @"balanceCharge";
    self.view.backgroundColor = kWhiteColor;
    
    UILabel *title = [UILabel initWithTitle:@"请输入充值金额" withFont:kTitleBigSize textColor:kdetailColor];
    [self.view addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kStatutesBarH+114);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(kTitleBigSize);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.placeholder= @"输入金额";
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:kNewTitle];
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(40);
        make.top.equalTo(title.mas_bottom).offset(55);
    }];
    
    UIButton *button = [UIButton newButtonWithTitle:@"确定"  sel:@selector(payButtonClick:) target:self cornerRadius:YES];
    
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(44);
        make.top.equalTo(_textField.mas_bottom).offset(55);
    }];
}

//限制输入框在7个字符之内
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.textField) {
        if (textField.text.length > 7) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:7];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
}


- (IBAction)payButtonClick:(UIButton *)sender {
    if ([_textField.text isEqualToString:@""]) {
        [CustomTool alertViewShow:@"请输入充值金额"];
    }else {
        NSInteger money =[_textField.text integerValue];
        if (money<1) {
            [CustomTool alertViewShow:@"充值金额不能低于1元"];
            return;
        }
        
        if (_isNew) {
            //新接口余额充值
            [JSFProgressHUD showHUDToView:self.view];
            [VFHttpRequest walletRechargePar:@{@"money":_textField.text} SuccessBlock:^(NSDictionary *data) {
                [JSFProgressHUD hiddenHUD:self.view];
                VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                _paymentObj = [[VFPaymentModel alloc]initWithDic:model.data];
                [self AlertPayOrder];
            } withFailureBlock:^(NSError *error) {
                [JSFProgressHUD hiddenHUD:self.view];
            }];
        }else{
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
            [JSFProgressHUD showHUDToView:self.view];
            NSDictionary *dic =@{@"token":token,@"money":_textField.text};
            if (_vip) {
                [HttpManage vipOrderParameter:dic success:^(NSDictionary *data) {
                    [JSFProgressHUD hiddenHUD:self.view];
                    HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                    if ([model.info isEqualToString:@"ok"]) {
                        _orderID = model.data[@"orderId"];
                        [self AlertPayOrder];
                    }else{
                        [CustomTool alertViewShow:model.info];
                    }
                } failedBlock:^{
                    [JSFProgressHUD hiddenHUD:self.view];
                }];
            }else{
                //余额充值
                [JSFProgressHUD showHUDToView:self.view];
                [HttpManage rechargeParameter:dic With:^(NSDictionary *data) {
                    [JSFProgressHUD hiddenHUD:self.view];
                    HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                    if ([model.info isEqualToString:@"ok"]) {
                        _orderID = model.data[@"orderId"];
                        [self AlertPayOrder];
                    }else{
                        [CustomTool alertViewShow:model.info];
                    }
                } failedBlock:^{
                    [JSFProgressHUD hiddenHUD:self.view];
                }];
                
            }
        }
        }
}

- (void)AlertPayOrder{
    if (_isNew) {
        VFChoosePayViewController *vc = [[VFChoosePayViewController alloc]init];
        vc.orderID = _paymentObj.order_id;
        vc.moneyType = _paymentObj.should_pay_id;
        vc.handler = _paymentObj.handler;
        vc.payMoney = _paymentObj.money;
        vc.isHiddenBalancePay = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
        vc.orderID = self.orderID;
        if (_vip) {
            vc.moneyType = @"8";
        }else{
            vc.moneyType = @"6";
        }
        [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)payButton:(UIButton *)sender {
}
@end
