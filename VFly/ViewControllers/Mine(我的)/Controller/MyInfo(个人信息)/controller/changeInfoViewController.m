//
//  changeInfoViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "changeInfoViewController.h"
#import "GlobalConfigModel.h"
#import "zySheetPickerView.h"
#import "LZCityPickerController.h"

@interface changeInfoViewController ()
@property (nonatomic , strong)NSDictionary *par;
@property (nonatomic , strong)UITextField *textField;
@property (nonatomic , strong)UILabel *textlabel;
@property (nonatomic , strong)NSArray *chooseTitleArr;
@property (nonatomic , strong)NSDictionary *chooseCity;
@end

@implementation changeInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navSandow = YES;
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    self.centerBlodTitle = kFormat(@"修改%@", self.titleText);
    _chooseTitleArr = @[@"",@"",@"",@"学历",@"职业",@""];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(navRightViewClickActions)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.view.backgroundColor = kWhiteColor;
    self.backImage.image = [UIImage imageNamed:@"icon_close"];
    
    if (_type == 2) {
        if ([self.message isEqualToString:@""]) {
            _chooseCity = @{@"provinceName":@"",@"provinceID":@"",@"cityName":@"",@"cityID":@"",@"countyName":@"",@"countyID":@""};
        }else{
            NSArray *cityArr= [self.message componentsSeparatedByString:@"-"];
            _chooseCity = @{@"provinceName":cityArr[0],@"provinceID":@"",@"cityName":cityArr[1],@"cityID":@"",@"countyName":cityArr[2],@"countyID":@""};
        }
    }
    
    [self createView];
}

- (void)defaultRightBtnClick{
    [self navRightViewClickActions];
}


- (void)createView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, kNavBarH+85, kScreenW-30, 44)];
    bgView.backgroundColor = kViewBgColor;
    [self.view addSubview:bgView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, kScreenW-70, 44)];
    if (_type == 2 || _type == 3)
    {
        _textField.placeholder = @"请选择";
    }
    else
    {
        _textField.placeholder = @"请输入";
        [_textField becomeFirstResponder];
    }
    _textField.text = self.message;
    _textField.textColor = kdetailColor;
    _textField.font = [UIFont systemFontOfSize:kTitleBigSize];
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:_textField];
    
    if (self.type == 2 || self.type == 3) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 30)];
        [bgView addSubview:label];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *textLTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infomationTextFieldTap:)];
        [label addGestureRecognizer:textLTap];
    }
}

//限制昵称输入框在十个字符之内
- (void)textFieldDidChange:(UITextField *)textField
{
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



- (void)infomationTextFieldTap:(UIGestureRecognizer *)tap
{
    NSDictionary *dataDic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    GlobalConfigModel  *model = [[GlobalConfigModel alloc]initWithDic:dataDic];
    NSArray *dataArr = [[NSArray alloc]init];
    if (self.type == 3)
    {
        dataArr = model.record;
    }else if (self.type == 4)
    {
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

- (void)navRightViewClickActions{
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSArray *keyArr = @[@"",@"",@"area",@"record",@"job",@"hobby",@"nickname"];
    
    if ([_textField.text isEqualToString:@""]) {
        [CustomTool alertViewShow:@"还没有输入哦"];
    }
    
     _par = @{keyArr[self.type]:_textField.text,@"token":token};
    
    if (self.type == 6) {
        NSDictionary *dic = @{@"token":token,@"nickname":_textField.text};
        [HttpManage setNicknameParameter:dic With:^(NSString *info) {
            if ([info isEqualToString:@"ok"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [CustomTool alertViewShow:info];
            }
        } failedBlock:^{
            
        }];
    }else{
        [HttpManage setUserInfoParameter:_par success:^(NSString *info) {
            if ([info isEqualToString:@"ok"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                [CustomTool alertViewShow:info];
            }
        } failedBlock:^{
            
        }];
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
