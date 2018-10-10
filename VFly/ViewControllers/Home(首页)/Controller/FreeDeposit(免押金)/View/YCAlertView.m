//
//  YCAlertView.m
//  YCAlertView
//
//  Created by zyc on 2017/11/1.
//  Copyright © 2017年 YC. All rights reserved.
//

#import "YCAlertView.h"
#define TagValue  1000
#define AlertTime 0.3 //弹出动画时间
#define DropTime 0.5 //落下动画时间




@interface YCAlertView()

@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,strong)UIButton *sureBtn;



@end

@implementation YCAlertView


-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title alertMessage:(NSString *)msg confrimBolck:(void (^)())confrimBlock cancelBlock:(void (^)())cancelBlock{
    if (self = [super initWithFrame:frame]) {
        [self customUIwith:frame title:title message:msg];
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
    }
    return self;
}


-(void)customUIwith:(CGRect)frame title:(NSString *)title message:(NSString *)msg{

    self.backgroundColor = kWhiteColor;
    
    _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 190, 22)];
    _titleLB.textColor = kdetailColor;
    _titleLB.font = [UIFont systemFontOfSize:kTitleBigSize];
    [self addSubview:_titleLB];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [_cancleBtn setBackgroundColor:kMainColor];
    [_cancleBtn setTitle:@"保持旧资料申请" forState:UIControlStateNormal];
    _cancleBtn.frame = CGRectMake(15, 62, self.width-30, 40);
    [self addSubview:_cancleBtn];
    [_cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setBackgroundColor:kMainColor];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [_sureBtn setTitle:@"增加资料提升额度" forState:UIControlStateNormal];
    _sureBtn.frame = CGRectMake(15, 117, self.width-30, 40);
    [self addSubview:_sureBtn];
    [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _titleLB.text = title;
    
}

-(void)cancleBtnClick{
    [self hide];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
-(void)sureBtnClick{
    [self hide];
    if (_sureBlock) {
        _sureBlock();
    }
}


-(void)show{
    if (self.superview) {
        [self removeFromSuperview];
    }
    UIView *oldView = [[UIApplication sharedApplication].keyWindow viewWithTag:TagValue];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    UIView *iview = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    iview.tag = TagValue;
    iview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [iview addGestureRecognizer:tap];
    iview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:iview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.alpha = 0;
    self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    [UIView animateWithDuration:AlertTime animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}


//弹出隐藏
-(void)hide{
    if (self.superview) {
        [UIView animateWithDuration:AlertTime animations:^{
            self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            UIView *bgview = [[UIApplication sharedApplication].keyWindow viewWithTag:TagValue];
            if (bgview) {
                [bgview removeFromSuperview];
            }
            [self removeFromSuperview];
        }];
    }
}

@end
