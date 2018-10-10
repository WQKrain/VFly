//
//  VFFeedBackController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFFeedBackController.h"
#import "VFFeedBackSuccessController.h"

@interface VFFeedBackController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, copy) NSString *tipString;

@end

@implementation VFFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    self.tipString = @"";
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
    .bottomSpaceToView(backButton, 0)
    .heightIs(24)
    .widthIs(24);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"意见反馈";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView {
    
    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = @"在此留下您的宝贵意见或建议...";
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:kTitleBigSize];
    [self.view addSubview:self.textView];
    self.textView.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(self.view, kStatutesBarH + 84)
    .heightIs(kScreenWidth / 750 * 400);
    
    UIButton *submitButton = [[UIButton alloc]init];
    [submitButton setBackgroundColor:[UIColor redColor]];
    [submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitButton addTarget:self action:@selector(submit:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:submitButton];
    submitButton.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(self.textView, 20)
    .heightIs(44);
    
}

- (void)submit:(UIButton *)button {
    if ([self.tipString isEqualToString:@""])
    {
        [CustomTool alertViewShow:@"还未输入内容"];
        return;
    }
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":token,
                          @"text":self.tipString};
    kWeakself;
    [HttpManage feedbackParameter:dic success:^(NSString *info) {
        if ([info isEqualToString:@"ok"])
        {
            VFFeedBackSuccessController *vc = [[VFFeedBackSuccessController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [CustomTool alertViewShow:@"未提交成功"];
        }
    } failedBlock:^{
        [ProgressHUD showError:@"请求错误"];
    }];
}

#pragma mark --------TextViewDelegate------
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"在此留下您的宝贵意见或建议..."])
    {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""])
    {
        textView.text = @"在此留下您的宝贵意见或建议...";
        textView.textColor = [UIColor lightGrayColor];
    }
    else
    {
        self.tipString = textView.text;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""])
    {
        self.tipString = textView.text;
    }
    else
    {
        self.tipString = textView.text;
    }
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
