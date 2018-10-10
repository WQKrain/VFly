//
//  AddAddressViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "AddAddressViewController.h"
#import "LZCityPickerController.h"
#import "AddressModel.h"

#define TextViewDefaultText @"详细地址"
@interface AddAddressViewController ()<UITextViewDelegate>
@property (nonatomic , strong)UILabel *cityLabel;
@property (nonatomic , strong)UITextView *textView;
@property (nonatomic , strong)NSString *feed;
@property (nonatomic , strong)UITextField *nameText;
@property (nonatomic , strong)UITextField *numberText;
@property (nonatomic , strong)NSString *isDefault;

@property (nonatomic , strong)NSString *cityCode;
@property (nonatomic , strong)NSDictionary *chooseCity;

@property (nonatomic , strong)NSString *header;
@end

@implementation AddAddressViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isDefault = @"1";
    _feed = @"";
    _cityCode = @"0";
    self.UMPageStatistical = @"addressEditor";
    self.view.backgroundColor = kWhiteColor;
    [self createView];
    if (_isEdit) {
        _header = @"编辑地址";
        NSArray *addressArr =  [self.model.address componentsSeparatedByString:@"-"];
        self.nameText.text = self.model.name;
        self.numberText.text = self.model.mobile;
        self.cityLabel.text = [NSString stringWithFormat:@"%@-%@-%@",addressArr[0],addressArr[1],addressArr[2]];
        self.textView.text = addressArr[3];
        _feed = self.textView.text;
    
        _chooseCity = @{@"provinceName":addressArr[0],@"provinceID":@"",@"cityName":addressArr[1],@"cityID":@"",@"countyName":addressArr[2],@"countyID":@""};
        
    }else{
        _header = @"添加地址";
        self.editing = NO;
        _chooseCity = @{@"provinceName":@"",@"provinceID":@"",@"cityName":@"",@"cityID":@"",@"countyName":@"",@"countyID":@""};
    }
    self.titleStr = _header;
//    self.navigationItem.titleView = [UILabel initWithNavTitle:_header];
}


- (void)navRightViewClickActions{
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *address = [NSString stringWithFormat:@"%@-%@",_cityLabel.text,_feed];
    if (_isEdit){
        if ([_feed isEqualToString:@""]) {
            HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请将内容补充完整"];
            HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
            [alertCtrl addAction:Action];
            [self presentViewController:alertCtrl animated:NO completion:nil];
        }else{
            NSDictionary *dic = @{@"token":token,@"address":address,@"name":@"",@"mobile":@"",@"isDefault":_isDefault,@"id":self.model.addressID,@"cityId":self.model.cityId};
            [HttpManage editAddressParameter:dic success:^(NSDictionary *data) {
                HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                if ([model.info isEqualToString:@"ok"]) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    [ProgressHUD showError:model.info];
                }
                [JSFProgressHUD hiddenHUD:self.view];
            } failedBlock:^(NSError *error) {
                [JSFProgressHUD hiddenHUD:self.view];
                [ProgressHUD showError:@"请求错误"];
                
            }];
        }
    }else{
        if ([_feed isEqualToString:@""] || [_cityCode intValue]== 0) {
            HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请将内容补充完整"];
            HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
            [alertCtrl addAction:Action];
            [self presentViewController:alertCtrl animated:NO completion:nil];
        }else{
            NSDictionary *dic = @{@"token":token,@"address":address,@"name":@"",@"mobile":@"",@"isDefault":_isDefault,@"cityId":_cityCode};
            [HttpManage addAddressParameter:dic success:^(NSDictionary *data) {
                HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                if ([model.code isEqualToString:@"0"]) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    [ProgressHUD showError:model.info];
                }
                [JSFProgressHUD hiddenHUD:self.view];
            } failedBlock:^(NSError *error) {
                [JSFProgressHUD hiddenHUD:self.view];
                [ProgressHUD showError:@"请求错误"];
            }];
        }
    }
}


- (void)createView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeaderH, kScreenW, 41)];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = kWhiteColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
    label.text = @"所在地区";
    label.font = [UIFont systemFontOfSize:kTitleBigSize];
    label.textColor = ktitleColor;
    [bgView addSubview:label];
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-25, 13, 14, 14)];
    imageView.image = [UIImage imageNamed:@"icon_more_select"];
    [bgView addSubview:imageView];
    
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right+20, 0, kScreenW-100, 40)];
    _cityLabel.textColor = kdetailColor;
    _cityLabel.textAlignment = NSTextAlignmentLeft;
    _cityLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    _cityLabel.text = @"请选择";
    [bgView addSubview:_cityLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenW, 40);
    [button addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 41+kHeaderH, kScreenW, 80)];
    detailView.backgroundColor = kWhiteColor;
    [self.view addSubview:detailView];

    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 10, kScreenW-20, 70)];
    _textView.text = TextViewDefaultText;
    _textView.textColor = [UIColor lightGrayColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:kTitleBigSize];
    [detailView addSubview:_textView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, detailView.bottom, kScreenW-30, 1)];
    lineView.backgroundColor = kNewLineColor;
    [self.view addSubview:lineView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, detailView.bottom+1, kScreenW, 70)];
    bottomView.backgroundColor = kWhiteColor;
    [self.view addSubview:bottomView];
    
    UILabel *leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 70)];
    leftlabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    leftlabel.text = @"设为默认";
    leftlabel.textColor = ktitleColor;
    [bottomView addSubview:leftlabel];
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(kScreenW-70, 0, 70, 70);
    [chooseButton setImage:[UIImage imageNamed:@"icon_checkbox_off"] forState:UIControlStateNormal];
    [chooseButton setImage:[UIImage imageNamed:@"icon_checkbox_on"] forState:UIControlStateSelected];
    chooseButton.imageEdgeInsets = UIEdgeInsetsMake(27, 0, 27, 0);
//    chooseButton.imageEdgeInsets = UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    chooseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    chooseButton.selected = YES;
    [chooseButton addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:chooseButton];
    
    UIButton *determineButton = [UIButton newButtonWithTitle:@"确定"  sel:@selector(navRightViewClickActions) target:self cornerRadius:YES];
    determineButton.frame = CGRectMake((kScreenW-165)/2, lineView.bottom+106, 165, 44);
    [self.view addSubview:determineButton];
}

- (void)chooseBtnClick:(UIButton *)sender{
    sender.selected  = !sender.selected;
    if (sender.selected) {
        _isDefault = @"1";
    }else{
        _isDefault = @"0";
    }
}

#pragma mark --------TextViewDelegate------
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:TextViewDefaultText]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:TextViewDefaultText]) {
        _feed = @"";
    }else if ([textView.text isEqualToString:@""]){
    }else{
       _feed = textView.text;
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        textView.text = TextViewDefaultText;
        textView.textColor = [UIColor lightGrayColor];
    }else {
    }
    if ([textView.text isEqualToString:TextViewDefaultText]) {
        _feed = @"";
    }else{
        _feed = textView.text;
    }
    return YES;
}

- (void)chooseCity{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [LZCityPickerController showPickerInViewController:self selectDic:_chooseCity selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area, NSString *code) {
        _cityCode = code;
       self.cityLabel.text = address;
       _chooseCity = @{@"provinceName":province,@"provinceID":@"",@"cityName":city,@"cityID":@"",@"countyName":area,@"countyID":code};
    }];
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
