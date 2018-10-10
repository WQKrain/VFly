//
//  LLAddNameAndCardIDViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "LLAddNameAndCardIDViewController.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"
#import "LLOrder.h"
#import "LoginModel.h"

@interface LLAddNameAndCardIDViewController ()<LLPaySdkDelegate>
@property (nonatomic , strong)NSArray *imageArr;
@property (nonatomic , strong)UITextField *nameTextField;
@property (nonatomic , strong)UITextField *cardTextField;
@property (nonatomic , strong)UITextField *bankTextField;

@property (nonatomic, strong) LLOrder *order;

@property (nonatomic, strong) NSString *resultTitle;
@property (nonatomic, retain) NSMutableDictionary *orderDic;

@end

static NSString *kLLOidPartner = @"201707071001873535";//@"201408071000001546";                 // 商户号
static NSString *kLLPartnerKey = @"威风出行最帅的吕佩刚";//@"201408071000001546_test_20140815";   // 密钥
static NSString *signType = @"MD5"; //签名方式

/*! 接入什么支付产品就改成那个支付产品的LLPayType，如快捷支付就是LLPayTypeQuick */

static LLPayType payType = LLPayTypeVerify;

/*！ 若是签约、认证、实名快捷、分期付等请填入以下内容 */
//static NSString *cardNumber = @"<#请填入卡号#>";  //卡号
//static NSString *acctName = @"";    //姓名
//static NSString *idNumber = @"";    //身份证号

@implementation LLAddNameAndCardIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息确认";
    self.view.backgroundColor = kBackgroundColor;
    _imageArr = @[[UIImage imageNamed:@"icon_user"],[UIImage imageNamed:@"icon_id"],[UIImage imageNamed:@"icon_bankcard"]];
    
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpManage getUserInfoWithToken:tokenStr withSuccessBlock:^(NSDictionary *dic) {
        LoginModel *model = [[LoginModel alloc]initWithDic:dic];
        _nameTextField.text = model.name;
        _cardTextField.text = model.card;
//        _bankTextField.text = model.bankCard;
        if ([model.name isEqualToString:@""] || [model.card isEqualToString:@""]) {
            _nameTextField.userInteractionEnabled = YES;
            _cardTextField.userInteractionEnabled = YES;
        }
        if ([model.bankCard isEqualToString:@""]) {
            _bankTextField.userInteractionEnabled = YES;
        }
    } withFailedBlock:^{
        [JSFProgressHUD hiddenHUD:self.view];
        [ProgressHUD showError:@"加载失败"];
    }];
    [self createView];
    
    [self llorder];
}

- (void)createView {
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64+i*41, kScreenW, 40)];
        view.backgroundColor = kWhiteColor;
        [self.view addSubview:view];
        
        UIImageView *iamge = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        iamge.image = _imageArr[i];
        [view addSubview:iamge];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, kScreenW-50, 40)];
        textField.userInteractionEnabled = NO;
        textField.font = [UIFont systemFontOfSize:kTextBigSize];
        
        if (i == 0) {
            _nameTextField = textField;
            _nameTextField.placeholder = @"请输入姓名";
        }else if (i == 1){
            _cardTextField = textField;
            _cardTextField.placeholder = @"请输入身份证号";
        }else {
            _bankTextField = textField;
            _bankTextField.placeholder = @"请输入银行卡号";
            textField.userInteractionEnabled = YES;
        }
        [view addSubview:textField];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 204, kScreenW-20, 40)];
    label.numberOfLines = 0;
    label.textColor = kdetailColor;
    label.font = [UIFont systemFontOfSize:kTextSize];
    label.text = @"*绑卡或支付,跳转银行卡支付前，请确认您提供的姓名及身份证号无误,如有疑问，请资讯客服";
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithTitle:@"确认" sel:@selector(LLPay) target:self];
    button.frame = CGRectMake(10, label.bottom+10, kScreenW-20, 40);
    [self.view addSubview:button];
}


#pragma mark - 创建订单

- (void)llorder {
    _order = [[LLOrder alloc] initWithLLPayType:payType];
    NSString *timeStamp = [LLOrder timeStamp];
    _order.oid_partner = kLLOidPartner;
    _order.sign_type = signType;
    _order.busi_partner = @"101001";
    _order.no_order = self.orderID;
    _order.dt_order = timeStamp;
    _order.money_order = self.money;
    _order.card_no = _bankTextField.text;
    _order.notify_url = [NSString stringWithFormat:@"%@payNotice/LianLian",kNewBaseApi];
    _order.acct_name = _nameTextField.text;         //用户名
//        _order.card_no = cardNumber;
    _order.id_no = _cardTextField.text;
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    _order.user_id = userId;
    _order.name_goods = self.orderInfo;
    NSString *name = [NSString stringWithFormat:@"\"%@\"",_nameTextField.text];
    _order.info_order =  [NSString stringWithFormat:@"{\"moneyType\":%@,\"name\":%@,\"idCard\":%@,\"bankCard\":%@}",_payType,name,_cardTextField.text,_bankTextField.text];
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kmobile];
    _order.risk_item = [LLOrder llJsonStringOfObj:@{@"2011": @"201707071001873535",@"B2C":@"rent_type",_cardTextField.text:@"lessee_idcard",phone:@"lessee_phone",@"0":@"lessee_idcard_type",@"330000":@"from_no_province",@"330100":@"from_no_city",@"330000":@"to_no_province",@"330100":@"to_no_city",}];
    _order.name_goods = self.orderInfo;                          //商品名
}
- (void)LLPay{
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
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:signedOrder options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *msgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"成功";
        } break;
        case kLLPayResultFail: {
            msg = @"失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"取消";
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    
    NSString *showMsg = dic[@"ret_msg"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.resultTitle
                                                                   message:showMsg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
//    [msg stringByAppendingString:[LLPayUtil jsonStringOfObj:dic]];
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
