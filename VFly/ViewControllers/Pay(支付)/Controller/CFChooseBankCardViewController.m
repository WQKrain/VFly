//
//  CFChooseBankCardViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "CFChooseBankCardViewController.h"
#import "showBankModel.h"
#import "ShowBankTableViewCell.h"
#import "MyBankCardModel.h"
#import "VFAddBankCardViewController.h"
#import "VFPaySuccessfulViewController.h"
#import "VFpayfailureViewController.h"

#import "ChooseBankViewController.h"

#import "anyButton.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"
#import "LLOrder.h"

@interface CFChooseBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,LLPaySdkDelegate>
@property (nonatomic, strong)UIView *viewBg;
@property (nonatomic, strong)UITextField *passWdTF;
@property (nonatomic, strong)BaseTableView *tableView;
@property (nonatomic, strong)NSArray *dataArr;

@property (nonatomic, strong) LLOrder *order;
@property (nonatomic, strong) NSString *resultTitle;
@property (nonatomic, retain) NSMutableDictionary *orderDic;
@property (nonatomic ,strong)NSString *header;

@end

static NSString *kLLOidPartner = @"201707071001873535";//@"201408071000001546";                 // 商户号
static NSString *kLLPartnerKey = @"威风出行最帅的吕佩刚";//@"201408071000001546_test_20140815";   // 密钥
static NSString *signType = @"MD5"; //签名方式
static LLPayType payType = LLPayTypeVerify;

@implementation CFChooseBankCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"选择银行卡";
    [self loadData];
    [self createView];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)loadData{
    
    if (_isNew) {
        [VFHttpRequest getBankCardListSuccessBlock:^(NSDictionary *data) {
            VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            if ([model.code intValue] == 1) {
                for (NSDictionary *dic in model.data) {
                    MyBankCardListModel *obj = [[MyBankCardListModel alloc]initWithDic:dic];
                    [tempArr addObject:obj];
                }
                _dataArr = tempArr;
                [self.tableView reloadData];
            }
        } withFailureBlock:^(NSError *error) {
            
        }];
    }else{
        
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        NSDictionary *dic = @{@"page":@"0",@"limit":@"10",@"token":token};
        [JSFProgressHUD showHUDToView:self.view];
        [HttpManage getBankCardListParameter:dic Success:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            MyBankCardModel *model = [[MyBankCardModel alloc]initWithDic:data];
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in model.bankCardList) {
                MyBankCardListModel *obj = [[MyBankCardListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            _dataArr = tempArr;
            [self.tableView reloadData];
        } failedBlock:^{
            [JSFProgressHUD hiddenHUD:self.view];
        }];
        
    }
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.header = _header;
    [_tableView registerClass:[ShowBankTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowBankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    
    MyBankCardListModel *model = _dataArr[indexPath.row];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    NSString *cardnumber = model.bankCard;
    NSString *card = [cardnumber substringFromIndex:cardnumber.length - 4];
    cell.topLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.bank,card];
    cell.detaillabel.text = model.brief;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBankCardListModel *model = _dataArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self llorderName:model.name bankCard:model.bankCard userID:model.card];
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


#pragma mark - 创建订单

- (void)llorderName:(NSString*)name bankCard:(NSString *)bankCard userID:(NSString *)userID{
    _order = [[LLOrder alloc] initWithLLPayType:payType];
    NSString *timeStamp = [LLOrder timeStamp];
    _order.oid_partner = kLLOidPartner;
    _order.sign_type = signType;
    _order.busi_partner = @"101001";
    
    NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
    NSInteger time = late1;
    NSString *orderID = [NSString stringWithFormat:@"%@%ld",self.orderID,(long)time];
    _order.no_order = orderID;  //商户自定义订单号
    
    _order.dt_order = timeStamp;
    _order.money_order = self.money;
    _order.card_no = bankCard;
    _order.notify_url = [NSString stringWithFormat:@"%@payNotice/LianLian",kNewBaseApi];
    _order.acct_name = name;         //用户名
    //        _order.card_no = cardNumber;
    _order.id_no = userID;
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    _order.user_id = userId;
    _order.name_goods = self.orderInfo;
    
    if (_isNew) {
        _order.info_order =  [NSString stringWithFormat:@"{\"handler\":\"%@\",\"mobile\":\"%@\",\"userId\":\"%@\",\"should_pay_id\":\"%@\",\"name\":\"%@\",\"idCard\":\"%@\",\"bankCard\":\"%@\",\"orderId\":\"%@\",\"couponId\":\"%@\",\"score\":\"%@\",\"version\":\"v2\"}",_handler,@"",@"",_moneyType,name,userID,bankCard,self.orderID,_useCouponsID?_useCouponsID:@"",_score];
    }else{
        _order.info_order =  [NSString stringWithFormat:@"{\"moneyType\":\"%@\",\"name\":\"%@\",\"idCard\":\"%@\",\"bankCard\":\"%@\",\"orderId\":\"%@\",\"couponId\":\"%@\",\"score\":\"%@\"}",_moneyType,name,userID,bankCard,self.orderID,_useCouponsID?_useCouponsID:@"",_score];
    }
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kmobile];
    _order.risk_item = [LLOrder llJsonStringOfObj:@{@"2011": @"201707071001873535",@"B2C":@"rent_type",userID:@"lessee_idcard",phone:@"lessee_phone",@"0":@"lessee_idcard_type",@"330000":@"from_no_province",@"330100":@"from_no_city",@"330000":@"to_no_province",@"330100":@"to_no_city",}];
    _order.name_goods = self.orderInfo;                          //商品名
}

#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    
    NSString *msg = @"异常";
    NSString *showMsg = dic[@"ret_msg"];
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"成功";
            VFPaySuccessfulViewController *vc = [[VFPaySuccessfulViewController alloc]init];
            vc.orderId = self.orderID;
            vc.moneyType = self.moneyType;
            vc.payMoney = self.money;
            [self.navigationController pushViewController:vc animated:YES];
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

}

- (void)payFailedShowInfo:(NSString *)showInfo{
    VFpayfailureViewController *vc = [[VFpayfailureViewController alloc]init];
    vc.showInfo = showInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 49)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenW, 47)];
    [bottomView addSubview:bgView];
    bgView.backgroundColor = kWhiteColor;
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 22, 22)];
    leftImage.image = [UIImage imageNamed:@"icon_black_add"];
    [bgView addSubview:leftImage];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(leftImage.right+10, 0, 200, 47)];
    label.text = @"添加银行卡付款";
    label.font = [UIFont systemFontOfSize:kTitleBigSize];
    [bgView addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame= CGRectMake(0, 0, kScreenW, bgView.height);
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    return bottomView;
}

- (void)btnClick:(UIButton *)sender{
    ChooseBankViewController *vc = [[ChooseBankViewController alloc]init];
    vc.orderInfo = self.orderInfo;
    vc.payType = self.moneyType;
    vc.orderID = self.orderID;
    vc.money = self.money;
    vc.couponId = _useCouponsID;
    vc.score = _score;
    vc.isNew = _isNew;
    vc.handler = _handler;
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
