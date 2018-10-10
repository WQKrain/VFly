//
//  VFSuttleConfirmOrderViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSuttleConfirmOrderViewController.h"
#import "EditAddressViewController.h"
#import "AddressModel.h"
#import "defaultAdressModel.h"
#import "VFSuttleListModel.h"
#import "LoginModel.h"
#import "couponModel.h"
#import "WebViewVC.h"
//#import "ChooseCouponsListViewController.h"
#import "TXTimeChoose.h"

#import "VFOldChoosePayViewController.h"
#import "VFSuttleOrderDetailModel.h"
#import "VFPayMoneyDetailViewController.h"
#import "VFSuttleOrderGetDetailModel.h"

#import "VFLuxuryCarSuttleViewController.h"
#import "VFChooseSeatsViewController.h"

@interface VFSuttleConfirmOrderViewController ()<rentCarChooseAddressDelegate,TXTimeDelegate,CarLevelDelegate,carSeatDelegate>
//地址的全局变量
@property (nonatomic, strong) UIView *adressView;
@property (nonatomic, strong) UILabel *addressNameLabel;
@property (nonatomic, strong) UILabel *topAddresslabel;
@property (nonatomic, strong) UILabel *topPhoneLabel;
@property (nonatomic, strong) UIButton *chooseAddressBtn;
@property (nonatomic, strong) UILabel *chooseAddresslabel;

@property (nonatomic, strong) NSString * addressID;
@property (nonatomic, assign) BOOL chooseCity;
@property (nonatomic, strong) NSString * chooseCityID;

@property (nonatomic, strong) UIButton * chooseCiyButton;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) TXTimeChoose *timeChooseView;
@property (nonatomic, strong) NSString *chooseTimeStr;

@property (nonatomic, strong) UITextField *remarkTextField;

@property (nonatomic, strong) UILabel *showPayMoney;

@property (nonatomic, strong) UIButton *chooseTimebutton;

@property (nonatomic, strong) UIButton *agreenmentButton;
@property (nonatomic, strong) UILabel *payMoneyLabel;
@property (nonatomic, strong) VFSuttleOrderDetailModel *orderDetailModel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) NSString *header;

@property (nonatomic, strong) UILabel *seatlabel;
@end

@implementation VFSuttleConfirmOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"pickUpForm";
    self.header = @"确认订单";
    _chooseCityID = @"934";
    _addressID = @"0";
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-43-kNavBarH-kSafeBottomH)];
    self.scrollView.contentSize = CGSizeMake(0, 713+kNavTitleH);
    
    UILabel *label = [UILabel initWithNavTitle:_header];
    label.frame = CGRectMake(15, 0, kScreenW-30, kNavTitleH);
    label.font = [UIFont systemFontOfSize:kNewBigTitle];
    [_scrollView addSubview:label];
    
    [self.view addSubview:_scrollView];
    [self createAddressView];
    [_scrollView addSubview:[self createCenterView]];
    [self createBottomView];
    [self createPayMoneyView];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:_scrollView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)loadData{
    if ([_topAddresslabel.text isEqualToString:@""]) {
        if (!_chooseCity) {
            kWeakself;
            [JSFProgressHUD showHUDToView:self.view];
            [HttpManage getDefaultAddressSuccess:^(NSDictionary *dic) {
                HCBaseMode *model = [[HCBaseMode alloc]initWithDic:dic];
                if ([model.code isEqualToString:@"0"]) {
                    [JSFProgressHUD hiddenHUD:weakSelf.view];
                    defaultAdressModel *obj = [[defaultAdressModel alloc]initWithDic:model.data];
                    if (![obj.address isEqualToString:@""]) {
                        _topAddresslabel.text = obj.address;
                        _addressID = obj.addressID;
                        _chooseAddresslabel.hidden = YES;
                    }else{
                        _chooseAddresslabel.hidden = NO;
                        _addressID = @"0";
                    }
                }else{
                }
            } failedBlock:^(NSError *error) {
                [JSFProgressHUD hiddenHUD:self.view];
                [ProgressHUD showError:@"请求失败"];
            }];
            
            [HttpManage getShuttleDetailParameter:@{@"level":_suttleCar.level} successBlock:^(NSDictionary *data) {
                VFSuttleOrderGetDetailModel *model = [[VFSuttleOrderGetDetailModel alloc]initWithDic:data];
                _levelLabel.text = model.title;
            } withFailureBlock:^(NSError *error) {
                
            }];
            
            
        }else{
            _chooseCity = NO;
        }
    }
    
    NSString *useStartTime = [CustomTool toDateChangTimeStr:kFormat(@"%@",_chooseTimeStr)];
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":tokenStr,@"addressId":_addressID,@"seats":self.seats,@"useTime":useStartTime,@"useCityId":_chooseCityID,@"level":_suttleCar.level,@"remark":_remarkTextField.text,@"isOrder":@""};
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage hotCarSubmitOrderInfoWithDict:dic withSuccessBlock:^(NSDictionary *dic) {
        [JSFProgressHUD hiddenHUD:self.view];
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:dic];
        if ([model.info isEqualToString:@"ok"]) {
            _orderDetailModel = [[VFSuttleOrderDetailModel alloc]initWithDic:model.data];
            _showPayMoney.text = kFormat(@"应付总额 ¥%@", _orderDetailModel.rental);
            _payMoneyLabel.text = kFormat(@"合计 ¥%@",_orderDetailModel.rental);
        }
    } withFailureBlock:^(NSString *result_msg) {
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}


- (void)createAddressView{
    //显示地址的view
    _adressView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavTitleH, kScreenW, 64)];
    _adressView.backgroundColor = kWhiteColor;
    [_scrollView addSubview:_adressView];
    
    UIImageView *rightImage = [[UIImageView alloc]init];
    rightImage.image = [UIImage imageNamed:@"icon_more_select"];
    [_adressView addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_adressView);
        make.width.height.mas_equalTo(16);
        make.right.equalTo(_adressView).offset(-15);
    }];
    
    _topAddresslabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW-80, 64)];
    _topAddresslabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    _topAddresslabel.text = @"";
    [_adressView addSubview:_topAddresslabel];
    
    
    _chooseAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseAddressBtn.frame = CGRectMake(0, 0, kScreenW, 64);
    [_chooseAddressBtn addTarget:self action:@selector(chooseAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_adressView addSubview:_chooseAddressBtn];
    
    _chooseAddresslabel = [UILabel initWithTitle:@"请选择地址" withFont:kTitleBigSize textColor:kNewDetailColor];
    _chooseAddresslabel.frame = CGRectMake(15, 0, 100, 64);
    [_adressView addSubview:_chooseAddresslabel];
    
    
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, _adressView.height-1, kScreenW, 2)];
    lineImage.image = [UIImage imageNamed:@"image_address_line"];
    [_adressView addSubview:lineImage];
}

- (UIView *)createCenterView{
    UIView *cenrterView = [[UIView alloc]initWithFrame:CGRectMake(0, _adressView.bottom, kScreenW, 512)];
    NSArray *leftArr = @[@"豪车类型",@"座位数",@"其他备注"];
    
    //选择时间的按钮
    _chooseTimebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseTimebutton.frame = CGRectMake(0, 0, kScreenW, 64);
    [_chooseTimebutton addTarget:self action:@selector(chooseTimebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cenrterView addSubview:_chooseTimebutton];
    
    NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
    late1 = (long)(late1/1800)*1800+3600;
    _chooseTimeStr = [CustomTool changChineseTimeStr:kFormat(@"%ld", (long)late1)];
    [_chooseTimebutton setTitle:_chooseTimeStr forState:UIControlStateNormal];
    [_chooseTimebutton.titleLabel setFont:[UIFont systemFontOfSize:kTitleBigSize]];
    [_chooseTimebutton setTitleColor:kdetailColor forState:UIControlStateNormal];
    
    UIView *topLineView =[[UIView alloc]initWithFrame:CGRectMake(15,65, kScreenW-30, 1)];
    topLineView.backgroundColor = klineColor;
    [cenrterView addSubview:topLineView];
    
    
    UIView *chooseCityView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, kScreenW, 123)];
    [cenrterView addSubview:chooseCityView];
    
    UILabel *cityShow = [UILabel initWithTitle:@"用车城市(只限同城)" withFont:kTitleBigSize textColor:kdetailColor];
    cityShow.frame =CGRectMake(15, 24, kScreenW-30, kTitleBigSize);
    [chooseCityView addSubview:cityShow];
    NSArray *cityArr = @[@"杭州市",@"广州市"];
    for (int i=0; i<2; i++) {
        UIButton *cityButton = [UIButton newButtonWithTitle:cityArr[i]  sel:@selector(chooseCityButtonCilck:) target:self cornerRadius:YES];
        
        cityButton.frame = CGRectMake(15+((kScreenW-45)/2+15)*i, 55, (kScreenW-45)/2, 44);
        [chooseCityView addSubview:cityButton];
        cityButton.tag = i;
        if (i==0) {
            _chooseCiyButton = cityButton;
        }else{
            [cityButton setTitleColor:kNewButtonColor forState:UIControlStateNormal];
            [cityButton setBackgroundColor:kWhiteColor];
            cityButton.layer.borderWidth = 1;
            cityButton.layer.borderColor = kNewButtonColor.CGColor;
        }
    }
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(15,122, kScreenW-30, 1)];
    lineView.backgroundColor = klineColor;
    [chooseCityView addSubview:lineView];
    
    for (int i=0; i<3; i++) {
        UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(15,189+ 65*(i+1), kScreenW-30, 1)];
        lineView.backgroundColor = klineColor;
        [cenrterView addSubview:lineView];
        
        UILabel *leftlabel = [UILabel initWithTitle:leftArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        leftlabel.frame = CGRectMake(15, 189+65*i, (kScreenW-30)/2, 64);
        [cenrterView addSubview:leftlabel];
        
        if (i !=2) {
            UIImageView *rightIamge = [[UIImageView alloc]init];
            [cenrterView addSubview:rightIamge];
            
            rightIamge.image = [UIImage imageNamed:@"前进"];
            rightIamge.frame = CGRectMake(kScreenW-31, 189+24+65*i, 16, 16);
            
            UILabel *rightLabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kdetailColor];
            rightLabel.frame =CGRectMake(rightIamge.left-160, 189+65*i, 150, 64);
            rightLabel.textAlignment = NSTextAlignmentRight;
            [cenrterView addSubview:rightLabel];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 189+65*i, kScreenW, 64);
            button.tag = i;
            [button addTarget:self action:@selector(buttonClcik:) forControlEvents:UIControlEventTouchUpInside];
            [cenrterView addSubview:button];
            
            switch (i) {
                case 0:
                    _levelLabel = rightLabel;
                    break;
                case 1:
                    rightLabel.text = _seats;
                    _seatlabel = rightLabel;
                    break;
                default:
                    break;
            }
        }
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 189+65*i, kScreenW, 64);
//        button.tag = i;
//        [button addTarget:self action:@selector(centerbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cenrterView addSubview:button];
        
        if (i==2) {
            _remarkTextField = [[UITextField alloc]initWithFrame:CGRectMake(15+(kScreenW-30)/2, 189+65*i, (kScreenW-30)/2, 64)];
            _remarkTextField.placeholder = @"如有其他要求请输入";
            _remarkTextField.textAlignment = NSTextAlignmentRight;
            _remarkTextField.font = [UIFont systemFontOfSize:kTitleBigSize];
            [cenrterView addSubview:_remarkTextField];
            
            lineView.frame =CGRectMake(0,189+ 65*3, kScreenW, 1);
        }
        
    }
    
    return cenrterView;
}

- (void)buttonClcik:(UIButton *)sender{
    if (sender.tag == 0) {
        VFLuxuryCarSuttleViewController *vc = [[VFLuxuryCarSuttleViewController alloc]init];
        vc.delegate = self;
        vc.isChange = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VFChooseSeatsViewController *vc = [[VFChooseSeatsViewController alloc]init];
        vc.delegate = self;
        vc.isChange = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)carLevelButtonClick:(VFSuttleListArrModel *)model{
    _suttleCar = model;
    [self loadData];
}

- (void)carSeatButtonClick:(NSString *)seat{
    _seats = seat;
    _seatlabel.text = _seats;
}


- (void)chooseTimebuttonClick:(UIButton *)sender{
    self.timeChooseView = [[TXTimeChoose alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) type:UIDatePickerModeDateAndTime tag:670];
    
    self.timeChooseView.delegate = self;
    [self.view addSubview:self.timeChooseView];
}

- (void)chooseCityButtonCilck:(UIButton *)sender{
    [_chooseCiyButton setTitleColor:kNewButtonColor forState:UIControlStateNormal];
    [_chooseCiyButton setBackgroundColor:kWhiteColor];
    _chooseCiyButton.layer.borderWidth = 1;
    _chooseCiyButton.layer.borderColor = kNewButtonColor.CGColor;
    if (sender.tag == 0) {
        _chooseCityID = @"934";
    }else{
        _chooseCityID = @"1965";
    }
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [sender setBackgroundColor:kNewButtonColor];
    sender.layer.borderWidth = 0;
    sender.layer.borderColor = kNewButtonColor.CGColor;
    _chooseCiyButton = sender;
}

- (void)createBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-43-kSafeBottomH, kScreenW, 43)];
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-132, 1)];
    lineView.backgroundColor = klineColor;
    [bottomView addSubview:lineView];
    _showPayMoney = [UILabel initWithTitle:@"应付总额" withFont:kTitleBigSize textColor:kdetailColor];
    _showPayMoney.frame = CGRectMake(0, 0, kScreenW-132, 43);
    _showPayMoney.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_showPayMoney];
    
    UIButton *button = [UIButton newButtonWithTitle:@"确认支付"  sel:@selector(payButtonClick) target:self cornerRadius:NO];
    button.frame = CGRectMake(kScreenW-132, 0, 132, 43);
    [bottomView addSubview:button];
}


- (void)createPayMoneyView{
    UIView *payMoneyView = [[UIView alloc]initWithFrame:CGRectMake(0, 447+kNavTitleH, kScreenW, 266)];
    [_scrollView addSubview:payMoneyView];
    _payMoneyLabel = [UILabel initWithTitle:@"合计" withFont:kNewTitle textColor:kdetailColor];
    _payMoneyLabel.frame = CGRectMake(15, 30, kScreenW-30, 24);
    [payMoneyView addSubview:_payMoneyLabel];
    
    UILabel *monryDetail = [UILabel initWithTitle:@"点击查看付款明细" withFont:kTextSize textColor:kTextBlueColor];
    monryDetail.frame = CGRectMake(15, _payMoneyLabel.bottom+10, kScreenW-30, kTextSize);
    [payMoneyView addSubview:monryDetail];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenW, 106);
    [button addTarget:self action:@selector(payMoneyDetail) forControlEvents:UIControlEventTouchUpInside];
    [payMoneyView addSubview:button];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 106, kScreenW, 1)];
    lineView.backgroundColor = klineColor;
    [payMoneyView addSubview:lineView];
    
    UILabel *label = [UILabel initWithTitle:@"温馨提示\n\n*根据车型不同，最多可容纳的乘客人数也不相同\n*单程限100公里，4小时内\n*根据车库存留情况分配车辆，不可指定车型" withFont:kTextSize textColor:kNewDetailColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(15, lineView.bottom+15, kScreenW-30, 87);
    [payMoneyView addSubview:label];
    
    _agreenmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreenmentButton.frame = CGRectMake(15, label.bottom+15, 22, 22);
    [_agreenmentButton setImage:[UIImage imageNamed:@"icon_checkbox_off"] forState:UIControlStateNormal];
    [_agreenmentButton setImage:[UIImage imageNamed:@"icon_checkbox_on"] forState:UIControlStateSelected];
    _agreenmentButton.selected = YES;
    [_agreenmentButton addTarget:self action:@selector(agreentmentButton:) forControlEvents:UIControlEventTouchUpInside];
    [payMoneyView addSubview:_agreenmentButton];
    UILabel *readingLabel = [UILabel initWithTitle:@"阅读并同意" withFont:kTitleBigSize textColor:kdetailColor];
    readingLabel.frame = CGRectMake(_agreenmentButton.right+5, label.bottom+15, 85, 22);
    [payMoneyView addSubview:readingLabel];
    
    UIButton *agreenUrl = [UIButton buttonWithType:UIButtonTypeCustom];
    agreenUrl.frame = CGRectMake(readingLabel.right, label.bottom, 190, 52);
    [agreenUrl setTitle:@"《威风出行租车协议》" forState:UIControlStateNormal];
    [agreenUrl setTitleColor:kMainColor forState:UIControlStateNormal];
    [agreenUrl addTarget:self action:@selector(agreenUrl) forControlEvents:UIControlEventTouchUpInside];
    [payMoneyView addSubview:agreenUrl];
}

- (void)payMoneyDetail{
    VFPayMoneyDetailViewController *vc = [[VFPayMoneyDetailViewController alloc]init];
    vc.rentMoney = _orderDetailModel.rental;
    vc.vipZK = _orderDetailModel.vipDiscount;
    vc.allRentMoney = _suttleCar.level;
    vc.type = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)agreentmentButton:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (void)agreenUrl{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    GlobalConfigModel *model = [[GlobalConfigModel alloc]initWithDic:dic];
    WebViewVC *vc = [[WebViewVC alloc]init];
    vc.urlStr = model.cRental;
    vc.urlTitle = @"租车协议";
    vc.isPresent = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)payButtonClick{
    if (!_agreenmentButton.selected) {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请先同意用户租车协议哦"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
        return;
    }
    
    [self.scrollView endEditing:YES];
    // token
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    
    if ([_chooseTimeStr isEqualToString:@""] || [_addressID isEqualToString:@"0"]) {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请讲信息补充完整哦"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
        return;
    }
    
    NSString *useStartTime = [CustomTool toDateChangTimeStr:kFormat(@"%@",_chooseTimeStr)];
    NSDictionary *dic = @{@"token":tokenStr,@"addressId":_addressID,@"seats":self.seats,@"useTime":useStartTime,@"useCityId":_chooseCityID,@"level":_suttleCar.level,@"remark":_remarkTextField.text,@"isOrder":@"1"};
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage hotCarSubmitOrderInfoWithDict:dic withSuccessBlock:^(NSDictionary *dic) {
        [JSFProgressHUD hiddenHUD:self.view];
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:dic];
        if ([model.info isEqualToString:@"ok"]) {
            VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
            vc.orderID = model.data[@"orderId"];
            vc.moneyType = @"10";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.info];
            HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
            [alertCtrl addAction:Action];
            [self presentViewController:alertCtrl animated:NO completion:nil];
        }
    } withFailureBlock:^(NSString *result_msg) {
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}

- (void)chooseAddressBtnClick{
    EditAddressViewController *vc =[[EditAddressViewController alloc]init];
    vc.delegate = self;
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-----rentCarChooseAddressDelegate------
- (void)rentCarChooseAddressModel:(AddressListModel *)model{
    _chooseCity = YES;
    _chooseAddresslabel.hidden = YES;
    _topAddresslabel.text = model.address;
    _addressID = model.addressID;
}


//当时间改变时触发
- (void)changeTime:(NSDate *)date;
{
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
//    NSString *backDateStr = [dateFormatter stringFromDate:date];
//    [_chooseTimebutton setTitle:backDateStr forState:UIControlStateNormal];
//    [_chooseTimebutton setTitleColor:kdetailColor forState:UIControlStateNormal];
}


//确定时间
- (void)determine:(NSDate *)date;
{
    //获取当前时间，让时间整30显示
    NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
    late1 = (long)(late1/1800)*1800+3600;
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components = [cal components:NSMinuteCalendarUnit fromDate:[NSDate date]];
//    if ([components minute]>0) {
//        late1 = (long)(late1/1800)*1800+3600;
//    }
    
    NSTimeInterval chooseTime = [date timeIntervalSince1970];
    if (late1 >= chooseTime) {
        chooseTime = late1;
    }
    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
//    NSString *backDateStr = [dateFormatter stringFromDate:date];
    _chooseTimeStr = [CustomTool changChineseTimeStr:kFormat(@"%ld", (long)chooseTime)];
    [_chooseTimebutton setTitle:_chooseTimeStr forState:UIControlStateNormal];
    [_chooseTimebutton setTitleColor:kdetailColor forState:UIControlStateNormal];
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
