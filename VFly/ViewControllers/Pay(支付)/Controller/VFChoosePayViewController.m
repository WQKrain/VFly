//
//  VFChoosePayViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/23.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChoosePayViewController.h"
#import "ChooseCouponsListViewController.h"
#import "couponModel.h"
#import "LoginModel.h"
#import "VFGetOrderMoneyModel.h"
#import "VFValidationCodeViewController.h"
#import "CFChooseBankCardViewController.h"
#import "VFChoosePayTableViewCell.h"
#import "VipInfoModel.h"
#import "VFPaySuccessfulViewController.h"
#import "VFpayfailureViewController.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"
#import "LLOrder.h"
#import "LoginModel.h"
#import "VFChhoosepaybankCardTableViewCell.h"

#import "WebViewVC.h"

#import "VFUserInfoModel.h"
#import "VFGetPayMoneyModel.h"
#import "VFAvailableCouponsModel.h"
#import "BeeCloud.h"                            // 支付


@interface VFChoosePayViewController ()<UITableViewDelegate,UITableViewDataSource,BeeCloudDelegate>{
    dispatch_group_t _groupEnter;
}
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)NSArray *iamgeArr;

@property (nonatomic , strong)BaseTableView *tabelView;

//计算前述所需变量
@property (nonatomic, strong) NSString *integral;
@property (nonatomic, strong) NSString *coupons;

@property (nonatomic, strong) chooseCouponListModel *couponsModel;
@property (nonatomic, strong) VFBaseListMode *coupleModel;


@property (nonatomic, assign) float proportion;
@property (nonatomic, strong) NSString *useCoupons;
@property (nonatomic, strong) NSString *useCouponsID;
@property (nonatomic, strong) NSString *useIntegral;

@property (nonatomic, strong) UIButton *chooseIntegral;
@property (nonatomic, strong) UIButton *chooseCoupons;

@property (nonatomic, strong) UIImageView *chooseIntegralImage;

//可抵扣金额
@property (nonatomic, strong) NSString *canDiscountMoney; //可以抵扣的金额
@property (nonatomic, strong) NSString *rentMoney;        //计算积分和优惠券抵扣后金额

@property (nonatomic, strong) UILabel * integralLabel;
@property (nonatomic, strong) UILabel * couponsLabel;

@property (nonatomic, strong) UILabel *showMoneylabel;

@property (nonatomic, strong) VFGetPayMoneyModel *orderMoneyModel;

@property (nonatomic, strong) UIView *preferentialView;
@property (nonatomic, strong)  UIView *headerView;

@property (nonatomic , strong)NSString *doPayFee;

//剩余预存款
@property (nonatomic , strong)NSString *myMoney;

//余额
@property (nonatomic , strong)NSString *balance;
@property (nonatomic , strong)VipInfoModel *vipModel;
@property (nonatomic , assign)NSInteger BeeCloudChoosePay;

//分笔支付
@property (nonatomic , strong)UILabel *enbiPayLabel;     //显示本次分笔金额
@property (nonatomic , strong)UILabel *bottomFenbiPayLabel;   //显示是否需要分笔的label
@property (nonatomic , strong)UIView *bottomFenbiPayView;     //显示是否需要分笔的view
@property (nonatomic , strong)UILabel *showFenbiPayLabel;

@property (nonatomic , assign)BOOL fenBiPay;
@property (nonatomic , strong)UIView *alertInputView;
@property (nonatomic , strong)UIView *alertInputBgView;
@property (nonatomic , strong)UIButton *cancelButton;
@property (nonatomic , strong)UIView *sureButton;
@property (nonatomic , strong)UIView *errorShowView;
@property (nonatomic , strong)NSString *fenBiInputMoney;
@property (nonatomic , strong)UILabel *errorlabel;
@property (nonatomic , strong)UILabel *titllelabel;

@property (nonatomic , strong)UIView *chooseIntegralView;
@property (nonatomic , strong)UIView *chooseCouponsView;

@property (nonatomic , strong)NSString *is_score;
@property (nonatomic , strong)NSString *is_coupon;

@end


@implementation VFChoosePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    #pragma mark - 设置BeeCloud delegate
    [BeeCloud setBeeCloudDelegate:self];
    _dataArr = @[@"免押金专属渠道",@"银行卡支付",@"支付宝支付",@"微信支付",@"余额支付"];
    _iamgeArr = @[[UIImage imageNamed:@"icon_free"],[UIImage imageNamed:@"画板 22"],[UIImage imageNamed:@"icon_AliPay"],[UIImage imageNamed:@"icon_wechat pay"],[UIImage imageNamed:@"画板 21"]];
    _fenBiPay = NO;
    [self createTableView];
    _useCoupons = @"0";
    _useIntegral = @"0";
    _myMoney = @"0";
    //当为余额充值时，不调用获取可抵扣金额的接口
    if (_isHiddenBalancePay) {
        _doPayFee = _payMoney;
        _dataArr = @[@"免押金专属渠道",@"银行卡支付",@"支付宝支付",@"微信支付",@"余额支付"];
        _tabelView.tableHeaderView = [self createTableHeaderView];
        _showMoneylabel.text = kFormat(@"¥%d", [_doPayFee intValue]);
    }else{
        [self loadData];
    }
}

- (void)loadData{
    kWeakSelf;
    [JSFProgressHUD showHUDToView:self.view];
    dispatch_queue_t queueEnter = dispatch_get_global_queue(0, 0);
    dispatch_async(queueEnter, ^{
        _groupEnter = dispatch_group_create();
        dispatch_group_async(_groupEnter, queueEnter, ^{
            //获取需支付金额
            dispatch_group_enter(_groupEnter);
            NSLog(@"=======================================%@=====%@",_orderID,_moneyType);
            [VFHttpRequest orderShouldPayParameter:@{@"order_id":_orderID,@"should_pay_id":_moneyType} successBlock:^(NSDictionary *data){
                VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                if ([model.code intValue] == 1) {
                    weakSelf.orderMoneyModel = [[VFGetPayMoneyModel alloc]initWithDic:model.data];
                    _doPayFee = weakSelf.orderMoneyModel.unPayedMoney;
                    _is_score = weakSelf.orderMoneyModel.is_score;
                    _is_coupon = weakSelf.orderMoneyModel.is_coupon;
                }else{
                    [EasyTextView showErrorText:@"请求失败"];
                }
                dispatch_group_leave(_groupEnter);
            } withFailureBlock:^(NSError *error) {
                [EasyTextView showErrorText:@"请求失败"];
                dispatch_group_leave(_groupEnter);
            }];
        });
        //获取用户信息
        dispatch_group_enter(_groupEnter);
        [VFHttpRequest getUserInfoSuccessBlock:^(NSDictionary *data) {
            
            NSLog(@"=======================================================%@",data);
            
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            if ([model.code intValue] == 1) {
                VFUserInfoModel *obj = [[VFUserInfoModel alloc]initWithDic:model.data];
                weakSelf.myMoney = obj.money;
                weakSelf.integral = obj.score;
            }else{
                [EasyTextView showErrorText:model.message];
            }
            dispatch_group_leave(_groupEnter);
        } withFailureBlock:^(NSError *error) {
            [EasyTextView showErrorText:@"请求失败"];
            dispatch_group_leave(_groupEnter);
        }];
        
        dispatch_group_notify(_groupEnter, queueEnter, ^{
            if ([self.orderMoneyModel.canDiscountMoney intValue] > 0) {
                [VFHttpRequest getAvailableCouponParameter:@{@"money":self.orderMoneyModel.canDiscountMoney} SuccessBlock:^(NSDictionary *data) {
                    _coupleModel = [[VFBaseListMode alloc]initWithDic:data];
                    [weakSelf setData];
                } withFailureBlock:^(NSError *error) {
                    [JSFProgressHUD hiddenHUD:self.view];
                    [EasyTextView showErrorText:@"请求失败"];
                }];
            }else{
                [JSFProgressHUD hiddenHUD:self.view];
                [weakSelf setData];
            }
        });
    });
}

- (void)setData{
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新UI
        [JSFProgressHUD hiddenHUD:self.view];
        _proportion = 1.0;
        _tabelView.tableHeaderView = [self createTableHeaderView];
        if ([_integral integerValue]<1000) {
            [_chooseIntegral setEnabled:NO];
        }
        
        _showMoneylabel.text = kFormat(@"¥%@", _orderMoneyModel.unPayedMoney);
        _canDiscountMoney = _orderMoneyModel.canDiscountMoney;
        _rentMoney = _orderMoneyModel.unPayedMoney;
        
        if ([_canDiscountMoney intValue]>0) {
            _headerView.frame = CGRectMake(0, 0, kScreenW, 215);
            _preferentialView.hidden = NO;
        }else{
            _bottomFenbiPayView.top = _showMoneylabel.bottom+18;
        }
        
        if ([_orderMoneyModel.unPayedMoney intValue] <=100) {
            _bottomFenbiPayView.hidden = YES;
            _headerView.height = _headerView.height - 45;
        }else{
            if ([_orderMoneyModel.unPayedMoney intValue]>0) {
                _bottomFenbiPayView.hidden = NO;
            }else{
                _bottomFenbiPayView.hidden = YES;
            }
        }
        
        if ([_is_score isEqualToString:@"1"]) {
            [_chooseIntegralView setUserInteractionEnabled:NO];
        }
        
        if ([_is_coupon isEqualToString:@"1"]) {
            [_chooseCouponsView setUserInteractionEnabled:NO];
        }
        
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in _coupleModel.data) {
            chooseCouponListModel *model = [[chooseCouponListModel alloc]initWithDic:dic];
            if ([model.useable isEqualToString:@"1"]) {
                [tempArr addObject:model];
            }
        }
        _couponsLabel.text = [NSString stringWithFormat:@"%ld张优惠券可使用",tempArr.count];
        _coupons = kFormat(@"%ld", _coupleModel.data.count);
        [self calculatePayMoneyCcoupons:_useCoupons integral:_useIntegral];
        _dataArr = @[@"免押金专属渠道",@"银行卡支付",@"支付宝支付",@"微信支付",kFormat(@"余额支付 (%@)", _myMoney?_myMoney:@"0")];
        [_tabelView reloadData];
    });
}


- (void)centerbuttonClick:(UIButton *)sender{
    if (sender.tag == 0) {
        _chooseIntegral.selected = !_chooseIntegral.selected;
        if (_chooseIntegral.selected) {
            _chooseIntegralImage.image = [UIImage imageNamed:@"icon_checkbox_on"];
            _useIntegral = _integral;
        }else{
            _chooseIntegralImage.image = [UIImage imageNamed:@"icon_off"];
            _useIntegral = @"0";
        }
        [self calculatePayMoneyCcoupons:_useCoupons integral:_useIntegral];
    }else if (sender.tag == 1){
        if ([_coupons intValue]>0) {
            ChooseCouponsListViewController *vc = [[ChooseCouponsListViewController alloc]init];
            if (_fenBiPay) {
                vc.money = _fenBiInputMoney;
            }else{
                vc.money = self.orderMoneyModel.canDiscountMoney;
            }
            vc.delegate = self;
            vc.isNew = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (void)chooseCouponsModel:(chooseCouponListModel *)model{
    _couponsModel = model;
    _useCoupons = model.money;
    _useCouponsID = model.cardID;
    [self calculatePayMoneyCcoupons:_useCoupons integral:_useIntegral];
}

- (void)backCancleCoupons{
    _useCoupons = 0;
    [self calculatePayMoneyCcoupons:_useCoupons integral:_useIntegral];
}

// 计算钱数
- (void)calculatePayMoneyCcoupons:(NSString *)coupons integral:(NSString *)integral{
    //计算用户消费的积分
    if (_fenBiPay) {
        if ([_fenBiInputMoney intValue]<[_canDiscountMoney intValue]) {
            _canDiscountMoney = _fenBiInputMoney;
        }
    }
    _useIntegral = [NSString stringWithFormat:@"%ld",(long)([_canDiscountMoney integerValue] - [self.useCoupons integerValue])*10];
    
    //对积分整千取整，计算出全部的钱一共需要多少积分抵扣
    int thousand = [_useIntegral intValue]/1000;
    int number = ([_useIntegral intValue]%1000>0)?thousand+1:thousand;
    _useIntegral = [NSString stringWithFormat:@"%d",number *1000];

    //如果需要抵扣的积分大于拥有的积分，那么等于拥有的可使用积分
    if ([_useIntegral intValue] >=[_integral intValue]) {
        _useIntegral = kFormat(@"%d", [_integral intValue]/1000*1000);
    }
    
    //如果选择积分的按钮 为选中状态
    if (_chooseIntegral.selected) {
        //如果可使用的积分抵扣后的金额依然多余可抵扣的金额，那么重新赋值
        if ((int)[_useIntegral integerValue]/10 >=[_canDiscountMoney intValue]) {
            _integralLabel.text = [NSString stringWithFormat:@"-¥%ld",(long)[_canDiscountMoney integerValue]-[_useCoupons integerValue]];
        }else{
            _integralLabel.text = [NSString stringWithFormat:@"-¥%d",(int)[_useIntegral integerValue]/10];
        }
        
        if ([integral intValue] == 0) {
            _useIntegral = @"0";
        }
        _integralLabel.textColor = kMainColor;
    }else{
        NSString * twointegralBreaks;
        if ([_useIntegral intValue]/10>[_canDiscountMoney intValue]) {
            twointegralBreaks = _canDiscountMoney;
        }else{
            twointegralBreaks = kFormat(@"%d",[_useIntegral intValue]/10);
        }
        _integralLabel.text = kFormat(@"可用%@积分抵扣%@元",_useIntegral,twointegralBreaks);
        _integralLabel.textColor = kdetailColor;
        _useIntegral = @"0";
    }
    
    //计算优惠券
    _useCoupons = coupons;
    
    //计算用户的总租金
    _rentMoney = [NSString stringWithFormat:@"%d",[_orderMoneyModel.unPayedMoney intValue]-[_useCoupons intValue] - [_useIntegral intValue]/10];
    
    if ([_orderMoneyModel.unPayedMoney integerValue]-[_canDiscountMoney intValue]>[_rentMoney integerValue]) {
        _rentMoney = kFormat(@"%d", [_orderMoneyModel.unPayedMoney intValue]-[_canDiscountMoney intValue]);
    }
    
    if ([_rentMoney intValue]>0) {
        
    }else{
        _rentMoney = @"0";
    }
    
    if ([_useCoupons integerValue]>0) {
        _couponsLabel.text = [NSString stringWithFormat:@"-¥%@",_useCoupons];
        _couponsLabel.textColor = kMainColor;
    }else{
        _couponsLabel.text = [NSString stringWithFormat:@"%@张优惠券可使用",_coupons];
        _couponsLabel.textColor = kdetailColor;
    }
    _showMoneylabel.text = kFormat(@" ¥%@", _rentMoney);
    
    if ([_rentMoney intValue] - [_fenBiInputMoney intValue]<0) {
        if (_fenBiPay) {
            [self fenBiAlertView];
            _titllelabel.text = @"本次分笔支付金额已超过当前需支付金额，请重新输入";
            _titllelabel.textColor = kMainColor;
        }
    }
    
    if ([_rentMoney intValue]>0) {
        _bottomFenbiPayView.hidden = NO;
    }else{
        _bottomFenbiPayView.hidden = YES;
    }
    
    if ([_fenBiInputMoney intValue]<[_useCoupons intValue]+[_useIntegral intValue]/10) {
        if (_fenBiPay) {
            [self fenBiAlertView];
            _titllelabel.text = @"输入金额需大于优惠金额";
            _titllelabel.textColor = kMainColor;
        }
    }
    
    //当已经使用过积分
    if ([_is_score isEqualToString:@"1"]) {
        _integralLabel.text = @"积分当前不可用";
        _integralLabel.textColor = kdetailColor;
    }
    //当已经使用过优惠券
    if ([_is_coupon isEqualToString:@"1"]) {
        _couponsLabel.text = @"0张优惠券可使用";
        _couponsLabel.textColor = kdetailColor;
    }
    
}

- (void)createTableView{
    _tabelView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH-44-kStatutesBarH)];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    [_tabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    _tabelView.tableFooterView = [[UIView alloc]init];
    _tabelView.tableHeaderView = [self createTableHeaderView];
    [_tabelView registerClass:[VFChoosePayTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tabelView registerClass:[VFChhoosepaybankCardTableViewCell class] forCellReuseIdentifier:@"bankCell"];
}

- (UIView *)createTableHeaderView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 135)];
        
        _showMoneylabel = [UILabel initWithTitle:@"" withFont:kNewBigTitle textColor:kdetailColor];
        _showMoneylabel.frame = CGRectMake(15, 18, kScreenW-30, 42);
        [_headerView addSubview:_showMoneylabel];
        
        _showFenbiPayLabel = [UILabel initWithFont:kTextSize textColor:kMainColor];
        _showFenbiPayLabel.frame = CGRectMake(15, _showMoneylabel.bottom+5, kScreenW-30, 0);
        [_headerView addSubview:_showFenbiPayLabel];
        
        _preferentialView  = [[UIView alloc]initWithFrame:CGRectMake(0, _showMoneylabel.bottom+18, kScreenW, 92)];
        _preferentialView.hidden = YES;
        [_headerView addSubview:_preferentialView];
        
        
        _bottomFenbiPayView = [[UIView alloc]initWithFrame:CGRectMake(0, _preferentialView.bottom, kScreenW, 45)];
        [_headerView addSubview:_bottomFenbiPayView];
        
        _bottomFenbiPayView.hidden = YES;
        
        _bottomFenbiPayLabel = [UILabel initWithTitle:@"支付限额？分笔支付" withFont:kTextSize textColor:kMainColor];
        _bottomFenbiPayLabel.frame = CGRectMake(15, 0, kScreenW-30, 45);
        _bottomFenbiPayLabel.textAlignment = NSTextAlignmentRight;
        [_bottomFenbiPayView addSubview:_bottomFenbiPayLabel];
        NSString *contentStr = @"支付限额？";
        NSRange range = [_bottomFenbiPayLabel.text rangeOfString:contentStr];
        [CustomTool setTextColor:_bottomFenbiPayLabel FontNumber:[UIFont systemFontOfSize:kTextSize] AndRange:range AndColor:kdetailColor];
        UIButton *fenBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        fenBiButton.frame = CGRectMake(0, 0, kScreenW, 45);
        [fenBiButton addTarget:self action:@selector(chooseFenBiPay) forControlEvents:UIControlEventTouchUpInside];
        [_bottomFenbiPayView addSubview:fenBiButton];
        
        
        NSArray *leftArr = @[@"使用积分",@"使用优惠券"];
        for (int i=0; i<2; i++) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 46*i, kScreenW, 46)];
            [_preferentialView addSubview:bgView];
            
            UILabel *leftlabel = [UILabel initWithTitle:leftArr[i] withFont:kTitleBigSize textColor:kdetailColor];
            leftlabel.frame = CGRectMake(15, 0, (kScreenW-30)/2, 46);
            [bgView addSubview:leftlabel];
            
            UIImageView *rightIamge = [[UIImageView alloc]init];
            [bgView addSubview:rightIamge];
            
            UILabel *rightLabel = [UILabel initWithTitle:@"" withFont:kTextSize textColor:kdetailColor];
            rightLabel.frame =CGRectMake(kScreenW-241, 0, 200, 46);
            rightLabel.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:rightLabel];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, kScreenW, 46);
            button.tag = i;
            [button addTarget:self action:@selector(centerbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            
            if (i==0) {
                rightIamge.image = [UIImage imageNamed:@"icon_off"];
                _chooseIntegralImage = rightIamge;
                rightIamge.frame = CGRectMake(kScreenW-37, 15, 16, 16);
                _integralLabel = rightLabel;
                _chooseIntegral = button;
                _chooseIntegralView = bgView;
            }else{
                rightIamge.frame = CGRectMake(kScreenW-37, 15, 16, 16);
                rightIamge.image = [UIImage imageNamed:@"前进"];
                _couponsLabel = rightLabel;
                _chooseCoupons = button;
                _chooseCouponsView = bgView;
            }
        }
    }
    return _headerView;
}

- (void)chooseFenBiPay{
    _fenBiPay = !_fenBiPay;
    if (_fenBiPay) {
        [self fenBiAlertView];
        _titllelabel.text = @"请输入本次分笔金额";
        _titllelabel.textColor = kdetailColor;
    }else{
        if ([_canDiscountMoney intValue]>0) {
            _headerView.height = 215;
            _preferentialView.top  = _showMoneylabel.bottom+18;
            _bottomFenbiPayView.top = _preferentialView.bottom;
        }else{
            _headerView.height = 135;
            _bottomFenbiPayView.top = _showMoneylabel.bottom+18;
        }
        _showFenbiPayLabel.text = @"";
        _bottomFenbiPayLabel.text = @"支付限额？分笔支付";
        
        if (self.orderMoneyModel) {
            if ([self.orderMoneyModel.canDiscountMoney intValue] > 0) {
                kWeakSelf;
                [JSFProgressHUD showHUDToView:self.view];
                [VFHttpRequest getAvailableCouponParameter:@{@"money":self.orderMoneyModel.canDiscountMoney} SuccessBlock:^(NSDictionary *data) {
                    [JSFProgressHUD hiddenHUD:self.view];
                    _coupleModel = [[VFBaseListMode alloc]initWithDic:data];
                    [weakSelf calculatePayMoneyCcoupons:_useCoupons integral:_useIntegral];
                } withFailureBlock:^(NSError *error) {
                    [JSFProgressHUD hiddenHUD:self.view];

                }];
            }
        }
    }
    NSString *contentStr = @"支付限额？";
    NSRange range = [_bottomFenbiPayLabel.text rangeOfString:contentStr];
    [CustomTool setTextColor:_bottomFenbiPayLabel FontNumber:[UIFont systemFontOfSize:kTextSize] AndRange:range AndColor:kdetailColor];

    [self.tabelView beginUpdates];
    [self.tabelView setTableHeaderView:_headerView];
    [self.tabelView endUpdates];
    [_tabelView reloadData];
}

- (UIView *)fenBiAlertView{
    _alertInputView = [[UIView alloc]initWithFrame:self.view.bounds];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [_alertInputView addGestureRecognizer:tapGesture];
    _alertInputView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:_alertInputView];
    
    _alertInputBgView = [[UIView alloc]init];
    _alertInputBgView.backgroundColor = kWhiteColor;
    _alertInputBgView.layer.masksToBounds = YES;
    _alertInputBgView.layer.cornerRadius = 4;
    [_alertInputView addSubview:_alertInputBgView];
    [_alertInputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kSpaceW(305));
        make.height.mas_offset(162);
        make.top.mas_equalTo(kSpaceH(223));
        make.centerX.mas_equalTo(_alertInputView);
    }];
    _titllelabel = [UILabel initWithTitle:@"请输入本次分笔金额" withFont:kTextSize textColor:kdetailColor];
    _titllelabel.numberOfLines = 0;
    [_alertInputBgView addSubview:_titllelabel];
    [_titllelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kSpaceW(305)-30);
    }];
    UILabel *leftlabel = [UILabel initWithTitle:@"¥" withFont:kTitleBigSize textColor:kdetailColor];
    [_alertInputBgView addSubview:leftlabel];
    [leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_titllelabel.mas_bottom).offset(30);
        make.width.mas_equalTo(16);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    textField.text = _rentMoney;
    _fenBiInputMoney = _rentMoney;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_alertInputBgView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftlabel.mas_right).offset(5);
        make.top.equalTo(_titllelabel.mas_bottom).offset(15);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(42);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = klineColor;
    [_alertInputBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
        make.top.equalTo(textField.mas_bottom).offset(5);
    }];
    
    _errorShowView = [[UIView alloc]init];
    [_alertInputBgView addSubview:_errorShowView];
    [_errorShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.equalTo(lineView.mas_bottom).offset(5);
        make.height.mas_equalTo(17);
    }];
    
    UIImageView *errorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"资源 10"]];
    errorImage.contentMode = UIViewContentModeScaleAspectFit;
    [_errorShowView addSubview:errorImage];
    [errorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(14);
    }];
    _errorlabel = [UILabel initWithTitle:@"超出当前需支付金额" withFont:kTextSize textColor:kMainColor];
    _errorShowView.hidden = YES;
    [_errorShowView addSubview:_errorlabel];
    [_errorlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(errorImage.mas_right).offset(6);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-16);
    }];
    
    
    NSArray *buttonArr = @[@"取消",@"确定"];
    for (int i=0; i<2; i++) {
        UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:kTitleBigSize]];
        [button setTitleColor:kdetailColor forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(inputAlertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alertInputBgView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpaceW(305)/2*i);
            make.bottom.equalTo(_alertInputBgView.mas_bottom);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(kSpaceW(305)/2);
        }];
    }
    
    return _alertInputView;
}

//输入框限定字符长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text intValue]>[_rentMoney intValue]) {
        _errorShowView.hidden = NO;
        _errorlabel.text = @"超出当前需支付金额";
        textField.textColor = kMainColor;
    }else if ([textField.text intValue]<100 && [_rentMoney intValue]>[textField.text intValue]){
        _errorShowView.hidden = NO;
        _errorlabel.text = @"分笔金额不能小于一百元";
        textField.textColor = kMainColor;
    }
    else{
        textField.textColor = kdetailColor;
        _errorShowView.hidden = YES;
        _fenBiInputMoney = textField.text;
    }
}


- (void)inputAlertButtonClick:(UIButton *)sender{
    if (sender.tag == 1) {
        if (!_errorShowView.hidden) {
            return;
        }
        _showFenbiPayLabel.height = 17;
        _showFenbiPayLabel.text = kFormat(@"本次分笔金额 ¥%@", _fenBiInputMoney);
        _bottomFenbiPayLabel.text = @"取消分笔支付";
        
        if ([_canDiscountMoney intValue]>0) {
            _headerView.height = 237+17;
            _preferentialView.top  = _showFenbiPayLabel.bottom+18;
            _bottomFenbiPayView.top = _preferentialView.bottom;
        }else{
            _headerView.height = 134+17;
            _bottomFenbiPayView.top = _showFenbiPayLabel.bottom+10;
        }
        
        NSString *contentStr = @"支付限额？";
        NSRange range = [_bottomFenbiPayLabel.text rangeOfString:contentStr];
        [CustomTool setTextColor:_bottomFenbiPayLabel FontNumber:[UIFont systemFontOfSize:kTextSize] AndRange:range AndColor:kdetailColor];
        
        [self.tabelView beginUpdates];
        [self.tabelView setTableHeaderView:_headerView];
        [self.tabelView endUpdates];
        
        if (self.orderMoneyModel) {
            if ([self.orderMoneyModel.canDiscountMoney intValue] > 0) {
                [JSFProgressHUD showHUDToView:self.view];
                kWeakSelf;
                [VFHttpRequest getAvailableCouponParameter:@{@"money":_fenBiInputMoney} SuccessBlock:^(NSDictionary *data) {
                    [JSFProgressHUD showHUDToView:self.view];
                    _coupleModel = [[VFBaseListMode alloc]initWithDic:data];
                    [weakSelf setData];
                } withFailureBlock:^(NSError *error) {
                    [JSFProgressHUD hiddenHUD:self.view];

                }];
            }
        }
        [self.tabelView reloadData];
    }else{
        if (_fenBiPay) {
            [self chooseFenBiPay];
        }
    }
    [_alertInputView removeFromSuperview];
}

- (void)event:(UITapGestureRecognizer *)gesture
{
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 0;
    }
    if (indexPath.row == 1) {
        
        if (_fenBiPay) {
            if ([_fenBiInputMoney intValue] <250) {
                return 0;
            }
        }else{
            if (_isHiddenBalancePay) {
                if ([_doPayFee intValue] <250) {
                    return 0;
                }
            }else{
                if ([_orderMoneyModel.unPayedMoney intValue] <250) {
                    return 0;
                }
            }
        }
    }
    
    if (indexPath.row == 4) {
        
        if (_isHiddenBalancePay) {
            return 0;
        }
        
        if (_fenBiPay) {
            if ([_fenBiInputMoney intValue] >[_myMoney intValue]) {
                return 0;
            }
        }else{
            if ([_doPayFee intValue] >[_myMoney intValue]) {
                return 0;
            }
        }
    }
    
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        VFChhoosepaybankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankCell"];
        if (cell==nil)
        {
            cell = [[VFChhoosepaybankCardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bankCell"];
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
            }
        }
        
        cell.iconImage.image = _iamgeArr[indexPath.row];
        cell.leftlabel.text = _dataArr[indexPath.row];
        
        if (_fenBiPay) {
            if ([_fenBiInputMoney intValue] <250) {
                cell.hidden  = YES;
            }
        }else{
            if (_isHiddenBalancePay) {
                if ([_doPayFee intValue] <250) {
                    cell.hidden  = YES;
                }
            }else{
                if ([_orderMoneyModel.unPayedMoney intValue] <250) {
                    cell.hidden  = YES;
                }
            }
        }
        
        
        return cell;
        
    }else{
        VFChoosePayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell==nil)
        {
            cell = [[VFChoosePayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
            }
        }
        cell.iconImage.image = _iamgeArr[indexPath.row];
        cell.leftlabel.text = _dataArr[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.hidden = YES;
        }
        
        if (indexPath.row == 4) {
            if (_isHiddenBalancePay) {
                cell.hidden  = YES;
            }
            
            if (_fenBiPay) {
                if ([_fenBiInputMoney intValue] >[_myMoney intValue]) {
                    cell.hidden  = YES;
                }
            }else{
                if ([_doPayFee intValue] >[_myMoney intValue]) {
                    cell.hidden  = YES;
                }
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *score;
    if (_chooseIntegral.selected) {
        score = @"1";
    }else{
        score = @"0";
    }
    
    if (_isHiddenBalancePay) {
        [self choosePay:indexPath.row score:score];
    }else{
    
        NSDictionary *dic;
        
        if (_useCoupons != 0) {
            dic = @{@"should_pay_id":_moneyType,@"order_id":self.orderID,@"coupon_id":_useCouponsID?_useCouponsID:@"",@"score":score,@"money":_fenBiPay?_fenBiInputMoney:@""};
        }else{
            dic = @{@"should_pay_id":_moneyType,@"order_id":self.orderID,@"score":score,@"money":_fenBiPay?_fenBiInputMoney:@""};
        }
        [JSFProgressHUD showHUDToView:self.view];
        [VFHttpRequest orderShouldPayParameter:dic successBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            VFBaseMode *modle = [[VFBaseMode alloc]initWithDic:data];
            _orderMoneyModel = [[VFGetPayMoneyModel alloc]initWithDic:modle.data];
            _doPayFee = _orderMoneyModel.real_money;
            [self choosePay:indexPath.row score:score];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];

        }];
    }
}

- (void)choosePay:(NSInteger)indexRow score:(NSString *)score{
    if ([_doPayFee intValue]<=0) {
        [self balancePay:indexRow];
        return;
    }
    
    switch (indexRow) {
        case 0:{
            break;
        }
        case 4:{
            [self balancePay:indexRow];
            [JSFProgressHUD hiddenHUD:self.view];
        }
            break;
        case 1:{
            CFChooseBankCardViewController *vc = [[CFChooseBankCardViewController alloc]init];
            vc.orderInfo = _orderMoneyModel.item;
            vc.moneyType = self.moneyType;
            vc.orderID = self.orderID;
            vc.money = kFormat(@"%@", self.doPayFee);
            vc.useCouponsID = _useCouponsID?_useCouponsID:@"";
            vc.score = score;
            vc.isNew = YES;
            vc.handler = _isHiddenBalancePay?_handler: _orderMoneyModel.handler;
            [self.navigationController pushViewController:vc animated:YES];
            [JSFProgressHUD hiddenHUD:self.view];
        }
            break;
        case 3:
            [self doPay:PayChannelWxApp];
            _BeeCloudChoosePay = 0;
            [JSFProgressHUD hiddenHUD:self.view];
            break;
        case 2:
            [JSFProgressHUD hiddenHUD:self.view];
            _BeeCloudChoosePay = 1;
            [self doPay:PayChannelAliApp];
            break;
            
        default:
            break;
    }
}

- (void)balancePay:(NSInteger)index{
    VFValidationCodeViewController *vc = [[VFValidationCodeViewController alloc]init];
    vc.doPayFee = self.doPayFee;
    vc.moneyType = self.moneyType;
    vc.orderID = self.orderID;
    vc.useCouponsID = _useCouponsID?_useCouponsID:@"";
    vc.useIntegral = _useIntegral;
    vc.isNew = YES;
    vc.should_pay_id = _moneyType;
    vc.func = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - BeeCloud
- (void)doPay:(PayChannel)channel
{
    NSString *score;
    if (_chooseIntegral.selected) {
        score = @"1";
    }else{
        score = @"0";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_moneyType,@"should_pay_id",self.orderID,@"orderId",_useCouponsID?_useCouponsID:@"",@"couponId",score,@"score",_isHiddenBalancePay?_handler: _orderMoneyModel.handler,@"handler",@"",@"userId",@"",@"idCard",@"",@"name",@"",@"bankCard",@"",@"mobile",@"v2",@"version",nil];
    
    BCPayReq *payReq = [[BCPayReq alloc] init];
    /**
     *  支付渠道，PayChannelWxApp,PayChannelAliApp,PayChannelUnApp,PayChannelBaiduApp
     */
    payReq.channel = channel; //支付渠道
    if (_isHiddenBalancePay) {
        payReq.title = @"余额充值";
    }else{
        payReq.title = _orderMoneyModel.item;//订单标题
    }
    if (channel == PayChannelWx) {
        payReq.totalFee = self.doPayFee;
    }else{
        NSString *money = kFormat(@"%d", [self.doPayFee intValue]*100);
        payReq.totalFee = kFormat(@"%d", [money intValue]);
    }
    
    NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
    NSInteger time = late1;
    NSString *orderID = [NSString stringWithFormat:@"%@%ld",self.orderID,(long)time];
    payReq.billNo = orderID;  //商户自定义订单号
    
    payReq.scheme = @"VflyAlipay";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.cardType = 0; //0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；默认为0
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    
    //    if ([payReq checkParametersForReqPay]) {
    //        NSLog(@"参数没有问题");
    //    }else {
    //        NSLog(@"参数有问题");
    //    }
    
    [BeeCloud sendBCReq:payReq];
}


//BCPay回调
- (void)onBeeCloudResp:(BCBaseResp *)resp
{
    [JSFProgressHUD hiddenHUD:self.view];
    
    // 支付请求响应
    BCPayResp *tempResp = (BCPayResp *)resp;
    
    if (tempResp.resultCode == 0) {
        NSString *payType;
        //微信、支付宝、银联支付成功
        switch (_BeeCloudChoosePay) {
            case 0:
                payType = @"微信支付";
                break;
            case 1:
                payType = @"支付宝支付";
                break;
            default:
                break;
        }
        VFPaySuccessfulViewController *vc = [[VFPaySuccessfulViewController alloc]init];
        vc.orderId = self.orderID;
        vc.moneyType = self.moneyType;
        vc.payMoney = self.doPayFee;
        vc.isNew = YES;
        if (_isHiddenBalancePay) {
            vc.isBalance = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VFpayfailureViewController *vc = [[VFpayfailureViewController alloc]init];
        vc.showInfo = tempResp.errDetail;
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

@end
