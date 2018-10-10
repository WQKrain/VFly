//
//  VFChangeMyInfoController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFChangeMyInfoController.h"
#import "GlobalConfigModel.h"
#import "zySheetPickerView.h"
#import "LZCityPickerController.h"
@interface VFChangeMyInfoController ()
@property (nonatomic , strong)NSDictionary *par;
@property (nonatomic , strong)UITextField *textField;
@property (nonatomic , strong)UILabel *textlabel;
@property (nonatomic , strong)NSArray *chooseTitleArr;
@property (nonatomic , strong)NSDictionary *chooseCity;
@end

@implementation VFChangeMyInfoController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _chooseTitleArr = @[@"",@"",@"",@"学历",@"职业",@""];
    if (_type == 2)
    {
        
        _chooseCity = @{@"provinceName":@"",
                        @"provinceID":@"",
                        @"cityName":@"",
                        @"cityID":@"",
                        @"countyName":@"",
                        @"countyID":@""};
        
//        if ([self.message isEqualToString:@""])
//        {
//            _chooseCity = @{@"provinceName":@"",
//                            @"provinceID":@"",
//                            @"cityName":@"",
//                            @"cityID":@"",
//                            @"countyName":@"",
//                            @"countyID":@""};
//        }
//        else
//        {
//            NSArray *cityArr= [self.message componentsSeparatedByString:@"-"];
//            _chooseCity = @{@"provinceName":cityArr[0],
//                            @"provinceID":@"",
//                            @"cityName":cityArr[1],
//                            @"cityID":@"",
//                            @"countyName":cityArr[2],
//                            @"countyID":@""};
//        }
    }
    
    [self createView];
    [self setNav];
}

- (void)setNav {
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatutesBarH + 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc]init];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.frame = CGRectMake(0, 0, 64, kStatutesBarH + 44);
    [navView addSubview:backButton];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_icon_back_black"]];
    [backButton addSubview:backImageView];
    backImageView.sd_layout
    .leftSpaceToView(backButton, 20)
    .bottomSpaceToView(backButton, 0)
    .heightIs(24)
    .widthIs(24);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titleText;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.backgroundColor = [UIColor whiteColor];
    [rightButton setTitle:@"保存" forState:(UIControlStateNormal)];
    [rightButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [rightButton addTarget:self action:@selector(sure:) forControlEvents:(UIControlEventTouchUpInside)];
    rightButton.frame = CGRectMake(kScreenW - 84, kStatutesBarH + 20, 64, 24);
    [navView addSubview:rightButton];
    
    
}

- (void)back:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure:(UIButton *)button {
 
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSArray *keyArr = @[@"",@"",@"area",@"record",@"job",@"hobby",@"nickname"];
    
    if ([_textField.text isEqualToString:@""])
    {
        [CustomTool alertViewShow:@"还没有输入哦"];
    }
    _par = @{keyArr[self.type]:_textField.text,@"token":token};
    [HttpManage setUserInfoParameter:_par success:^(NSString *info) {
        if ([info isEqualToString:@"ok"])
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [CustomTool alertViewShow:info];
        }
    } failedBlock:^{
        
    }];
    
}

- (void)createView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, kNavBarH+85, kScreenW-30, 44)];
    bgView.backgroundColor = kViewBgColor;
    [self.view addSubview:bgView];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, kScreenW-70, 44)];
    if (self.type == 2 || self.type == 3)
    {
        self.textField.placeholder = @"请选择";
    }
    else
    {
        self.textField.placeholder = @"请输入";
        [self.textField becomeFirstResponder];
    }
    self.textField.text = self.message;
    self.textField.textColor = kdetailColor;
    self.textField.font = [UIFont systemFontOfSize:kTitleBigSize];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:self.textField];
    
    if (self.type == 2 || self.type == 3)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 30)];
        [bgView addSubview:label];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *textLTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infomationTextFieldTap:)];
        [label addGestureRecognizer:textLTap];
    }
}

//限制昵称输入框在十个字符之内
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.textField) {
        if (textField.text.length > 15) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:15];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
}

- (void)infomationTextFieldTap:(UIGestureRecognizer *)tap {
    NSDictionary *dataDic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    GlobalConfigModel  *model = [[GlobalConfigModel alloc]initWithDic:dataDic];
    NSArray *dataArr = [[NSArray alloc]init];
    if (self.type == 3)
    {
        dataArr = model.record;
    }
    else if (self.type == 4){
        return;
    }
    else if (self.type == 2)
    {
        [LZCityPickerController showPickerInViewController:self selectDic:_chooseCity selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area, NSString *code) {
            self.textField.text = address;
            _chooseCity = @{@"provinceName":province,
                            @"provinceID":@"",
                            @"cityName":city,
                            @"cityID":@"",
                            @"countyName":area,
                            @"countyID":code};
        }];
        return;
    }
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:dataArr andHeadTitle:_chooseTitleArr[self.type] Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        _textField.text = choiceString;
        [pickerView dismissPicker];
    }];
    [pickerView show];
}





@end
