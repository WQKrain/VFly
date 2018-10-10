//
//  VFSubmitCarAlertView.m
//  LuxuryCar
//
//  Created by Hcar on 2017/11/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSubmitCarAlertView.h"
@interface VFSubmitCarAlertView ()
@property (nonatomic, strong)UIView *viewBg;
@end

@implementation VFSubmitCarAlertView

- (UIView *)showView
{
    [self creatBackgroundView];
    [self createView];
    return self;
}

- (void)createView{
    
    _viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigMap:)];
    [self.viewBg addGestureRecognizer:recognizer];
    [self addSubview:_viewBg];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = kWhiteColor;
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 2;
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSpaceW(305));
        make.height.mas_equalTo(265);
        make.center.equalTo(self);
    }];
    UILabel *titleLabel = [UILabel initWithTitle:@"告诉我们，您想要什么车" withFont:kTitleBigSize textColor:kdetailColor];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpaceW(40));
        make.right.mas_equalTo(-kSpaceW(40));
        make.height.mas_equalTo(22);
        make.top.mas_equalTo(40);
    }];
    
    NSArray *placeArr = @[@"请输入车辆品牌，如“法拉利”",@"请输入车辆型号"];
    NSArray *buttonArr = @[@"取消",@"确定"];
    for (int i= 0; i<2; i++) {
        UIView *view = [[UIView alloc]init];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = klineColor.CGColor;
        [whiteView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpaceW(40));
            make.right.mas_equalTo(-kSpaceW(40));
            make.height.mas_equalTo(32);
            make.top.equalTo(titleLabel.mas_bottom).offset(40+i*47);
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.placeholder = placeArr[i];
        textField.font = [UIFont systemFontOfSize:kTextBigSize];
        [view addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(10);
        }];
        
        UIButton *newButton = [UIButton newButtonWithTitle:buttonArr[i]  sel:@selector(btnClick:) target:self cornerRadius:NO];
        newButton.backgroundColor = kWhiteColor;
        [whiteView addSubview:newButton];
        [newButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(i*kSpaceW(305)/2.0);
            make.height.mas_equalTo(43);
            make.width.mas_equalTo(kSpaceW(305)/2.0);
        }];
        newButton.tag = i;
        
        if (i== 0) {
            _brandTextField = textField;
            [newButton setTitleColor:kdetailColor forState:UIControlStateNormal];
        }else{
            _modelTextField = textField;
            [newButton setTitleColor:kMainColor forState:UIControlStateNormal];
        }
    }
    
    UIView *topLineView =[[UIView alloc]init];
    topLineView.backgroundColor = klineColor;
    [whiteView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-44);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *buttonLineView =[[UIView alloc]init];
    buttonLineView.backgroundColor = klineColor;
    [whiteView addSubview:buttonLineView];
    [buttonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)bigMap:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

- (void)btnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectbutton:)]) {
        [self.delegate didSelectbutton:sender.tag];
    }
}


-(void)animateIn
{
    self.viewBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBg.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

-(void)animateOut
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.viewBg.alpha = 0.2;
        self.alpha = 0.2;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)creatBackgroundView
{
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.opaque = NO;
    //这里自定义的View 达到的效果和UIAlterView一样是在Window上添加，UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
//    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    [appWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
    
}

-(void)dissMissPresentVC
{
    [self animateOut];
}

@end
