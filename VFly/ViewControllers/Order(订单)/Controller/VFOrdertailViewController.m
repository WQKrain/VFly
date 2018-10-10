//
//  VFOrdertailViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFOrdertailViewController.h"
#import "MyOrderNewTableViewCell.h"
#import "VFOrderDetailAllMoneyTableViewCell.h"
#import "OrderDetailModel.h"
#import "VFOrderDetailPriceTableViewCell.h"

#import "VFEvaluationOrderViewController.h"
#import "VFContinueRentCarViewController.h"
#import "VFPayRemainingMoneyViewController.h"
//#import "VFChoosePayViewController.h"
#import "VFOldChoosePayViewController.h"
#import "VFOrderEvaluationModel.h"
#import "VFEvaluationTableViewCell.h"
#import "VFOrderDetailQRCodeView.h"
#import "VFBreaksTheDepositOrderDetailModel.h"
#import "ZJSwitch.h"

@interface VFOrdertailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    dispatch_group_t _groupEnter;
}
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@property (nonatomic , strong)UIView *adressView;
@property (nonatomic , strong)UILabel *addressNameLabel;
@property (nonatomic , strong)UILabel *topAddresslabel;
@property (nonatomic , strong)UILabel *topPhoneLabel;
@property (nonatomic , strong)OrderDetailModel *detailObj;


@property (nonatomic , strong)UIView *driveView;
@property (nonatomic , strong)UIView *pickUpCarView;
@property (nonatomic , strong)UILabel *topNameLabel;
@property (nonatomic , strong)UILabel *topMobileLabel;


@property (nonatomic , strong)NSString *status;
@property (nonatomic , strong)NSString *isEvaluation;
@property (nonatomic , strong)NSString *canRenew;
@property (nonatomic , strong)NSString *useEndTime;
@property (nonatomic , strong)VFOrderEvaluationModel *orderEvaluationModel;

@property (nonatomic , strong)NSArray *rightArr;
@property (nonatomic , strong)NSArray *leftDataArr;
@property (nonatomic , strong)NSArray *stateArr;
@property (nonatomic , strong)NSArray *moneyStatePay;
@property (nonatomic , strong)NSString *header;

@property (nonatomic , strong)ZJSwitch *switchCar;

@property (nonatomic , strong)UIView *payView;
@property (nonatomic , strong)UILabel *showPayMoney;
@property (nonatomic , strong)UIButton *payButton;

@property (nonatomic , strong)UILabel *showStateLabel;

@property (nonatomic , strong)UIView *bottomTwoButtonView;

@property (nonatomic , strong)UIButton *deleteButton;


@property (nonatomic , strong)VFBreaksTheDepositOrderDetailStateModel *breakDepositModel;
@property (nonatomic , strong)VFBreaksTheDepositOrderDetailModel *breakOrderModel;

@end

@implementation VFOrdertailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self loadAllData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"orderDetails";
    self.header = @"订单详情";
    [self createView];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)defaultRightBtnClick{
    if (_detailObj) {
        if ([_detailObj.type isEqualToString:@"1"]) {
//            弹出二维码
            VFOrderDetailQRCodeView *view = [[VFOrderDetailQRCodeView alloc]initWithOrderID:self.orderID isNew:NO];
            [view showXLAlertView];
        }
    }
}


- (void)defaultLeftBtnClick {
    if (_isBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)loadAllData{
    dispatch_queue_t queueEnter = dispatch_get_global_queue(0, 0);
    dispatch_async(queueEnter, ^{
        _groupEnter = dispatch_group_create();
        dispatch_group_async(_groupEnter, queueEnter, ^{
            [self loadBreaksTheDeposit];
        });
        //在请求中加入了dispatch_group_enter和dispatch_group_leave时,就可以放心使用AFN进行请求了.可以拿到前几个请求完成之后的参数再进行最后一个请求
        dispatch_group_notify(_groupEnter, queueEnter, ^{
            [self loadData];
        });
    });
}

- (void)loadBreaksTheDeposit{
    dispatch_group_enter(_groupEnter);
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpManage depositBreaksOrderDetailWithParameter:@{@"token":token,@"order_id":self.orderID} withSuccessBlock:^(NSDictionary *data) {
        _breakOrderModel = [[VFBreaksTheDepositOrderDetailModel alloc]initWithDic:data];
        _breakDepositModel = [[VFBreaksTheDepositOrderDetailStateModel alloc]initWithDic:_breakOrderModel.free_deposit];
        dispatch_group_leave(_groupEnter);
    } withFailureBlock:^(NSError *error) {
        dispatch_group_leave(_groupEnter);
    }];
}

- (void)loadData{
    kWeakSelf;
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage getOrderMessageWithOrderID:self.orderID With:^(NSDictionary *dic) {
        
        NSLog(@">>>>>>>>>>>>%@",dic);
        
        _detailObj = [[OrderDetailModel alloc]initWithDic:dic];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{

            NSString *serviceFee;
            if (_breakOrderModel.free_deposit) {
                if (_breakDepositModel.sign_bankcard) {
                    serviceFee = kFormat(@"¥%@", _breakDepositModel.service_fee);
                }else{
                    serviceFee = @"";
                }
            }else{
                serviceFee = @"";
            }
            
            if ([_detailObj.type isEqualToString:@"1"]) {
                UIImage *image = [UIImage imageNamed:@"icon_Qr_code"];
                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [weakSelf.rightButton setImage:image forState:UIControlStateNormal];
            }
            
            NSString *couponMoney = kFormat(@"-¥%.2f", [_detailObj.couponMoney floatValue]);
            NSString * scoreMoney = kFormat(@"-¥%.2f", [_detailObj.scoreMoney floatValue]);
            NSString * frontMoney = kFormat(@"¥%.2f", [_detailObj.frontMoney floatValue]);
            NSString *rentalMoney = kFormat(@"¥%.2f", [_detailObj.rentalMoney floatValue]);
            NSString * depositMoney = kFormat(@"¥%.2f", [_detailObj.depositMoney floatValue]);
            NSString * illegalMoney = kFormat(@"¥%.2f", [_detailObj.illegalMoney floatValue]);
            NSString * totalMoney = kFormat(@"¥%.2f", [_detailObj.totalMoney floatValue]);
            
            if (![_detailObj.status isEqualToString:@"1"]) {
            }else{
                if (![_detailObj.type isEqualToString:@"2"]) {
                    depositMoney = @"待评估";
                }
            }
            _rightArr = @[depositMoney,illegalMoney,frontMoney,rentalMoney,couponMoney,scoreMoney];
            
            NSString *title =@"";
            if ([_detailObj.is_free_deposit isEqualToString:@"1"]) {
                title = @"租金尾款(包含服务费)";
            }else{
                title = @"租金尾款";
            }
            
            _leftDataArr = @[@"押金",@"违章保证金",@"订金",title,@"优惠券减免",@"积分减免"];
            
            _stateArr = @[_detailObj.depositMoneyStatus,_detailObj.illegalMoneyStatus,_detailObj.frontMoneyStatus,_detailObj.rentalMoneyStatus,@"",@""];
            
            NSString *depositMoneyPay = kFormat(@"%.2f", [_detailObj.depositMoney floatValue]-[_detailObj.unpaidDepositMoney floatValue]);
            NSString *frontMoneyPay = kFormat(@"%.2f", [_detailObj.frontMoney floatValue]-[_detailObj.unpaidFrontMoney floatValue]);
            NSString *rentalMoneyPay = kFormat(@"%.2f", [_detailObj.rentalMoney floatValue]-[_detailObj.unpaidRentalMoney floatValue]);
            NSString *illegalMoneyPay = kFormat(@"%.2f", [_detailObj.illegalMoney floatValue]-[_detailObj.unpaidIllegalMoney floatValue]);
            _moneyStatePay = @[depositMoneyPay,illegalMoneyPay,frontMoneyPay,rentalMoneyPay,@"",@""];
            
            _topAddresslabel.text = _detailObj.address;
            _status  = _detailObj.status;
            _isEvaluation = _detailObj.isEvaluation;
            _canRenew = _detailObj.canRenew;
            _useEndTime = _detailObj.useEndTime;
            NSInteger status = [_status integerValue];
            
            if ([_detailObj.isEvaluation isEqualToString:@"1"]) {
                NSDictionary *parDic = @{@"orderId":weakSelf.orderID,@"token":[[NSUserDefaults standardUserDefaults]objectForKey:access_Token]};
                [HttpManage getOrderEvaluationParameter:parDic success:^(NSDictionary *data) {
                    _orderEvaluationModel= [[VFOrderEvaluationModel alloc]initWithDic:data];
                    [weakSelf.tableView reloadData];
                    [JSFProgressHUD hiddenHUD:self.view];
                } failedBlock:^(NSError *error) {
                    [JSFProgressHUD hiddenHUD:self.view];
                }];
            }else{
                [JSFProgressHUD hiddenHUD:self.view];
                [_tableView reloadData];
            }
            
            _payView.hidden = YES;
            _showStateLabel.hidden = YES;
            _bottomTwoButtonView.hidden = YES;
            _tableView.height = kScreenH-kNavBarH-49-kSafeBottomH;
            
            if ([_detailObj.canDel floatValue] == 0) {
                _deleteButton.hidden = YES;
            }else{
                _deleteButton.hidden = NO;
            }
            
            
            if ([_detailObj.getCarFunc isEqualToString:@"1"]) {
                if ([_detailObj.name isEqualToString:@""]) {
                    _topNameLabel.text = _detailObj.mobile;
                }else{
                    _topNameLabel.text = _detailObj.name;
                    _topMobileLabel.text = _detailObj.mobile;
                }
                _topAddresslabel.text = _detailObj.address;
                _pickUpCarView.hidden = NO;
                _driveView.hidden = YES;
                [_switchCar setOn:NO animated:YES];
            }else{
                _driveView.hidden = NO;
                _pickUpCarView.hidden = YES;
               
                if ([_detailObj.name isEqualToString:@""]) {
                    _addressNameLabel.text = _detailObj.mobile;
                }else{
                    _addressNameLabel.text = _detailObj.name;
                    _topPhoneLabel.text = _detailObj.mobile;
                }
                [_switchCar setOn:YES animated:YES];
            }
            
            if (status == 1) {
                _payView.hidden = NO;
                _showPayMoney.text = kFormat(@"当前需支付订金  ¥%@", _detailObj.payable);
            }else if (status == 3){
                if ([_detailObj.totalMoneyStatus isEqualToString:@"2"]) {
                    _showStateLabel.hidden = NO;
                    if ([_detailObj.getCarFunc isEqualToString:@"1"]) {
                        _showStateLabel.text = @"车辆已准备好，快来门店取车哦";
                    }else{
                        _showStateLabel.text = @"车辆很快送到您的身边哦";
                    }
                }else{
                    _payView.hidden = NO;
                    _showPayMoney.text = kFormat(@"当前需支付  ¥%@", _detailObj.payable);
                }
            }else if (status == 2){
                _showStateLabel.hidden = NO;
                _showStateLabel.text = @"正在为您准备车辆…";
            }else if (status == 4 || status == 5 || status == 6 || status == 7){
                _tableView.height = kScreenH-kNavBarH;
            }
            else if (status == 8){
                _bottomTwoButtonView.hidden = NO;
            }else if (status == 9 || status == 10 || status == 11 || status == 12 || status == 15){
                if ([_isEvaluation isEqualToString:@"0"]) {
                    _payView.hidden = NO;
                    _showPayMoney.text = @"还车成功，非常期待您的评价";
                    [_payButton setTitle:@"评价" forState:UIControlStateNormal];
                }else{
                    _tableView.height = kScreenH-kNavBarH;
                }
            }else if (status == 13 || status == 14){
                if ([_isEvaluation isEqualToString:@"0"]) {
                    _payView.hidden = NO;
                    _showPayMoney.text = @"还车成功，非常期待您的评价";
                    [_payButton setTitle:@"评价" forState:UIControlStateNormal];
                    
                }
            }else if (status == 16){
                _payView.hidden = NO;
                _showPayMoney.text = kFormat(@"当前需支付续租金额   ¥%@", _detailObj.payable);
                [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
            }else{
                
            }
        }];
    }];
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-48-kNavBarH-kSafeBottomH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MyOrderNewTableViewCell class] forCellReuseIdentifier:@"showCell"];
     [_tableView registerClass:[VFOrderDetailAllMoneyTableViewCell class] forCellReuseIdentifier:@"priceCell"];
    [_tableView registerClass:[VFOrderDetailPriceTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[VFEvaluationTableViewCell class] forCellReuseIdentifier:@"evaluationCell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = [self createAddressView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    _deleteButton.hidden = YES;
    [_deleteButton addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.rightButton);
        make.right.equalTo(self.rightButton.mas_left).offset(-15);
    }];
    
    //最下边的两个按钮
    _payView = [[UIView alloc]init];
    _payView.hidden = YES;
    [self.view addSubview:_payView];
    [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kSafeBottomH);
        make.height.mas_equalTo(49);
    }];

    _showPayMoney = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kWhiteColor];
    _showPayMoney.backgroundColor = kBarBgColor;
    _showPayMoney.textAlignment = NSTextAlignmentCenter;
    [_payView addSubview:_showPayMoney];
    [_showPayMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.right.mas_equalTo(-132);
    }];

    _payButton = [UIButton newButtonWithTitle:@"立即支付" sel:@selector(payButtonClcik) target:self cornerRadius:NO];
    [_payView addSubview:_payButton];
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(132);
        make.height.mas_equalTo(49);
    }];
    
    _showStateLabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kWhiteColor];
    _showStateLabel.hidden = YES;
    _showStateLabel.backgroundColor = kBarBgColor;
    _showStateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_showStateLabel];
    [_showStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-kSafeBottomH);
        make.height.mas_equalTo(49);
    }];
    
    //当下边为两个按钮时
    _bottomTwoButtonView = [[UIView alloc]init];
    [self.view addSubview:_bottomTwoButtonView];
    _bottomTwoButtonView.hidden = YES;
    [_bottomTwoButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-kSafeBottomH);
        make.height.mas_offset(49);
    }];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setTitle:@"申请续租" forState:UIControlStateNormal];
    [leftbutton setTitleColor:kMainColor forState:UIControlStateNormal];
    leftbutton.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [leftbutton addTarget:self action:@selector(continueRentCar) forControlEvents:UIControlEventTouchUpInside];
    [_bottomTwoButtonView addSubview:leftbutton];
    [leftbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_offset(0);
        make.width.mas_offset(kScreenW/2);
        make.height.mas_offset(49);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kMainColor;
    [_bottomTwoButtonView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(leftbutton);
        make.height.mas_offset(1);
    }];
    
    UIButton *rightButton = [UIButton newButtonWithTitle:@"确认还车" sel:@selector(returnCar) target:self cornerRadius:NO];
    [_bottomTwoButtonView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_offset(0);
        make.width.mas_offset(kScreenW/2);
        make.height.mas_offset(49);
    }];
}

- (void)payButtonClcik{
    NSInteger status = [_status integerValue];

    if (status == 1) {
        [self payDepositMoney];
    }else if (status == 3){
        [self payRemainingMoney];
    }else if (status == 9 || status == 10 || status == 11 || status == 12 || status == 13 || status == 14 || status == 15){
        if ([_isEvaluation isEqualToString:@"0"]) {
            [self evaluationRentCar];
        }
    }else if (status == 16){
        if ([_isEvaluation isEqualToString:@"0"]) {
        }else{
             [self continueRentCarPay];
        }
    }else{
       
    }
}


//续租支付
- (void)continueRentCarPay{
    VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
    vc.orderID = self.orderID;
    vc.moneyType = @"9";
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//删除订单
- (void)deleteOrder{
    kWeakSelf;
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定删除吗"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        [HttpManage orderDelParameter:@{@"token":token,@"orderId":self.orderID} success:^(NSDictionary *data) {
            HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
            if ([model.info isEqualToString:@"ok"]) {
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"删除成功"];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                
                [alertCtrl addAction:Action];
                [self presentViewController:alertCtrl animated:NO completion:nil];
            }else{
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.info];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
                [alertCtrl addAction:Action];
                [weakSelf presentViewController:alertCtrl animated:NO completion:nil];
            }
        } failedBlock:^(NSError *error) {
            
        }];
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//支付订金
- (void)payDepositMoney{
    VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
    vc.orderID = self.orderID;
    if ([_detailObj.type isEqualToString:@"2"]) {
        vc.moneyType = @"10";
    }else{
        vc.moneyType = @"1";
    }
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//支付尾款
- (void)payRemainingMoney{
    if ([_detailObj.totalMoneyStatus isEqualToString:@"0"]) {
        VFPayRemainingMoneyViewController *vc = [[VFPayRemainingMoneyViewController alloc]init];
        vc.orderID = self.orderID;
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"您已全部支付哦"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
    }
}

//还车
- (void)returnCar{
    kWeakSelf;
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定还车吗"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        [HttpManage confirmReturnCarParameter:@{@"token":token,@"orderId":self.orderID} success:^(NSDictionary *data) {
            HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
            if ([model.info isEqualToString:@"ok"]) {
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"还车申请已提交"];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
                [alertCtrl addAction:Action];
                [self presentViewController:alertCtrl animated:NO completion:nil];
                [weakSelf loadData];
            }else{
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.info];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
                [alertCtrl addAction:Action];
                [self presentViewController:alertCtrl animated:NO completion:nil];
            }
        } failedBlock:^(NSError *error) {
            
        }];
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//续租
- (void)continueRentCar{
    VFContinueRentCarViewController *vc = [[VFContinueRentCarViewController alloc]init];
    vc.orderID = self.orderID;
    vc.endTimeStr = _useEndTime;
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//评价
- (void)evaluationRentCar{
    VFEvaluationOrderViewController *vc = [[VFEvaluationOrderViewController alloc]init];
    vc.orderID = self.orderID;
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)createAddressView{
    _adressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 172)];
    _adressView.backgroundColor = kWhiteColor;
    
    UILabel *label = [UILabel initWithNavTitle:_header];
    label.frame = CGRectMake(15, 24, kScreenW-30, 42);
    label.font = [UIFont fontWithName:kBlodFont size:kNewBigTitle];
    [_adressView addSubview:label];
    
    _driveView = [[UIView alloc]init];
    _driveView.hidden = YES;
    [_adressView addSubview:_driveView];
    [_driveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(66);
        make.height.mas_offset(90);
    }];
   
    _addressNameLabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kTitleBoldColor];
    [_driveView addSubview:_addressNameLabel];
    [_addressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(20);
        make.height.mas_offset(20);
    }];
    
    _topAddresslabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kTitleBoldColor];
    [_driveView addSubview:_topAddresslabel];
    [_topAddresslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-138);
        make.top.equalTo(_addressNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    _topPhoneLabel =[UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kTitleBoldColor];
    _topPhoneLabel.textAlignment = NSTextAlignmentRight;
    [_driveView addSubview:_topPhoneLabel];
    [_topPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-138);
        make.top.equalTo(_addressNameLabel);
        make.height.mas_equalTo(_addressNameLabel);
    }];
    
    _pickUpCarView = [[UIView alloc]init];
    _pickUpCarView.hidden = YES;
    [_adressView addSubview:_pickUpCarView];
    [_pickUpCarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(66);
        make.height.mas_offset(90);
    }];
    
    UILabel *topName = [UILabel initWithTitle:@"姓名" withFont:kTextBigSize textColor:kTitleBoldColor];
    [_pickUpCarView addSubview:topName];
    [topName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(20);
        make.height.mas_offset(20);
    }];
    
    UILabel *topMobile = [UILabel initWithTitle:@"电话" withFont:kTextBigSize textColor:kTitleBoldColor];
    [_pickUpCarView addSubview:topMobile];
    [topMobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(topName.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    
    _topNameLabel = [UILabel initWithTitle:@"123" withFont:kTextBigSize textColor:kTitleBoldColor];
    [_pickUpCarView addSubview:_topNameLabel];
    [_topNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topName.mas_right).offset(15);
        make.top.mas_offset(20);
        make.height.mas_offset(20);
    }];
    
    _topMobileLabel = [UILabel initWithTitle:@"123" withFont:kTextBigSize textColor:kTitleBoldColor];
    [_pickUpCarView addSubview:_topMobileLabel];
    [_topMobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topNameLabel);
        make.top.equalTo(_addressNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 156, kScreenW, 2)];
    lineImage.image = [UIImage imageNamed:@"image_address_line"];
    [_adressView addSubview:lineImage];
    
    _switchCar = [[ZJSwitch alloc] init];
    _switchCar.backgroundColor = [UIColor clearColor];
    _switchCar.tintColor = kNewDetailColor;
    _switchCar.onTintColor = kNewDetailColor;
    _switchCar.userInteractionEnabled = NO;
    _switchCar.onText = @"送上门";
    _switchCar.offText = @"到店取";
    [_switchCar setOn:YES animated:NO];
    [_adressView addSubview:_switchCar];
    [_switchCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(101);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(20);
    }];
    
    return _adressView;
}


- (void)buttonClick{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return _moneyStatePay.count+1;
    }else{
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_isEvaluation isEqualToString:@"1"]) {
        return 3;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 347;
    }else if (indexPath.section == 1){

        if (indexPath.row !=6) {
            
            switch (indexPath.row) {
                case 1:
                    return 59;
                    break;
                case 4:
                    if ([_detailObj.couponMoney intValue] == 0) {
                        return 0;
                    }
                    break;
                case 5:
                    if ([_detailObj.scoreMoney intValue] == 0) {
                        return 0;
                    }
                    break;
                    
                default:
                    break;
            }
            return 40;
        }else{
            return 103;
        }
        
        
    }else if (indexPath.section == 2){
        CGSize titleSize = [_orderEvaluationModel.evaluationContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        NSInteger row = _orderEvaluationModel.images.count/3;
        if (_orderEvaluationModel.images.count%3>0) {
            row = _orderEvaluationModel.images.count/3+1;
        }
        return 293+titleSize.height+(((kScreenW-60)/3+15)*row);
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyOrderNewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"showCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"showCell"];
        }
        cell.detailModel = _detailObj;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 6) {
            VFOrderDetailAllMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
            if (cell == nil) {
                cell=[[VFOrderDetailAllMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
                      kFormat(@"%zi%zi", indexPath.section,indexPath.row)];
            }
            if (_detailObj) {
                cell.oldModel = _detailObj;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            VFOrderDetailPriceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell=[[VFOrderDetailPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
                      kFormat(@"%zi%zi", indexPath.section,indexPath.row)];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (_detailObj) {
                if (indexPath.row <6) {
                    cell.leftlabel.text = _leftDataArr[indexPath.row];
                    if ([_stateArr[indexPath.row] isEqualToString:@"2"]) {
                        if (indexPath.row !=0) {
                            cell.leftImage.image = [UIImage imageNamed:@"label_PayAll_part1"];
                            cell.stateLabel.text = @"已付清";
                            cell.stateLabel.backgroundColor = kTitleBoldColor;
                        }else{
                            if ([_detailObj.status floatValue]>2) {
                                cell.leftImage.image = [UIImage imageNamed:@"label_PayAll_part1"];
                                cell.stateLabel.text = @"已付清";
                                cell.stateLabel.backgroundColor = kTitleBoldColor;
                            }
                        }
                    }else{
                        if (indexPath.row<4) {
                            if ([_moneyStatePay[indexPath.row] floatValue]>0) {
                                cell.leftImage.image = [UIImage imageNamed:@"label_PayPortion_part1"];
                                cell.stateLabel.text = kFormat(@"已付¥%@",_moneyStatePay[indexPath.row]);
                                cell.stateLabel.backgroundColor = kTextBlueColor;
                            }else{
                                cell.leftImage.image = [UIImage imageNamed:@""];
                                cell.stateLabel.text = @"";
                            }
                        }
                    }
                    
                    if (indexPath.row ==0) {
                        if ([_detailObj.status floatValue]>2) {
                            if (_breakOrderModel.free_deposit) {
                                cell.leftImage.image = [UIImage imageNamed:@"label_PayAll_part1"];
                                cell.stateLabel.text = @"已通过押金渠道减免";
                                cell.stateLabel.backgroundColor = kTitleBoldColor;
                            }
                        }
                    }
                    
                    if ([_rightArr[indexPath.row] isEqualToString:@""]) {
                        cell.rightlabel.text = @" ";
                    }else{
                        if (indexPath.row<4) {
                            cell.rightlabel.textColor = kdetailColor;
                        }else{
                            cell.rightlabel.textColor = kMainColor;
                        }
                        cell.rightlabel.text = _rightArr[indexPath.row];
                    }
                }else{
                    
                    cell.leftlabel.textColor = kdetailColor;
                    cell.leftlabel.font = [UIFont systemFontOfSize:kNewTitle];
                    if ([_detailObj.status isEqualToString:@"16"]) {
                        cell.textLabel.text = kFormat(@"续租待支付 ¥%@", _detailObj.payable);
                    }else{
                        cell.leftlabel.text = kFormat(@"当前需支付 ¥%@", _detailObj.payable);
                    }
                    NSRange moneyLabelRange = [cell.leftlabel.text rangeOfString:@"¥"];
                    [CustomTool setTextColor:cell.leftlabel FontNumber:[UIFont systemFontOfSize:kTitleSize] AndRange:moneyLabelRange AndColor:kdetailColor];
                }
            }
            
            switch (indexPath.row) {
                case 4:
                    if ([_detailObj.couponMoney intValue] == 0) {
                        cell.hidden = YES;
                    }else{
                        cell.hidden = NO;
                    }
                    break;
                case 5:
                    if ([_detailObj.scoreMoney intValue] == 0) {
                        cell.hidden = YES;
                    }else{
                        cell.hidden = NO;
                    }
                    break;
            }
            
            if (indexPath.row == 1) {
                cell.needLine = YES;
            }else{
                cell.needLine = NO;
            }
            
            return cell;
        }
        
    }else{
        VFEvaluationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"evaluationCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"evaluationCell"];
        }
        cell.model = _orderEvaluationModel;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
