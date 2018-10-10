//
//  VFAddBankCardViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFAddBankCardViewController.h"
#import "VFPaySuccessfulViewController.h"
#import "VFpayfailureViewController.h"
#import "anyButton.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"
#import "LLOrder.h"
#import "LoginModel.h"
#import "VFUserInfoModel.h"

@interface VFAddBankCardViewController ()<LLPaySdkDelegate>
@property (nonatomic , strong)UITextField *nameTextField;
@property (nonatomic , strong)UITextField *cardTextField;
@property (nonatomic , strong)UITextField *bankTextField;
@property (nonatomic, strong) LLOrder *order;
@property (nonatomic, strong) NSString *resultTitle;
@property (nonatomic, retain) NSMutableDictionary *orderDic;
@property (nonatomic, strong) VFUserInfoModel *userInfoModel;

@end

static NSString *kLLOidPartner = @"201707071001873535";//@"201408071000001546";                 // 商户号
static NSString *kLLPartnerKey = @"威风出行最帅的吕佩刚";//@"201408071000001546_test_20140815";   // 密钥
static NSString *signType = @"MD5"; //签名方式
static LLPayType payType = LLPayTypeVerify;

@implementation VFAddBankCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"lianlianPay";
    self.titleStr = @"添加银行卡";
    [self createView];
    
    [VFHttpRequest getUserInfoSuccessBlock:^(NSDictionary *data) {
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        if ([model.code intValue] == 1) {
            _userInfoModel = [[VFUserInfoModel alloc]initWithDic:model.data];
            _nameTextField.text = _userInfoModel.name;
            _cardTextField.text = _userInfoModel.card;
            if ([_userInfoModel.name isEqualToString:@""] || [_userInfoModel.card isEqualToString:@""]) {
                _nameTextField.userInteractionEnabled = YES;
                _cardTextField.userInteractionEnabled = YES;
            }else{
                _nameTextField.userInteractionEnabled = NO;
                _cardTextField.userInteractionEnabled = NO;
            }
        }
        _userInfoModel = [[VFUserInfoModel alloc]initWithDic:model.data];
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
        [ProgressHUD showError:@"加载失败"];
    }];
}

- (void)createView{
    UILabel *label = [UILabel initWithTitle:@"请绑定持卡人本人的银行卡" withFont:kTextSize textColor:kdetailColor];
    label.frame = CGRectMake(15, kOldNavBarH, kScreenW-30, kTextSize);
    [self.view addSubview:label];
    NSArray *leftArr = @[@"持卡人",@"银行卡号",@"身份证号"];
    NSArray *place = @[@"请输入姓名",@"请输入银行卡号",@"请输入身份证号"];
    for (int i= 0; i<3; i++) {
        UIView *listView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom+27+64*i, kScreenW, 64)];
        [self.view addSubview:listView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 63, kScreenW-30, 1)];
        lineView.backgroundColor = klineColor;
        [listView addSubview:lineView];
        
        UILabel *leftLabel = [UILabel initWithTitle:leftArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        leftLabel.frame =CGRectMake(15, 24, 70, kTitleBigSize);
        [listView addSubview:leftLabel];
        
        if (i != 1) {
            anyButton *button = [anyButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kScreenW-64, 7, 64, 64);
            [button setImage:[UIImage imageNamed:@"添加银行卡-说明"] forState:UIControlStateNormal];
            [button changeImageFrame:CGRectMake(24, 18, 16, 16)];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [listView addSubview:button];
        }
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(leftLabel.right, 0, kScreenW-100, 64)];
        textField.placeholder = place[i];
        textField.font = [UIFont systemFontOfSize:kTitleBigSize];
        [listView addSubview:textField];
        
        switch (i) {
            case 0:
                _nameTextField = textField;
                break;
            case 1:
                _bankTextField = textField;
                break;
            case 2:
                _cardTextField = textField;
                break;
            default:
                break;
        }
    }
    
    UILabel *alertLabel = [UILabel initWithTitle:@"*跳转网银支付前，请确认您提供的姓名、身份证号及银行卡号输入无误，如有疑问，请联系客服" withFont:kTextSize textColor:kNewDetailColor];
    alertLabel.numberOfLines = 0;
    alertLabel.frame = CGRectMake(15, label.bottom+27+64*3 + 21, kScreenW-30, 36);
    [self.view addSubview:alertLabel];
    
    UIButton *button = [UIButton newButtonWithTitle:@"下一步"  sel:@selector(nextButtonClick) target:self cornerRadius:NO];
    button.frame = CGRectMake((kScreenW-165)/2, alertLabel.bottom+30, 165, 44);
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)sender{
    
}

#pragma mark - 创建订单

- (void)llorder {
    _order = [[LLOrder alloc] initWithLLPayType:payType];
    NSString *timeStamp = [LLOrder timeStamp];
    _order.oid_partner = kLLOidPartner;  //商户号
    _order.sign_type = signType;         //签名方式
    _order.busi_partner = @"101001";     // 商户业务类型, 虚拟商品销售：101001
    
    NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
    NSInteger time = late1;
    NSString *orderID = [NSString stringWithFormat:@"%@%ld",self.orderID,(long)time];
    _order.no_order = orderID;  //商户唯一自定义订单号
    
    _order.dt_order = timeStamp;
    _order.money_order = self.money;
    _order.card_no = _bankTextField.text;
    _order.notify_url = [NSString stringWithFormat:@"%@payNotice/LianLian",kNewBaseApi];
    _order.acct_name = _nameTextField.text;         //用户名
    _order.id_no = _cardTextField.text;
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    _order.user_id = userId;
    _order.name_goods = self.orderInfo;
    
    if (_isNew) {
        _order.info_order =  [NSString stringWithFormat:@"{\"handler\":\"%@\",\"mobile\":\"%@\",\"userId\":\"%@\",\"should_pay_id\":\"%@\",\"name\":\"%@\",\"idCard\":\"%@\",\"bankCard\":\"%@\",\"orderId\":\"%@\",\"couponId\":\"%@\",\"score\":\"%@\",\"version\":\"v2\"}",_handler,@"",@"",_payType,_nameTextField.text,_cardTextField.text,_bankTextField.text,self.orderID,_couponId?_couponId:@"",_score];
    }else{
       _order.info_order =  [NSString stringWithFormat:@"{\"moneyType\":\"%@\",\"name\":\"%@\",\"idCard\":\"%@\",\"bankCard\":\"%@\",\"orderId\":\"%@\",\"couponId\":\"%@\",\"score\":\"%@\"}",_payType,_nameTextField.text,_cardTextField.text,_bankTextField.text,self.orderID,_couponId?_couponId:@"",_score];
    }
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kmobile];
    _order.risk_item = [LLOrder llJsonStringOfObj:@{@"2011": @"201707071001873535",@"B2C":@"rent_type",_cardTextField.text:@"lessee_idcard",phone:@"lessee_phone",@"0":@"lessee_idcard_type",@"330000":@"from_no_province",@"330100":@"from_no_city",@"330000":@"to_no_province",@"330100":@"to_no_city",}];
    _order.name_goods = self.orderInfo;                          //商品名
}
- (void)nextButtonClick{
    if ([_nameTextField.text isEqualToString:@""] || [_cardTextField.text isEqualToString:@""] || [_bankTextField.text isEqualToString:@""]) {
        [CustomTool alertViewShow:@"请将内容补充完整"];
        return;
    }
    
    BOOL phone = [CustomTool IsIdentityCard:_cardTextField.text];
    if (!phone) {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请输入正确的身份证号"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
        return;
    }
    
    BOOL bankCard = [CustomTool IsBankCard:_bankTextField.text];
    if (!bankCard) {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请输入正确的银行卡号"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
        return;
    }
    
    if (_nameTextField.userInteractionEnabled) {
        [HttpManage updataCreditName:_nameTextField.text withCardID:_cardTextField.text withSuccessfulBlock:^(NSString *str) {
            
        } withFailureBlock:^(NSString *failedData) {
            
        }];
    }
    
    [self llorder];
    self.resultTitle = @"支付结果";
    self.orderDic = [[_order tradeInfoForPayment] mutableCopy];
    LLPayUtil *payUtil = [[LLPayUtil alloc] init];
    // 进行签名
    NSDictionary *signedOrder = [payUtil signedOrderDic:self.orderDic andSignKey:kLLPartnerKey];
    
//    NSError *parseError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:signedOrder options:NSJSONWritingPrettyPrinted error:&parseError];
//
//    NSString *msgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [LLPaySdk sharedSdk].sdkDelegate = self;
    
    
    
    //接入什么产品就传什么LLPayType
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                              withPayType:LLPayTypeVerify
                                            andTraderInfo:signedOrder];
}

#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"异常";
    NSString *showMsg = dic[@"ret_msg"];
    switch (resultCode) {
        case kLLPayResultSuccess: {
            VFPaySuccessfulViewController *vc = [[VFPaySuccessfulViewController alloc]init];
            vc.orderId = self.orderID;
            vc.moneyType = self.payType;
            vc.payMoney = self.money;
            [self.navigationController pushViewController:vc animated:YES];
            msg = @"成功";
        } break;
        case kLLPayResultFail: {
            [self payFailedShowInfo:showMsg];
            msg = @"失败";
        } break;
        case kLLPayResultCancel: {
            [self payFailedShowInfo:showMsg];
            msg = @"取消";
        } break;
        case kLLPayResultInitError: {
            [self payFailedShowInfo:showMsg];
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            [self payFailedShowInfo:showMsg];
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.resultTitle
//                                                                   message:showMsg
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
//                                              style:UIAlertActionStyleDefault
//                                            handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
    //    [msg stringByAppendingString:[LLPayUtil jsonStringOfObj:dic]];
}

- (void)payFailedShowInfo:(NSString *)showInfo{
    VFpayfailureViewController *vc = [[VFpayfailureViewController alloc]init];
    vc.showInfo = showInfo;
    [self.navigationController pushViewController:vc animated:YES];
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
