//
//  VFNewOrderDetailViewController.m
//  VFly
//
//  Created by Hcar on 2018/4/16.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFNewOrderDetailViewController.h"
#import "VFOrderDetailModel.h"
#import "MyOrderNewTableViewCell.h"
#import "VFOrderDetailAllMoneyTableViewCell.h"
#import "VFOrderDetailPriceTableViewCell.h"

#import "VFEvaluationOrderViewController.h"
#import "VFContinueRentCarViewController.h"
#import "VFPayRemainingMoneyViewController.h"
#import "VFChoosePayViewController.h"
#import "VFOrderEvaluationModel.h"
#import "VFEvaluationTableViewCell.h"
#import "VFOrderDetailQRCodeView.h"
#import "VFBreaksTheDepositOrderDetailModel.h"
#import "ZJSwitch.h"

#import "VFOrderListTableViewCell.h"

#import "VFOrderDetailPayView.h"
#import "VFAddUseCarUserViewController.h"
#import "WebViewVC.h"

#import "VFIdentityAuthenticationViewController.h"

#import "VFNewRenewalViewController.h"

@interface VFNewOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    dispatch_group_t _groupEnter;
}
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)NSString *header;
@property (nonatomic , strong)VFOrderDetailModel *detailObj;

@property (nonatomic , strong)UIView *adressView;
@property (nonatomic , strong)UILabel *addressNameLabel;
@property (nonatomic , strong)UILabel *topAddresslabel;
@property (nonatomic , strong)UILabel *topPhoneLabel;


@property (nonatomic , strong)UIView *driveView;
@property (nonatomic , strong)UIView *pickUpCarView;
@property (nonatomic , strong)UILabel *topNameLabel;
@property (nonatomic , strong)UILabel *topMobileLabel;


@property (nonatomic , strong)NSString * status;
@property (nonatomic , strong)NSString * isEvaluation;
@property (nonatomic , strong)NSString * canRenew;
@property (nonatomic , strong)NSString * useEndTime;
@property (nonatomic , strong)VFOrderEvaluationModel *orderEvaluationModel;

@property (nonatomic , strong)NSArray *rightArr;
@property (nonatomic , strong)NSArray *leftDataArr;
@property (nonatomic , strong)NSArray *stateArr;
@property (nonatomic , strong)NSArray *moneyStatePay;

@property (nonatomic , strong)ZJSwitch *switchCar;

@property (nonatomic , strong)UIView *payView;
@property (nonatomic , strong)UILabel *showPayMoney;
@property (nonatomic , strong)UIButton *payButton;

@property (nonatomic , strong)UILabel *showStateLabel;
@property (nonatomic , strong)UIView *bottomTwoButtonView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *bottomOneButtonView;
@property (nonatomic, strong) UIButton *rentButton;

@property (nonatomic , strong)NSMutableArray *payMoneyArr;


@property (nonatomic , strong)VFBreaksTheDepositOrderDetailStateModel *breakDepositModel;
@property (nonatomic , strong)VFBreaksTheDepositOrderDetailModel *breakOrderModel;

@property (nonatomic , strong)UIButton *headerButton;

@end

@implementation VFNewOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"订单详情";
    [self createView];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)defaultLeftBtnClick {
    if (_isBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-48-kNavBarH-kSafeBottomH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[VFOrderListTableViewCell class] forCellReuseIdentifier:@"showCell"];
    [_tableView registerClass:[VFOrderDetailAllMoneyTableViewCell class] forCellReuseIdentifier:@"priceCell"];
    [_tableView registerClass:[VFOrderDetailPriceTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[VFEvaluationTableViewCell class] forCellReuseIdentifier:@"evaluationCell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setTableHeaderView:[self createAddressView]];
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
    

    //只有一个按钮，申请续租
    _bottomOneButtonView = [[UIView alloc]init];
    [self.view addSubview:_bottomOneButtonView];
    _bottomOneButtonView.hidden = YES;
    [_bottomOneButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-kSafeBottomH);
        make.height.mas_offset(49);
    }];
    
    UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rentButton setTitle:@"申请续租" forState:UIControlStateNormal];
    [rentButton setTitleColor:kMainColor forState:UIControlStateNormal];
    rentButton.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [rentButton addTarget:self action:@selector(continueRentCar) forControlEvents:UIControlEventTouchUpInside];
    [_bottomOneButtonView addSubview:rentButton];
    [rentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_offset(0);
        make.width.mas_offset(kScreenW);
        make.height.mas_offset(49);
    }];
    
    UIView *line2View = [[UIView alloc]init];
    line2View.backgroundColor = kMainColor;
    [_bottomOneButtonView addSubview:line2View];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(rentButton);
        make.height.mas_offset(1);
    }];

    
}

//续租
- (void)continueRentCar{
    VFNewRenewalViewController *vc = [[VFNewRenewalViewController alloc]init];
    vc.orderID = self.orderID;
    if ([_detailObj.canRenew intValue] != 1) {
        vc.canPay = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//还车
- (void)returnCar{
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定还车吗"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    kWeakSelf;
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        [JSFProgressHUD showHUDToView:self.view];
        [VFHttpRequest carReturnOrderID:self.orderID successBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            [EasyTextView showSuccessText:@"提交成功"];
            [weakSelf loadData];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
            [ProgressHUD showError:@"提交失败"];
        }];
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//评价
- (void)evaluationRentCar:(NSString *)orderID{
    VFEvaluationOrderViewController *vc = [[VFEvaluationOrderViewController alloc]init];
    vc.orderID = orderID;
    vc.isNew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)payButtonClcik {
    NSInteger status = [_status integerValue];
    
    if (status == 101)
    {
        [self payDepositMoney];
    }
    else if (status == 211)
    {
        [self payRemainingMoney];
    }
    else if (status == 311)
    {
        [self evaluationRentCar:_orderID];
    }
    else if (status == 321)
    {
        [self payRemainingMoney];
//        [self evaluationRentCar:_orderID];
    }
    else
    {
    }
}

//支付尾款
- (void)payRemainingMoney {
    VFPayRemainingMoneyViewController *vc = [[VFPayRemainingMoneyViewController alloc]init];
    vc.orderID = self.orderID;
    vc.isNew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//支付订金
- (void)payDepositMoney {
    VFChoosePayViewController *vc = [[VFChoosePayViewController alloc]init];
    vc.orderID = self.orderID;
    VFOrderDetailPayModel * obj = _payMoneyArr[0];
    vc.moneyType = obj.should_pay_id;
    vc.payType = obj.pay_type;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
    {
        return  _detailObj.money.count+1;
    }
    else
    {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isEvaluation == 1) {
        return 3;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        return 347;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row != _detailObj.money.count)
        {
            return 40;
        }
        else
        {
            return 103;
        }
    }
    else if (indexPath.section == 2)
    {
        CGSize titleSize = [_orderEvaluationModel.evaluationContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        NSInteger row = _orderEvaluationModel.images.count/3;
        if (_orderEvaluationModel.images.count%3>0)
        {
            row = _orderEvaluationModel.images.count/3+1;
        }
        return 293+titleSize.height+(((kScreenW-60)/3+15)*row);
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        VFOrderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"showCell"];
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"showCell"];
        }
        cell.detailModel = _detailObj;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == _detailObj.money.count+1)
        {
            VFOrderDetailAllMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
            if (cell == nil)
            {
                cell=[[VFOrderDetailAllMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
                      kFormat(@"%zi%zi", indexPath.section,indexPath.row)];
            }
            if (_detailObj)
            {
                cell.model = _detailObj;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            VFOrderDetailPriceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell=[[VFOrderDetailPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
                      kFormat(@"%zi%zi", indexPath.section,indexPath.row)];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            if (_detailObj)
            {
                if (indexPath.row < _detailObj.money.count) {
                    
                    VFOrderDetailPayModel * obj = _payMoneyArr[indexPath.row];
                    cell.leftlabel.text = obj.item;
                    if ([obj.should_pay floatValue]-[obj.payed floatValue] == 0) {
                        cell.leftImage.image = [UIImage imageNamed:@"label_PayAll_part1"];
                        cell.stateLabel.text = @"已付清";
                        cell.stateLabel.backgroundColor = kTitleBoldColor;
                    }else{
                        cell.leftImage.image = [UIImage imageNamed:@"label_PayPortion_part1"];
                        cell.stateLabel.text = kFormat(@"已付¥%@",obj.payed);
                        cell.stateLabel.backgroundColor = kTextBlueColor;
                    }
                    cell.rightlabel.textColor = kdetailColor;
                    cell.rightlabel.text = kFormat(@"¥%@", obj.should_pay);
                    
                }else{
                    VFOrderDetailAllMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
                    if (cell == nil)
                    {
                        cell=[[VFOrderDetailAllMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
                              kFormat(@"%zi%zi", indexPath.section,indexPath.row)];
                    }
                    if (_detailObj)
                    {
                        cell.model = _detailObj;
                    }
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            return cell;
        }
        
    }
    else
    {
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
    if (indexPath.section == 1) {
        
        if (indexPath.row == _detailObj.money.count) {
            return;
        }
        VFOrderDetailPayModel *model = [[VFOrderDetailPayModel alloc]initWithDic:_detailObj.money[indexPath.row]];
        if (model.lists.count != 0) {
            VFOrderDetailPayView *view = [[VFOrderDetailPayView alloc]init];
            [view show:model];
        }
    }
}

- (UIView *)createAddressView{
    if (!_adressView) {
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
        
        UIImageView *lineImage = [[UIImageView alloc]init];
        lineImage.image = [UIImage imageNamed:@"image_line"];
        [_adressView addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
            make.height.mas_equalTo(2);
        }];
        
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
        
        _headerButton = [UIButton buttonWithTitle:@"点击完善用车人身份证、驾照信息"];
        [_adressView addSubview:_headerButton];
        [_headerButton addTarget:self action:@selector(headerButtonClcik) forControlEvents:UIControlEventTouchUpInside];
        [_headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-30);
            make.height.mas_equalTo(36);
        }];
        _headerButton.hidden = YES;
    }
    return _adressView;
}


- (void)loadData{
    kWeakSelf;
    [VFHttpRequest getOrderDetailParameter:_orderID SuccessBlock:^(NSDictionary *data) {
        
        NSLog(@">>>>>>>>>>>>>>>%@",data);
    
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        _detailObj = [[VFOrderDetailModel alloc]initWithDic:model.data];
        _payMoneyArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in _detailObj.money)
        {
            VFOrderDetailPayModel * obj = [[VFOrderDetailPayModel alloc]initWithDic:dic];
            [_payMoneyArr addObject:obj];
        }
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if ([_detailObj.canDel isEqualToString:@"0"])
            {
                _deleteButton.hidden = YES;
            }
            else
            {
                _deleteButton.hidden = NO;
            }
            VFOrderDetailUsemanModel *model =  [[VFOrderDetailUsemanModel alloc]initWithDic:_detailObj.useman];
            if ([_detailObj.get_func isEqualToString:@"1"])
            {
                _topNameLabel.text = model.nick_name;
                _topMobileLabel.text = model.mobile;
                _pickUpCarView.hidden = NO;
                _driveView.hidden = YES;
                [_switchCar setOn:NO animated:YES];
            }
            else
            {
                _driveView.hidden = NO;
                _pickUpCarView.hidden = YES;
                _addressNameLabel.text = model.nick_name;
                _topPhoneLabel.text = model.mobile;
                _topAddresslabel.text = _detailObj.sent_address;
                [_switchCar setOn:YES animated:YES];
            }
            
            UIImage *image = [UIImage imageNamed:@"icon_Qr_code"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [weakSelf.rightButton setImage:image forState:UIControlStateNormal];
            
            
            _status =
            _status = _detailObj.status;
            _isEvaluation = _detailObj.canEvaluation;
            _canRenew = _detailObj.canRenew;
            _useEndTime = _detailObj.end_date;
            NSInteger status = [_status integerValue];
            [weakSelf.tableView reloadData];
            if (_detailObj.canEvaluation)
            {

            }
            else
            {
                [JSFProgressHUD hiddenHUD:self.view];
                [_tableView reloadData];
            }
            
            _payView.hidden = YES;
            _showStateLabel.hidden = YES;
            _bottomTwoButtonView.hidden = YES;
            _tableView.height = kScreenH-kNavBarH-49-kSafeBottomH;
            
            
            if ([_detailObj.get_func isEqualToString:@"1"]) {
                _pickUpCarView.hidden = NO;
                _driveView.hidden = YES;
                [_switchCar setOn:NO animated:YES];
               
            }else{
                _driveView.hidden = NO;
                _pickUpCarView.hidden = YES;
                [_switchCar setOn:YES animated:YES];
            }
            
            
            //应对不同的返回值
            if (status == 101)
            {
                _payView.hidden = NO;
                _showPayMoney.text = kFormat(@"当前需支付订金  ¥%@", _detailObj.unpaid);
            }
            else if (status == 201)
            {
                _showStateLabel.hidden = NO;
                _showStateLabel.text = @"正在为您准备车辆…";
            }
            else if (status == 211)
            {
                if ([_detailObj.canPay isEqualToString:@"0"]) {
                    _showStateLabel.hidden = NO;
                    if ([_detailObj.get_func isEqualToString:@"1"]) {
                        _showStateLabel.text = @"车辆已准备好，快来门店取车哦";
                    }else{
                        _showStateLabel.text = @"车辆很快送到您的身边哦";
                    } 
                }else{
                    _payView.hidden = NO;
                    _showPayMoney.text = kFormat(@"当前需支付  ¥%@", _detailObj.unpaid);
                }
            }
            else if (status == 221)
            {
                _bottomTwoButtonView.hidden = NO;
            }
            else if (status == 231)
            {
                _bottomOneButtonView.hidden = NO;
            }
            else if (status == 251)
            {
                _showStateLabel.hidden = NO;
                _showStateLabel.text = @"工作人员审核中...";
                
            }
            else if (status == 256)
            {
                _showStateLabel.hidden = NO;
                _showStateLabel.text = @"工作人员审核中...";
            }
            else if (status == 261)
            {
                _showStateLabel.hidden = NO;
                _showStateLabel.text = @"工作人员审核中...";
            }
            else if (status == 311)
            {
                if ([_isEvaluation isEqualToString:@"1"]) {
                    _payView.hidden = NO;
                    _showPayMoney.text = @"还车成功，非常期待您的评价";
                    [_payButton setTitle:@"评价" forState:UIControlStateNormal];
                }
                else
                {
                    _tableView.height = kScreenH-kNavBarH;
                }
            }
            else if (status == 321)
            {
                if ([_detailObj.unpaid integerValue] == 0)
                {
                    if ([_isEvaluation isEqualToString:@"1"])
                    {
                        _payView.hidden = NO;
                        _showPayMoney.text = @"还车成功，非常期待您的评价";
                        [_payButton setTitle:@"评价" forState:UIControlStateNormal];
                    }
                    else
                    {
                        _tableView.height = kScreenH-kNavBarH;
                    }
                }
                else
                {
                    _payView.hidden = NO;
                    _showPayMoney.text = kFormat(@"当前需支付订金  ¥%@", _detailObj.unpaid);
                }
            }
            
            VFOrderDetailUsemanModel *obj = [[VFOrderDetailUsemanModel alloc]initWithDic:_detailObj.useman];
            if ([obj.card_status intValue] ==1 &&  [obj.driving_licence_status intValue] == 1)
            {
                [_headerButton setTitle:@"完善用车人信息" forState:UIControlStateNormal];
                _adressView.height = 172 + 51;
                _headerButton.hidden = NO;
            }
            else
            {
                if ([_detailObj.free_deposit isEqualToString:@"1"]) {
                    _adressView.height = 172 + 51;
                    [_headerButton setTitle:@"点击完善用车人身份证、驾照信息" forState:UIControlStateNormal];
                    _headerButton.hidden = NO;
                }else{
                    _adressView.height = 172;
                    _headerButton.hidden = YES;
                }
            }
            
            [weakSelf.tableView setTableHeaderView:_adressView];
            
        }];
    } withFailureBlock:^(NSError *error) {
        
    }];
}


- (void)headerButtonClcik{
    VFOrderDetailUsemanModel *obj = [[VFOrderDetailUsemanModel alloc]initWithDic:_detailObj.useman];
    if ([obj.card_status intValue] ==1 && [obj.driving_licence_status intValue] == 1) {
        WebViewVC *vc = [[WebViewVC alloc]init];
        VFOrderDetailUsemanModel *model =  [[VFOrderDetailUsemanModel alloc]initWithDic:_detailObj.useman];
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        vc.urlStr = kFormat(@"https://wechat.weifengchuxing.com/forApp/noDeposit_v2/noDeposit.html?order_id=%@&useman_id=%@&token=%@&test=1",_orderID,model.useman_id, token);
        vc.needToken = YES;
        vc.noNav = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        VFIdentityAuthenticationViewController *vc = [[VFIdentityAuthenticationViewController alloc]init];
        vc.userID = obj.useman_id;
        vc.card_status = obj.card_status;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)defaultRightBtnClick{
    if (_detailObj)
    {
        VFOrderDetailQRCodeView *view = [[VFOrderDetailQRCodeView alloc]initWithOrderID:_orderID isNew:YES];
        [view showXLAlertView];
    }
}

//删除订单
- (void)deleteOrder{
    kWeakSelf;
    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"确定删除吗"];
    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
    [alertVC addAction:cancelAction];
    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
        [JSFProgressHUD showHUDToView:self.view];
        [VFHttpRequest deleteOrderParameter:_orderID SuccessBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            [EasyTextView showSuccessText:@"删除成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];

        }];
    }];
    [alertVC addAction:updateAction];
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
