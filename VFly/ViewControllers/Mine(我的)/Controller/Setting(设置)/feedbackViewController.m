//
//  feedbackViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "feedbackViewController.h"
#import "FeedbackSuccessfulViewController.h"

@interface feedbackViewController ()<UITextViewDelegate>
@property (nonatomic , strong)UITextView *textView;
@property (nonatomic , strong)NSString *feed;
@end
#define TextViewDefaultText @"请在此留下您的宝贵意见或建议，限制字数255字以内"
@implementation feedbackViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"suggest";
    _feed = @"";
    self.navTitleLabel.text = @"意见反馈";
    [self createView];
}

- (void)createView{
    UILabel *label = [UILabel initWithTitle:@"感谢给「威风出行」反馈问题，对于在使用「威风出行」过程中给您带来的不好体验我们非常抱歉，并会努力优化。我们非常重视您的意见，请写下您遇到的问题或者提出需求，「威风出行」离不开您的监督和支持，再次感谢您的反馈。" withFont:kTextSize textColor:kdetailColor];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(75+kStatutesBarH);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *alertView = [[UIView alloc]init];
    alertView.backgroundColor = kWhiteColor;
    [self.view addSubview:alertView];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kScreenH);
    }];
    
    UIView *borderView = [[UIView alloc]init];
    borderView.backgroundColor = kViewBgColor;
    [self.view addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertView).offset(15);
        make.left.equalTo(alertView).offset(15);
        make.right.equalTo(alertView).offset(-15);
        make.height.mas_equalTo(90);
    }];

    _textView = [[UITextView alloc]init];
    _textView.backgroundColor = kViewBgColor;
    _textView.textColor = [UIColor lightGrayColor];
    _textView.text = TextViewDefaultText;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:kTitleBigSize];
    [borderView addSubview:_textView];

    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView).offset(15);
        make.left.equalTo(borderView).offset(10);
        make.right.equalTo(borderView).offset(-10);
        make.height.mas_equalTo(60);
    }];
    
    UIButton *button = [UIButton newButtonWithTitle:@"提交"  sel:@selector(applyBtnClick) target:self cornerRadius:YES];
    [alertView addSubview:button];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(borderView.mas_bottom).offset(15);
    }];
    
}

- (void)applyBtnClick{
    if ([_feed isEqualToString:@""]) {
        [CustomTool alertViewShow:@"还未输入内容"];
        return;
    }
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dic = @{@"token":token,@"text":_feed};
    kWeakself;
    [HttpManage feedbackParameter:dic success:^(NSString *info) {
        if ([info isEqualToString:@"ok"]) {
            FeedbackSuccessfulViewController *vc = [[FeedbackSuccessfulViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            [CustomTool alertViewShow:@"未提交成功"];
        }
    } failedBlock:^{
        [ProgressHUD showError:@"请求错误"];
    }];
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

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        textView.text = TextViewDefaultText;
        textView.textColor = [UIColor lightGrayColor];
    }else {
        _feed = textView.text;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        _feed = textView.text;
    }else {
        _feed = textView.text;
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
