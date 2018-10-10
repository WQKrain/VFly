//
//  CustomApplyAlertView.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/10.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "CustomApplyAlertView.h"

///alertView 宽
#define AlertW  kScreenW*0.67
///各个栏目之间的距离
#define XLSpace 10.0

@interface CustomApplyAlertView()

//弹窗
@property (nonatomic,retain) UIView *alertView;
//title
@property (nonatomic,retain) UILabel *titleLbl;
//内容
@property (nonatomic,retain) UILabel *msgLbl;
//确认按钮
@property (nonatomic,retain) UIButton *sureBtn;
//取消按钮
@property (nonatomic,retain) UIButton *cancleBtn;
//横线线
@property (nonatomic,retain) UIView *lineView;
//竖线
@property (nonatomic,retain) UIView *verLineView;

@end

@implementation CustomApplyAlertView

- (instancetype)initWithTitle:(NSString *)title pic:(UIImage *)image  message:(NSString *)message
{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor blackColor];
        self.alertView.layer.cornerRadius = 5.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 215);
        self.alertView.layer.position = self.center;
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(AlertW);
            make.height.mas_equalTo(215);
        }];

        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = image;
        [bgView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.top).offset(25);
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(48);
        }];
        
        UILabel *successLabel = [[UILabel alloc]init];
        successLabel.text = title;
        successLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:successLabel];
        
        [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).offset(10);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(bgView.mas_width);
            make.height.mas_equalTo(kSpaceH(20));
        }];
        
        
        UIButton *button = [UIButton buttonWithTitle:@"确定" sel:@selector(buttonEvent:) target:self];
        [bgView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(kSpaceH(-30));
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.width.mas_equalTo(kSpaceW(223));
            make.height.mas_equalTo(30);
        }];
        
        
        UILabel *alertlabel = [[UILabel alloc]init];
        alertlabel.font = [UIFont systemFontOfSize:kTextSize];
        alertlabel.text = message;
        alertlabel.numberOfLines = 0;
        alertlabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:alertlabel];
        
        [alertlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_top).offset(kSpaceH(-30));
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(bgView.mas_width);
            make.height.mas_equalTo(20);
        }];
        }
    return self;
}

#pragma mark - 弹出 -
- (void)showXLAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 回调 -设置只有2 -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender
{
    if (self.resultIndex) {
        self.resultIndex(sender.tag);
    }
    [self removeFromSuperview];
}

-(UILabel *)GetAdaptiveLable:(CGRect)rect AndText:(NSString *)contentStr andIsTitle:(BOOL)isTitle
{
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:rect];
    contentLbl.numberOfLines = 0;
    contentLbl.text = contentStr;
    contentLbl.textAlignment = NSTextAlignmentCenter;
    if (isTitle) {
        contentLbl.font = [UIFont boldSystemFontOfSize:16.0];
    }else{
        contentLbl.font = [UIFont systemFontOfSize:14.0];
    }
    
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mParaStyle setLineSpacing:3.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0,[contentStr length])];
    [contentLbl setAttributedText:mAttrStr];
    [contentLbl sizeToFit];
    
    return contentLbl;
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end
