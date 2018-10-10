//
//  VFConfirmOrderViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/20.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFConfirmOrderViewController.h"
#import "EditAddressViewController.h"
#import "defaultAdressModel.h"
#import "VFPayMoneyDetailViewController.h"
#import "zySheetPickerView.h"
#import "LZCityPickerController.h"
#import "TXTimeChoose.h"
#import "AddressModel.h"
#import "WebViewVC.h"
#import "VForderMoneyDetailModel.h"
#import "LoginViewController.h"

#import "VFChoosePayViewController.h"
#import "VFChooseRentDayViewController.h"
#import "VFCarDetailViewController.h"

#import "VFRealNameAuthenticationModel.h"
#import "ZJSwitch.h"
#import "VFConfirmOrderTableViewCell.h"
#import "VFUseCarUseeListModel.h"
#import "VFTwoColumnsSheetPickerView.h"
#import "VFCreateOrederModel.h"
#import "VFChooseAddressModel.h"
#import "VFChooseUseCarUserView.h"
#import "VFCarDetailModel.h"

#import "VFChooseUseCarAddressView.h"

@interface VFConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,TXTimeDelegate,VFChooseRentDaysDeleaget,UIAlertViewDelegate,UIScrollViewDelegate,chooseUseCarUeserViewCellDelegate,chooseUseCarAddressViewCellDelegate>{
}

@property (nonatomic , strong) BaseTableView *tableView;

@property (nonatomic, strong) UITextField * addressText;
@property (nonatomic, strong) NSString * chooseAddress;
@property (nonatomic, strong) NSString * chooseAddressId;

@property (nonatomic, assign) BOOL chooseCity;

//个人信息全局变量
@property (nonatomic, strong) UITextField * nameTextField;
@property (nonatomic, strong) UITextField * mobileTextField;

@property (nonatomic, strong) UIView *carDetailView;
@property (nonatomic, strong) UIView *rentCarTimeView;
@property (nonatomic, strong) UILabel *carUseLabel;
@property (nonatomic, strong) UILabel *getCarFuncLabel;

@property (nonatomic, strong) NSString *getCarFunc;

@property (nonatomic, strong) UILabel * rentDaylabel;

@property (nonatomic, strong) UILabel *showPayMoney;


@property (nonatomic, strong) UILabel *rentCity;
@property (nonatomic, strong) UILabel *backCity;
@property (nonatomic, strong) NSString *rentCityID;
@property (nonatomic, strong) NSString *backCityID;

@property (nonatomic, strong) TXTimeChoose *timeV;
@property (nonatomic, assign) NSInteger  index;

@property (nonatomic, strong) UILabel *rentTime;
@property (nonatomic, strong) UILabel *backTime;
@property (nonatomic, strong) UILabel *rentClock;
@property (nonatomic, strong) UILabel *backClock;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *payMoneyView;
@property (nonatomic, strong) UILabel *payMoneylabel;


@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UIButton *agreenmentButton;
@property (nonatomic, strong) NSDictionary *rentCityDic;
@property (nonatomic, strong) NSDictionary *backCityDic;
@property (nonatomic, strong) NSString *header;

@property (nonatomic, strong) UIView *agreenmentView;

@property (nonatomic, strong) NSString *chooseRentTime;
@property (nonatomic, strong) NSString *chooseBackTime;

@property (nonatomic, strong)  NSString *isFreeDeposit;
@property (nonatomic, strong)  NSMutableArray *usePeopleArr;
@property (nonatomic, strong)  NSMutableArray *useMobileArr;
@property (nonatomic, strong)  NSMutableArray *dataArr;

@property (nonatomic, strong)  NSArray *addressArr;

@property (nonatomic, strong)  VFCarDetailModel *carDeatilModel;
@property (nonatomic, strong)  NSString *rentDays;
@property (nonatomic, strong)  UILabel *allMoneyLabel;

@end

@implementation VFConfirmOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _usePeopleArr = [[NSMutableArray alloc]init];
    _useMobileArr = [[NSMutableArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
    _addressArr = [[NSArray alloc]init];
    _chooseAddressId = @"0";
    self.getCarFunc = @"2";
    _rentDays = @"3";
    self.UMPageStatistical = @"orderForm";
    _rentCityID = @"938";//杭州市拱墅区
    _backCityID = @"938";
    _addressText.text = @"0";
    _isFreeDeposit = @"1";
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    _rentCityID = cityID;
    _backCityID = cityID;
    _rentCityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    _backCityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    self.header = @"创建订单";
    [self createPayMoneyView];
    [self createView];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:_tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
    [self loadData];
}

- (void)loadData{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [VFHttpRequest usePeopleParameter:@{@"token":token} successBlock:^(NSDictionary *data) {
        VFBaseListMode *obj = [[VFBaseListMode alloc]initWithDic:data];
        for (NSDictionary *dic in obj.data) {
            VFUseCarUseeListModel *model = [[VFUseCarUseeListModel alloc]initWithDic:dic];
            [_dataArr addObject:dic];
            [_usePeopleArr addObject:model.nick_name];
            [_useMobileArr addObject:model.mobile];
        }
        if (_dataArr.count  > 0) {
            VFUseCarUseeListModel *model = [[VFUseCarUseeListModel alloc]initWithDic:_dataArr[0]];
            _nameTextField.text = model.nick_name;
            _mobileTextField.text = model.mobile;
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
    
    [VFHttpRequest addressParameter:@{} successBlock:^(NSDictionary *data) {
        VFBaseListMode *obj = [[VFBaseListMode alloc]initWithDic:data];
        _addressArr = obj.data;
        if (_addressArr.count>0) {
            VFChooseAddressModel *obj = [[VFChooseAddressModel alloc]initWithDic:_addressArr[0]];
            _addressText.text = obj.address;
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH-kSafeBottomH-49) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.header = _header;
    [_tableView  setSeparatorColor:kHomeLineColor];
    [_tableView registerClass:[VFConfirmOrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-49-kSafeBottomH, kScreenW, 49)];
    [self.view addSubview:bottomView];
    
    int payMoney = [self.model.price intValue]/3;
    if ([self.model.price intValue] %100 > 0) {
        payMoney = [self.model.price intValue]/3/100*101;
    }else{
        payMoney = [self.model.price intValue]/3/100*100;
    }
    _showPayMoney = [UILabel initWithTitle:kFormat(@"需支付订金 ¥%d",payMoney) withFont:kTitleBigSize textColor:kWhiteColor];
    _showPayMoney.frame = CGRectMake(0, 0, kScreenW-132, 49);
    _showPayMoney.textAlignment = NSTextAlignmentCenter;
    _showPayMoney.backgroundColor = kBarBgColor;
    [bottomView addSubview:_showPayMoney];
    
    UIButton *button = [UIButton newButtonWithTitle:@"确认支付"  sel:@selector(payButtonClick) target:self cornerRadius:NO];
    button.frame = CGRectMake(kScreenW-132, 0, 132, 49);
    [bottomView addSubview:button];
}

#pragma mark-----------------tableView的代理方法-----------------

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 282)];
    [headerView addSubview:[self createCarDetailView]];
    [headerView addSubview:[self createRentCarTimeView]];
    [self getMoneyLoadData];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [self createAgreementView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 282;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        if ([_getCarFunc isEqualToString:@"2"]) {
            return 56;
        }else{
            return 0;
        }
    }
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFConfirmOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFormat(@"%zi%zi", indexPath.section,indexPath.row)];
    if (cell == nil) {
        cell = [[VFConfirmOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kFormat(@"%zi%zi", indexPath.section,indexPath.row)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *dataArr = @[@"是否申请免押金",@"取车方式",@"详细送车地址",@"姓名",@"电话",@"备注"];
    cell.leftLabel.text = dataArr[indexPath.row];
    cell.indexRow = kFormat(@"%ld", indexPath.row);
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.switchCar.tag = indexPath.row;
         [cell.switchCar addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    }
    
    if (indexPath.row == 2) {
        if ([_getCarFunc isEqualToString:@"2"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
    }
    switch (indexPath.row) {
        case 2:
            _addressText = cell.textField;
            break;
        case 3:
            _nameTextField = cell.textField;
            if (_dataArr.count>0) {
                VFUseCarUseeListModel *model = [[VFUseCarUseeListModel alloc]initWithDic:_dataArr[0]];
                _nameTextField.text = model.nick_name;
            }
            break;
        case 4:
            _mobileTextField = cell.textField;
            if (_dataArr.count>0) {
                VFUseCarUseeListModel *model = [[VFUseCarUseeListModel alloc]initWithDic:_dataArr[0]];
                _mobileTextField.text = model.mobile;
            }
            break;
        case 5:
            _remarkTextField = cell.textField;
            break;
        default:
            break;
    }
    
    cell.textField.tag = indexPath.row;
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

//输入框限定字符长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 2) {
        if (textField.text.length > 40) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:40];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }else if(textField.tag == 3) {
            if (textField.text.length > 15) {
                UITextRange *markedRange = [textField markedTextRange];
                if (markedRange) {
                    return;
                }
                NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:15];
                textField.text = [textField.text substringToIndex:range.location];
            }
    }else if(textField.tag == 4) {
        if (textField.text.length > 11) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:11];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    else{
        if (textField.text.length > 40) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:40];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    
}


- (void)handleSwitchEvent:(ZJSwitch *)sender{
    kWeakSelf;
    if (sender.tag == 0) {
        if (sender.isOn) {
            _isFreeDeposit = @"0";
        }else{
            HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"免押金需要您提供个人财产信息，如房产证、车辆行驶证等，提供越全，审核通过几率越大。"];
            HCAlertAction *Action = [HCAlertAction actionWithTitle:@"取消" handler:^(HCAlertAction *action) {
                [sender setOn:YES];
            }];
            [alertCtrl addAction:Action];
            HCAlertAction *sureAction = [HCAlertAction actionWithTitle:@"确定申请" handler:^(HCAlertAction *action) {
                _isFreeDeposit = @"1";
            }];
            [alertCtrl addAction:sureAction];
            [weakSelf presentViewController:alertCtrl animated:NO completion:nil];
        }
    }else{
        if (sender.isOn) {
            _getCarFunc = @"2";
        }else{
            _getCarFunc = @"1";
        }
        [_tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        if (_addressArr.count>0) {
            [_nameTextField resignFirstResponder];
            [_mobileTextField resignFirstResponder];
        }else{
            [CustomTool showOptionMessage:@"暂无可供选择地址，请输入"];
            return;
        }
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in _addressArr) {
            VFChooseAddressModel *obj = [[VFChooseAddressModel alloc]initWithDic:dic];
            [tempArr addObject:obj.address];
        }
//        zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:tempArr andHeadTitle:@"选择地址" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
//            _addressText.text = choiceString;
//        }];
//
//        
//
//        [pickerView show];
        VFChooseUseCarAddressView *view = [[VFChooseUseCarAddressView alloc]init];
        view.delegate = self;
        [view show:@"请选择地址" dataArr:tempArr];
    }
    
    if (indexPath.row == 3 || indexPath.row == 4) {
        if (_usePeopleArr.count>0) {
            [_nameTextField resignFirstResponder];
            [_mobileTextField resignFirstResponder];
        }else{
            [CustomTool showOptionMessage:@"暂无可供选择信息，请输入"];
            return;
        }
//        VFTwoColumnsSheetPickerView *pickerView = [VFTwoColumnsSheetPickerView VFTwoColumnsSheetPickerViewWithTitle:_usePeopleArr rightArr:_useMobileArr andHeadTitle:@"选择信息" Andcall:^(VFTwoColumnsSheetPickerView *pickerView, NSString *name, NSString *mobile) {
//            _nameTextField.text = name;
//            _mobileTextField.text = mobile;
//        }];
//        [pickerView show];
        NSArray *tempArr = _dataArr;
        VFChooseUseCarUserView *view = [[VFChooseUseCarUserView alloc]init];
        view.delegate = self;
        [view show:@"请选择用车人" dataArr:tempArr];
    }
}

- (void)chooseUseCarAddressClick:(NSString *)str{
    _addressText.text = str;
}

- (void)chooseUseCarUeserClick:(VFUseCarUseeListModel *)model{
    _nameTextField.text = model.nick_name;
    _mobileTextField.text = model.mobile;
}

- (void)payButtonClick{
    if (!_agreenmentButton.selected) {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请先同意用户租车协议哦"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
        return;
    }
    [self loadPayMoney];
}


- (void)loadPayMoney{
    NSString *carID = _model.carId;
    NSString *useStartTime = [CustomTool toDateChangTimeStr:kFormat(@"%@", _chooseRentTime)];
    NSString *useEndTime =[CustomTool toDateChangTimeStr:kFormat(@"%@", _chooseBackTime)];
    NSString *getCityId = _rentCityID;
    NSString *returnCityId = _backCityID;
    NSString *getCarFunc = _getCarFunc;
    NSDictionary *dic;
    
    if ([_nameTextField.text isEqualToString:@""]) {
        [CustomTool alertViewShow:@"请输入姓名"];
        return;
    }
    
    if (![CustomTool IsPhoneNumber:_mobileTextField.text]) {
        [CustomTool alertViewShow:@"请输入手机号"];
        return;
    }
    
    if ([getCarFunc isEqualToString:@"2"]) {
        
        if ([_addressText.text isEqualToString:@""]) {
            [CustomTool alertViewShow:@"请输入送车地址"];
            return;
        }
    
        for (NSDictionary *dic in _addressArr) {
            VFChooseAddressModel *obj = [[VFChooseAddressModel alloc]initWithDic:dic];
            if ([obj.address isEqualToString:_addressText.text]) {
                _chooseAddressId = obj.address_id;
            }
        }
        
        if ([_chooseAddressId intValue] == 0) {
            dic =@{@"nick_name":_nameTextField.text,@"mobile":_mobileTextField.text,@"car_id":carID,@"start_date":useStartTime,@"end_date":useEndTime,@"get_city":getCityId,@"return_city":returnCityId,@"get_func":getCarFunc,@"sent_address":_addressText.text,@"free_deposit":_isFreeDeposit,@"remark":_remarkTextField.text?_remarkTextField.text:@""};
        }else{
            dic =@{@"nick_name":_nameTextField.text,@"mobile":_mobileTextField.text,@"car_id":carID,@"start_date":useStartTime,@"end_date":useEndTime,@"get_city":getCityId,@"return_city":returnCityId,@"get_func":getCarFunc,@"address_id":_chooseAddressId,@"free_deposit":_isFreeDeposit,@"remark":_remarkTextField.text?_remarkTextField.text:@""};
        }

    }else{
        dic =@{@"nick_name":_nameTextField.text,@"mobile":_mobileTextField.text,@"car_id":carID,@"start_date":useStartTime,@"end_date":useEndTime,@"get_city":getCityId,@"return_city":returnCityId,@"get_func":getCarFunc,@"free_deposit":_isFreeDeposit,@"remark":_remarkTextField.text?_remarkTextField.text:@""};
    }
    
    [JSFProgressHUD showHUDToView:self.view];
    [VFHttpRequest createOrderParameter:dic successBlock:^(NSDictionary *data) {
        
        [JSFProgressHUD hiddenHUD:self.view];
        
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        if ([model.code intValue] == 1) {
            VFChoosePayViewController *vc = [[VFChoosePayViewController alloc]init];
            VFCreateOrederModel *obj = [[VFCreateOrederModel alloc]initWithDic:model.data];
            vc.moneyType = obj.should_pay_id;
            vc.orderID =  obj.order_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.message];
            HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
            [alertCtrl addAction:Action];
            [self presentViewController:alertCtrl animated:NO completion:nil];
            [JSFProgressHUD hiddenHUD:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}



- (void)getMoneyLoadData{
    NSString *carID = _model.carId;
    NSString *useStartTime = [CustomTool toDateChangTimeStr:kFormat(@"%@", _chooseRentTime)];
    NSString *useEndTime =[CustomTool toDateChangTimeStr:kFormat(@"%@", _chooseBackTime)];
    NSString *getCityId = _rentCityID;
    NSString *returnCityId = _backCityID;
    NSInteger days = ([useEndTime integerValue] - [useStartTime integerValue])/86400;
    _rentDaylabel.text = [NSString stringWithFormat:@"%zi天",days];
    _rentDays = kFormat(@"%zi", days);
    [VFHttpRequest getCarDetailParameter:carID dic:@{@"city_id":getCityId} successBlock:^(NSDictionary *data) {
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        VFCarDetailModel *obj = [[VFCarDetailModel alloc]initWithDic:model.data];
        _carDeatilModel = obj;
        _payMoneylabel.text = kFormat(@"总租金 ¥%zi",[obj.price intValue] * days);
        _showPayMoney.text = kFormat(@"需支付订金 ¥%@",obj.first_price);
        _priceLabel.text = kFormat(@"¥%@元/天",obj.price);
        _allMoneyLabel.text = kFormat(@"总计 ¥%d", [_model.price intValue]*[_rentDays intValue]);
        NSRange range = [_payMoneylabel.text rangeOfString:@"¥"];
        [CustomTool setTextColor:_payMoneylabel FontNumber:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleSize] AndRange:range AndColor:kTitleBoldColor];
    } withFailureBlock:^(NSError *error) {
        
    }];
}


- (UIView *)createCarDetailView{
    _carDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 105)];
    UIImageView *carImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 100, 75)];
    [carImage sd_setImageWithURL:[NSURL URLWithString:_model.images[0]] placeholderImage:nil];
    [_carDetailView addSubview:carImage];
    
    UILabel *titleLabel = [UILabel initWithTitle:kFormat(@"%@%@",_model.brand, _model.model) withFont:kTextBigSize textColor:kdetailColor];
    titleLabel.frame = CGRectMake(carImage.right + 15, 15, 200, 20);
    [_carDetailView addSubview:titleLabel];
    
    _priceLabel = [UILabel initWithTitle:kFormat(@"¥%@元/天", _model.price) withFont:kTextBigSize textColor:kNewSelectColor];
    _priceLabel.frame = CGRectMake(carImage.right + 15, titleLabel.bottom, 200, 20);
    [_carDetailView addSubview:_priceLabel];
    
    _allMoneyLabel = [UILabel initWithTitle:kFormat(@"总计 ¥%d", [_model.price intValue]*[_rentDays intValue]) withFont:kTitleSize textColor:kMainColor];
    [_allMoneyLabel setFont:[UIFont fontWithName:kBlodFont size:kTitleSize]];
    _allMoneyLabel.frame = CGRectMake(carImage.right + 15, _priceLabel.bottom+8, 200, 25);
    [_carDetailView addSubview:_allMoneyLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenW, 135);
    [button addTarget:self action:@selector(jumpCarDetail) forControlEvents:UIControlEventTouchUpInside];
    [_carDetailView addSubview:button];
    return _carDetailView;
}

- (void)jumpCarDetail{
    VFCarDetailViewController *vc = [[VFCarDetailViewController alloc]init];
    vc.carId = self.model.carId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)createRentCarTimeView{
    _rentCarTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, _carDetailView.bottom, kScreenW, 182)];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 180)];
    grayView.backgroundColor = kViewBgColor;
    [_rentCarTimeView addSubview:grayView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 111)];
    [grayView addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"image_day"];
    [topView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(48);
    }];
    
    _rentDaylabel = [UILabel initWithTitle:@"3天" withFont:kTextSize textColor:kTextBlueColor];
    _rentDaylabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_rentDaylabel];
    [_rentDaylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *timeTitle = [UILabel initWithTitle:@"取车时间" withFont:kTextSize textColor:kNewDetailColor];
    [topView addSubview:timeTitle];
    [timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(17);
    }];
    
    UIImageView *rentTimeImage = [self createImageView:[UIImage imageNamed:@"icon_more_gray"]];
    [topView addSubview:rentTimeImage];
    [rentTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.equalTo(timeTitle.mas_right).offset(4);
        make.width.height.mas_equalTo(6);
    }];

    
    UILabel *rightTimeTitle = [UILabel initWithTitle:@"还车时间" withFont:kTextSize textColor:kNewDetailColor];
    rightTimeTitle.frame = CGRectMake(kScreenW-125, 20, 100, 17);
    rightTimeTitle.textAlignment = NSTextAlignmentRight;
    [topView addSubview:rightTimeTitle];
    
    UIImageView *backTimeImage = [self createImageView:[UIImage imageNamed:@"icon_more_gray"]];
    [topView addSubview:backTimeImage];
    [backTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.equalTo(rentTimeImage);
        make.width.height.mas_equalTo(6);
    }];
    
    //获取当前时间，让时间整30显示
    NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSMinuteCalendarUnit fromDate:[NSDate date]];
    if ([components minute]>0) {
        late1 = (long)(late1/1800)*1800+1800;
    }
    
    late1  = late1 + 1800;
    NSTimeInterval late2= late1+86400*3;
    NSDateFormatter *dated=[[NSDateFormatter alloc] init];
    [dated setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSString *leftStr = [dated stringFromDate:[NSDate dateWithTimeIntervalSince1970:late1]];
    NSString *rightStr = [dated stringFromDate:[NSDate dateWithTimeIntervalSince1970:late2]];
    
    _chooseRentTime = leftStr;
    _chooseBackTime = rightStr;
    
    NSString *leftTime = kFormat(@"%@ %@", [CustomTool changTimeStr:kFormat(@"%fd", late1) formatter:@"MM/dd"],[CustomTool changWeekStr:kFormat(@"%fd", late1)]);
    NSString *rightTime = kFormat(@"%@ %@", [CustomTool changTimeStr:kFormat(@"%fd", late2) formatter:@"MM/dd"],[CustomTool changWeekStr:kFormat(@"%fd", late2)]);
    
    NSString *leftClock = [leftStr substringFromIndex:leftStr.length- 5];
    NSString *rightClock = [rightStr substringFromIndex:rightStr.length- 5];
    
    
    _rentTime = [UILabel initWithTitle:leftTime withFont:kTitleBigSize textColor:kTitleBoldColor];
    _rentTime.frame = CGRectMake(15, rightTimeTitle.bottom+10, 150, 22);
    [_rentTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    [topView addSubview:_rentTime];
    
    _backTime = [UILabel initWithTitle:rightTime withFont:kTitleBigSize textColor:kTitleBoldColor];
    _backTime.frame = CGRectMake(kScreenW-165, rightTimeTitle.bottom+10, 150, 22);
    _backTime.textAlignment = NSTextAlignmentRight;
    [_backTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    [topView addSubview:_backTime];
    
    _rentClock = [UILabel initWithTitle:leftClock withFont:kTitleBigSize textColor:kdetailColor];
    _rentClock.frame = CGRectMake(15, _rentTime.bottom, 150, 22);
    [topView addSubview:_rentClock];
    
    _backClock = [UILabel initWithTitle:rightClock withFont:kTitleBigSize textColor:kdetailColor];
    _backClock.frame = CGRectMake(kScreenW-165, _backTime.bottom, 150, 22);
    _backClock.textAlignment = NSTextAlignmentRight;
    [topView addSubview:_backClock];
    
    UIButton *rentTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rentTimeButton.frame = CGRectMake(0, 0, (kScreenW-68)/2,  topView.height);
    rentTimeButton.tag = 1000;
    [rentTimeButton addTarget:self action:@selector(chooseTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rentTimeButton];
    
    UIButton *backTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backTimeButton.frame = CGRectMake(kScreenW-(kScreenW-68)/2, 0, (kScreenW-68)/2, topView.height);
    backTimeButton.tag = 1001;
    [backTimeButton addTarget:self action:@selector(chooseTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backTimeButton];
    
    UIButton *chooseRentDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseRentDayButton.frame = CGRectMake((kScreenW-68)/2, 0, 68, 69);
    [chooseRentDayButton addTarget:self action:@selector(chooseRentDayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:chooseRentDayButton];
    
    UILabel *cityTitle = [UILabel initWithTitle:@"取车城市" withFont:kTextSize textColor:kNewDetailColor];
    cityTitle.frame = CGRectMake(15, topView.bottom, 100, 17);
    [_rentCarTimeView addSubview:cityTitle];
    [cityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(111);
        make.height.mas_equalTo(17);
    }];
    
    UIImageView *rentCityImage = [self createImageView:[UIImage imageNamed:@"icon_more_gray"]];
    [_rentCarTimeView addSubview:rentCityImage];
    [rentCityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(117);
        make.left.equalTo(cityTitle.mas_right).offset(4);
        make.width.height.mas_equalTo(6);
    }];
    
    UILabel *rightCityTitle = [UILabel initWithTitle:@"还车城市" withFont:kTextSize textColor:kNewDetailColor];
    rightCityTitle.frame = CGRectMake(kScreenW-125, cityTitle.top, 100, 17);
    rightCityTitle.textAlignment = NSTextAlignmentRight;
    [_rentCarTimeView addSubview:rightCityTitle];
    
    UIImageView *backCityImage = [self createImageView:[UIImage imageNamed:@"icon_more_gray"]];
    [_rentCarTimeView addSubview:backCityImage];
    [backCityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(117);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(6);
    }];
    
    NSDictionary *cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    VFNotificationCityModel *model = [[VFNotificationCityModel alloc]initWithDic:cityDic];
    
    _rentCity = [UILabel initWithTitle:kFormat(@"%@%@", model.cityName,model.countyName) withFont:kTitleBigSize textColor:kTitleBoldColor];
    [_rentCity setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    _rentCity.frame = CGRectMake(15, rightCityTitle.bottom+10, (kScreenW-30)/2, 22);
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCityTap:)];
//    _rentCity.userInteractionEnabled=YES;
//    [_rentCity addGestureRecognizer:tapGesture];
    [_rentCarTimeView addSubview:_rentCity];
    
    UIButton *rentCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rentCityButton addTarget:self action:@selector(chooseCityTap:) forControlEvents:UIControlEventTouchUpInside];
    rentCityButton.frame = CGRectMake(15, cityTitle.top, (kScreenW-30)/2, 60);
    [_rentCarTimeView addSubview:rentCityButton];
    
    
    _backCity = [UILabel initWithTitle:kFormat(@"%@%@", model.cityName,model.countyName) withFont:kTitleBigSize textColor:kTitleBoldColor];
    [_backCity setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    _backCity.frame = CGRectMake(kScreenW-(kScreenW-30)/2-15, rightCityTitle.bottom+10, (kScreenW-30)/2, 22);
//    UITapGestureRecognizer *rightTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBackCityTap:)];
//    _backCity.userInteractionEnabled=YES;
//    [_backCity addGestureRecognizer:rightTapGesture];
    _backCity.textAlignment = NSTextAlignmentRight;
    [_rentCarTimeView addSubview:_backCity];
    
    UIButton *backCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backCityButton addTarget:self action:@selector(chooseBackCityTap:) forControlEvents:UIControlEventTouchUpInside];
    backCityButton.frame = CGRectMake(kScreenW-(kScreenW-30)/2-15, rightCityTitle.top, (kScreenW-30)/2, 60);
    [_rentCarTimeView addSubview:backCityButton];
    
    return _rentCarTimeView;
}

#pragma mark----------创建指示图片----------------
- (UIImageView *)createImageView:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (void)choosebuttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self chooseCarFunc];
            break;
        case 1:
            [self chooseCarUse];
            break;
        default:
            break;
    }
}

- (UIView *)createAgreementView{
    _agreenmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 62)];
    _agreenmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreenmentButton.frame = CGRectMake((kScreenW-240)/2, 17, 22, 22);
    [_agreenmentButton setImage:[UIImage imageNamed:@"icon_checkbox_off"] forState:UIControlStateNormal];
    [_agreenmentButton setImage:[UIImage imageNamed:@"icon_checkbox_on"] forState:UIControlStateSelected];
    _agreenmentButton.selected = YES;
    [_agreenmentButton addTarget:self action:@selector(agreentmentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_agreenmentView addSubview:_agreenmentButton];
    UILabel *readingLabel = [UILabel initWithTitle:@"阅读并同意" withFont:kTextBigSize textColor:kdetailColor];
    [_agreenmentView addSubview:readingLabel];
    [readingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(_agreenmentButton.right+5);
        make.top.mas_offset(17);
        make.height.mas_offset(22);
    }];
    
    UIButton *agreenUrl = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreenUrl setTitle:@"《威风出行租车协议》" forState:UIControlStateNormal];
    [agreenUrl setTitleColor:kTextBlueColor forState:UIControlStateNormal];
    [agreenUrl.titleLabel setFont:[UIFont systemFontOfSize:kTextBigSize]];
    [agreenUrl addTarget:self action:@selector(agreenUrl) forControlEvents:UIControlEventTouchUpInside];
    [_agreenmentView addSubview:agreenUrl];
    [agreenUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(readingLabel.mas_right);
        make.top.equalTo(_agreenmentView);
        make.height.mas_equalTo(62);
    }];
    
    if (_freeDeposit) {
        _agreenmentButton.frame = CGRectMake(15, 15, 16, 16);
        readingLabel.font =[UIFont systemFontOfSize:kSpaceW(kTextSize)];
        [readingLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(_agreenmentButton.right+5);
            make.top.mas_offset(15);
            make.height.mas_offset(17);
        }];
        agreenUrl.titleLabel.font = [UIFont systemFontOfSize:kSpaceW(kTextSize)];
        [agreenUrl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(readingLabel.mas_right);
            make.height.mas_equalTo(47);
        }];
        
        UILabel *label = [UILabel initWithTitle:@"，" withFont:kSpaceW(kTextSize) textColor:kdetailColor];
        [_agreenmentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(agreenUrl.mas_right);
            make.top.equalTo(readingLabel);
            make.height.equalTo(readingLabel);
        }];
        
        UIButton *freeDepositBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [freeDepositBtn setTitle:@"《免押金服务协议》" forState:UIControlStateNormal];
        freeDepositBtn.titleLabel.font = [UIFont systemFontOfSize:kSpaceW(kTextSize)];
        [freeDepositBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        [freeDepositBtn addTarget:self action:@selector(jumpButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_agreenmentView addSubview:freeDepositBtn];
        [freeDepositBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.top.equalTo(agreenUrl);
            make.height.mas_equalTo(47);
        }];
    }
    return _agreenmentView;
}

- (void)jumpButtonClick{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    GlobalConfigModel *obj = [[GlobalConfigModel alloc]initWithDic:dic];
    WebViewVC *vc = [[WebViewVC alloc]init];
    vc.urlStr = obj.freeDepositUrl;
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

- (void)createPayMoneyView{

    _payMoneyView = [[UIView alloc]initWithFrame:CGRectMake(0, _rentCarTimeView.bottom, kScreenW, 98)];
//    [_scrollView addSubview:_payMoneyView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 1)];
    lineView.backgroundColor = klineColor;
    [_payMoneyView addSubview:lineView];
    
    _payMoneylabel = [UILabel initWithTitle:@"总租金 ¥0" withFont:kNewTitle textColor:kTitleBoldColor];
    _payMoneylabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kNewTitle];
    _payMoneylabel.frame = CGRectMake(15, 20, kScreenW-30, 33);
    [_payMoneyView  addSubview:_payMoneylabel];
    
    NSRange range = [_payMoneylabel.text rangeOfString:@"¥"];
    [CustomTool setTextColor:_payMoneylabel FontNumber:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleSize] AndRange:range AndColor:kTitleBoldColor];
    
    UILabel *monryDetail = [UILabel initWithTitle:@"点击查看付款明细" withFont:kTextBigSize textColor:kMainColor];
    [_payMoneyView addSubview:monryDetail];
    [monryDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(57);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *redImage = [self createImageView:[UIImage imageNamed:@"icon_more_red"]];
    [_payMoneyView addSubview:redImage];
    [redImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monryDetail.mas_right).offset(4);
        make.top.mas_equalTo(65);
        make.width.height.mas_equalTo(6);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, _payMoneylabel.bottom, kScreenW, 45);
    [button addTarget:self action:@selector(payMoneyDetail) forControlEvents:UIControlEventTouchUpInside];
    [_payMoneyView addSubview:button];
}

- (void)chooseAddressBtnClick{
    EditAddressViewController *vc =[[EditAddressViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)chooseCarUse{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    NSArray *str = dic[@"useType"];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"选择车辆用途" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        _carUseLabel.text = choiceString;
        [pickerView dismissPicker];
    }];
    [pickerView show];
}

- (void)chooseCityTap:(UIGestureRecognizer *)tap{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [LZCityPickerController showPickerInViewController:self selectDic:_rentCityDic selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area, NSString *code) {
        _rentCityID = code;
        _rentCity.text = [NSString stringWithFormat:@"%@%@",city,area];
        [self getMoneyLoadData];
        _rentCityDic = @{@"provinceName":province,@"provinceID":@"",@"cityName":city,@"cityID":@"",@"countyName":area,@"countyID":code};
    }];
}

- (void)chooseBackCityTap:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [LZCityPickerController showPickerInViewController:self selectDic:_backCityDic selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area, NSString *code) {
        _backCityID = code;
        _backCity.text = [NSString stringWithFormat:@"%@%@",city,area];
        _backCityDic = @{@"provinceName":province,@"provinceID":@"",@"cityName":city,@"cityID":@"",@"countyName":area,@"countyID":code};;
    }];
}

- (void)chooseCarFunc{
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:@[@"送车上门",@"到店取车"] andHeadTitle:@"选择取车方式" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        _getCarFuncLabel.text = choiceString;
        if ([choiceString isEqualToString:@"送车上门"]) {
            _getCarFunc = @"2";
        }else{
            _getCarFunc = @"1";
        }
        [pickerView dismissPicker];
    }];
    [pickerView show];
}

#pragma mark----------选择时间-----
- (void)chooseTimeBtn:(UIButton*)sender
{
    _index = sender.tag;
    self.timeV = nil;
    [self.view addSubview:self.timeV];
    NSString *beginStr = _chooseRentTime;
    NSString *endStr = _chooseBackTime;
    if (sender.tag == 1000) {
        [self.timeV setNowTime:beginStr];
    }else if(sender.tag == 1001){
        [self.timeV setNowTime:endStr];
    }else{
        
    }
}

- (void)chooseRentDayButtonClick{
    VFChooseRentDayViewController *vc = [[VFChooseRentDayViewController alloc]init];
    vc.delegate = self;
    vc.days = _rentDays;
    vc.dataModel = _carDeatilModel;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark ----------------选择天数回来的代理方法-------------------------
- (void)chooseRentDays:(NSString *)days{
//    NSString *startStr = [NSString stringWithFormat:@"%@ %@",_rentTime.text,_rentClock.text];
    NSString *startStr = _chooseRentTime;
    NSDateFormatter *dateM=[[NSDateFormatter alloc] init];
    [dateM setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate *data=[dateM dateFromString:startStr];
    NSTimeInterval late=[data timeIntervalSince1970];
    
    NSTimeInterval backLate = late +[days intValue]*86400;
    NSString *time = [CustomTool changTimeStr:kFormat(@"%fd", backLate) formatter:@"yyyy年MM月dd日 HH:mm"];
    _chooseBackTime = time;
    
    _backTime.text = kFormat(@"%@ %@", [CustomTool changTimeStr:kFormat(@"%fd", backLate) formatter:@"MM/dd"],[CustomTool changWeekStr:kFormat(@"%fd", backLate)]);
    _backClock.text =_rentClock.text;
    [self getMoneyLoadData];
}


//懒加载
- (TXTimeChoose *)timeV{
    
    if (!_timeV) {
        if (_index==1000) {
            self.timeV = [[TXTimeChoose alloc]initWithFrame:self.view.bounds type:UIDatePickerModeDateAndTime tag:_index];
        }else{
            self.timeV = [[TXTimeChoose alloc]initWithFrame:self.view.bounds type:UIDatePickerModeDateAndTime tag:_index];
        }
        self.timeV.delegate = self;
    }
    return _timeV;
}

#pragma mark--------TXTimeDelegate-------------
//当时间改变时触发
- (void)changeTime:(NSDate *)date
{
    
}

//确定时间
- (void)determine:(NSDate *)date
{
    NSString *getStr = [self.timeV stringFromDate:date];
    NSDateFormatter *dateM=[[NSDateFormatter alloc] init];
    [dateM setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSTimeInterval getLate;
    NSTimeInterval backLate;
    if (_index==1000) {
        NSDate *getDate=[dateM dateFromString:getStr];
        NSString *backStr = _chooseBackTime;
        NSDate *backDate=[dateM dateFromString:backStr];
        
        getLate=[getDate timeIntervalSince1970];
        backLate=[backDate timeIntervalSince1970];
        
        //获取当前时间，让时间整30显示
        NSTimeInterval nowLate=[[NSDate date] timeIntervalSince1970];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSMinuteCalendarUnit fromDate:[NSDate date]];
        
        if (getLate <nowLate) {
            if ([components minute]>0) {
                nowLate = (long)(getLate/1800)*1800+1800;
            }
            nowLate  = nowLate + 1800;
            if (getLate<=nowLate) {
                getLate = nowLate;
            }
        }
        
        NSString *chooseRentTime = [CustomTool changChineseTimeStr:kFormat(@"%ld", (long)getLate)];
        _chooseRentTime = chooseRentTime;
        NSString *rentTime = [CustomTool changTimeStr:kFormat(@"%ld", (long)getLate) formatter:@"MM/dd HH:mm"];
        _rentTime.text = [NSString stringWithFormat:@"%@ %@",[rentTime substringToIndex:5],[CustomTool changWeekStr:kFormat(@"%fd", getLate)]];
        _rentClock.text = [rentTime substringFromIndex:rentTime.length - 5];
        _backClock.text = _rentClock.text;
        if (backLate-getLate<86400) {
            NSTimeInterval endDate= getLate+86400;
            NSString *chooseBackTime = [CustomTool changChineseTimeStr:kFormat(@"%ld", (long)endDate)];
            _chooseBackTime = chooseBackTime;
            
            NSString *backStr = [CustomTool changTimeStr:kFormat(@"%fd", endDate) formatter:@"MM/dd HH:mm"];
            _backTime.text = kFormat(@"%@ %@", [backStr substringToIndex:5],[CustomTool changWeekStr:kFormat(@"%fd", endDate)]);
            
        }else{
            if ((long long)(backLate-getLate)%86400>0) {
                NSString *chooseBackTime = [CustomTool changChineseTimeStr:kFormat(@"%lld", (long long)backLate)];
                _chooseBackTime = chooseBackTime;
                
                NSString *backStr = [CustomTool changTimeStr:kFormat(@"%fd", backLate) formatter:@"MM/dd HH:mm"];
                _backTime.text = kFormat(@"%@ %@", [backStr substringToIndex:5],[CustomTool changWeekStr:kFormat(@"%fd", backLate)]);
            }else{
                
            }
        }
        [self getMoneyLoadData];
        
    }else if(_index==1001){
        NSDate *d1=[dateM dateFromString:getStr];
        NSString *startStr = [NSString stringWithFormat:@"%@", _chooseRentTime];
        NSDate *d2=[dateM dateFromString:startStr];
        getLate=[d1 timeIntervalSince1970];
        backLate=[d2 timeIntervalSince1970];
        
        if (getLate-backLate>=86400) {
            NSString *chooseBackTime = [CustomTool changChineseTimeStr:kFormat(@"%lld", (long long)getLate)];
            _chooseBackTime = chooseBackTime;
            
            NSString *backStr = [CustomTool changTimeStr:kFormat(@"%fd", getLate) formatter:@"MM/dd HH:mm"];
            _backTime.text = kFormat(@"%@ %@", [backStr substringToIndex:5],[CustomTool changWeekStr:kFormat(@"%fd", getLate)]);
            [self getMoneyLoadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
