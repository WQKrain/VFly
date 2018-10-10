//
//  VFChooseRentDayViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/16.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChooseRentDayViewController.h"
#import "VFCarDetailModel.h"

@interface VFChooseRentDayViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)UILabel *dayslabel;
@property (nonatomic , strong)UITextField *daysTextField;
@property (nonatomic , strong)UILabel *allRentMoneyLabel;
@property (nonatomic , strong)UILabel *breaksMoneyLabel;
@property (nonatomic , strong)UILabel *dayRentLabel;
@property (nonatomic , strong)UIPickerView *pickView;
@end

@implementation VFChooseRentDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    for (int i = 1; i<1000; i++) {
        [_dataArr addObject:kFormat(@"%d", i)];
    }
    [self createView];
    [self calculateMoney:_days];
}

- (void)createView{
    _dayslabel = [UILabel initWithFont:kTitleBigSize textColor:kdetailColor];
//    _dayslabel.text = kFormat(@"%@天", _dataModel.days);
    _dayslabel.layer.masksToBounds = YES;
    _dayslabel.layer.cornerRadius = 28;
    _dayslabel.layer.borderColor = HexColor(0x3779C6).CGColor;
    _dayslabel.layer.borderWidth = 1;
    _dayslabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dayslabel];
    
    [_dayslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(56);
        make.top.equalTo(self.view).offset(kSpaceH(77));
    }];
    
    _daysTextField = [[UITextField alloc]init];
    _daysTextField.text = _days;
    _daysTextField.delegate = self;
    _daysTextField.textAlignment = NSTextAlignmentCenter;
     _daysTextField.keyboardType = UIKeyboardTypeNumberPad;
    _daysTextField.font = [UIFont systemFontOfSize:kTitleBigSize];
    //这里的object传如的是对应的textField对象,方便在事件处理函数中获取该对象进行操作。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_daysTextField];
    [self.view addSubview:_daysTextField];
    [_daysTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(56);
        make.top.equalTo(self.view).offset(kSpaceH(77));
    }];
    
    _dayRentLabel = [UILabel initWithTitle:kFormat(@"日租金 ¥%@", _dataModel.price) withFont:kNewTitle textColor:kMainColor];
    _dayRentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dayRentLabel];
    
    [_dayRentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(kNewTitle);
        make.top.equalTo(_dayslabel.mas_bottom).offset(kSpaceH(30));
    }];
    NSString *allRentMoney = kFormat(@"总租金 ¥%d", [_dataModel.price intValue] *[_days intValue]);
    _allRentMoneyLabel = [UILabel initWithTitle:allRentMoney withFont:kTitleBigSize textColor:kdetailColor];
    _allRentMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_allRentMoneyLabel];
    
    [_allRentMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(kTitleBigSize);
        make.top.equalTo(_dayRentLabel.mas_bottom).offset(kSpaceH(24));
    }];
    
    _pickView = [[UIPickerView alloc]init];
    _pickView.delegate = self;
    _pickView.dataSource  = self;
    [self.view addSubview:_pickView];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(192);
        make.top.mas_equalTo(_allRentMoneyLabel.mas_bottom).offset(kSpaceH(40));
    }];
    [_pickView selectRow:[_days intValue]-1 inComponent:0 animated:NO];
    
    UIButton *cancelButton = [UIButton buttonWithTitle:@"取消"];
    [cancelButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kScreenW-45)/2);
        make.height.mas_equalTo(44);
        make.top.equalTo(_pickView.mas_bottom).offset(kSpaceH(40));
    }];
    
    UIButton *sureButton = [UIButton newButtonWithTitle:@"确定"  sel:@selector(sureButtonClcik) target:self cornerRadius:YES];
    [self.view addSubview:sureButton];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelButton.mas_right).offset(15);
        make.width.mas_equalTo((kScreenW-45)/2);
        make.height.mas_equalTo(44);
        make.top.equalTo(cancelButton.mas_top);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"1";
         [self calculateMoney:textField.text];
    }
}

//这里可以通过发送object消息获取注册时指定的UITextField对象
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)[notification object];
    if ([textField.text isEqualToString:@""]) {
        return;
    }
    if (textField.text.length > 3) {
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:3];
        textField.text = [textField.text substringToIndex:range.location];
    }
    [self calculateMoney:textField.text];
    [_pickView selectRow:[textField.text intValue]-1 inComponent:0 animated:NO];
}

- (void)dealloc{
    //一般是在dealloc中实现
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//计算钱数
- (void)calculateMoney:(NSString *)days{
    long allMoney = [_dataModel.price intValue] *[days intValue];
    float breaksMoney = allMoney;
    
    _allRentMoneyLabel.text = kFormat(@"总租金 ¥%.2f",breaksMoney);
    _breaksMoneyLabel.text = @"已优惠 ¥0";
    _dayRentLabel.text = kFormat(@"日租金 ¥%@",_dataModel.price);
}

- (void)cancelButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureButtonClcik{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(chooseRentDays:)]) {
            [self.delegate chooseRentDays:_daysTextField.text];
        }
    }];
}

#pragma mark -------pickViewDelegate--------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataArr[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 64;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _daysTextField.text = _dataArr[row];
    _days = _dataArr[row];
    [self calculateMoney:_dataArr[row]];
}


- (void)defaultLeftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
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
