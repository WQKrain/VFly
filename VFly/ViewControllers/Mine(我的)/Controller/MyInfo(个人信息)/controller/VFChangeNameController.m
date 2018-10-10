//
//  VFChangeNameController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFChangeNameController.h"

@interface VFChangeNameController ()

@property (nonatomic, strong) UITextField *textField;


@end

@implementation VFChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self setNav];
    [self setupView];
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
    .bottomSpaceToView(backButton, 10)
    .heightIs(24)
    .widthIs(24);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"昵称";
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
    if ([self.textField.text isEqualToString:@""])
    {
        [CustomTool alertViewShow:@"还没有输入哦"];
        return;
    }
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":token,
                          @"nickname":_textField.text};
    [HttpManage setNicknameParameter:dic With:^(NSString *info) {
        if ([info isEqualToString:@"ok"])
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [CustomTool alertViewShow:info];
        }
    } failedBlock:^{
        [CustomTool alertViewShow:@"修改失败"];

    }];
    
}

- (void)setupView {
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(20, kStatutesBarH + 44, kScreenW-70, 44)];
    if (self.nickName)
    {
        self.textField.text = [NSString stringWithFormat:@"%@",self.nickName];
    }
    self.textField.textColor = kdetailColor;
    self.textField.font = [UIFont systemFontOfSize:kTitleBigSize];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textField];
    
    
}

//限制昵称输入框在15个字符之内
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






@end
