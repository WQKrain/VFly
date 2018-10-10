//
//  ChangeNicknameViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ChangeNicknameViewController.h"

@interface ChangeNicknameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickText;

@end

@implementation ChangeNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    self.view.backgroundColor = kBackgroundColor;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:kTextSize]];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _nickText.text = self.text;
    [_nickText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)saveAction:(UIButton *)sender{
    if ([_nickText.text isEqualToString:@""]) {
        return;
    }
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":token,@"nickname":_nickText.text};
    [HttpManage setNicknameParameter:dic With:^(NSString *info) {
        if ([info isEqualToString:@"ok"]) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
    } failedBlock:^{
        
    }];
}

//限制昵称输入框在十个字符之内
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nickText) {
        if (textField.text.length > 10) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:10];
            textField.text = [textField.text substringToIndex:range.location];
        }
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
