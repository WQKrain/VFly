//
//  JSFProgressHUD.m
//  LuxuryCar
//
//  Created by joyingnet on 16/10/15.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "JSFProgressHUD.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define AUTOLAYTOU(a) ((a)*(kWidth/320))
#define WARN_WIDTH 60

@interface JSFProgressHUD ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) CABasicAnimation *loadingRotation;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) CABasicAnimation *centerRotation;

@end

@implementation JSFProgressHUD

+ (JSFProgressHUD *)progressHUD:(UIView *)view{
    static JSFProgressHUD * progressHUD;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
//        progressHUD = [[JSFProgressHUD alloc] initWithFrame:view.bounds];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新 神马的
            progressHUD = [[JSFProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        });
    });
    return progressHUD;
}

+ (void)showHUDToView:(UIView *)view {
    [[self progressHUD:view] showHUDToView:view];
}

+ (void)showFailureHUDToView:(UIView *)view failureText:(NSString *)text {
    [[self progressHUD:view] showFailureHUDToView:view failureText:text];
    [ProgressHUD performSelector:@selector(hiddenHUD:) withObject:nil afterDelay:3];
}

- (void)showFailureHUDToView:(UIView *)view failureText:(NSString *)text {
    [view addSubview:[RemindView showFailureView:text toView:view]];
}

+ (void)showSuccessHUDToView:(UIView *)view SuccessText:(NSString *)text {
    [[self progressHUD:view] showSuccessHUDToView:view SuccessText:text];
    [ProgressHUD performSelector:@selector(hiddenHUD:) withObject:nil afterDelay:3];
}

- (void)showSuccessHUDToView:(UIView *)view SuccessText:(NSString *)text {
    [view addSubview:[RemindView showSuccessView:text toView:view]];
}

- (void)showHUDToView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 开启动画
        [self.loadingImageView.layer addAnimation:self.loadingRotation forKey:nil];
        [self.centerImageView.layer addAnimation:self.centerRotation forKey:nil];
        
        self.backView.center = self.center;
        [view addSubview:self];
        [self addSubview:self.backView];
    });
}

+ (void)hiddenHUD:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self progressHUD:view] removeFromSuperview];
        if ([RemindView remindView:view]) {
            [[RemindView remindView:view] removeFromSuperview];
        }
    });
}

#pragma mark - Getters

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5;
        
        [_backView addSubview:self.loadingImageView];
        self.loadingImageView.center = _backView.center;
        [_backView addSubview:self.centerImageView];
        self.centerImageView.center = _backView.center;
    }

    return _backView;
}

- (UIImageView *)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
        _loadingImageView.image = [UIImage imageNamed:@"HUDLoading"];
        _loadingImageView.layer.masksToBounds = YES;
        _loadingImageView.layer.cornerRadius = 20;
    }
    
    return _loadingImageView;
}

- (CABasicAnimation *)loadingRotation
{
    if (!_loadingRotation) {
        _loadingRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _loadingRotation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        _loadingRotation.duration = 1;
        _loadingRotation.speed = 1.5;
        _loadingRotation.cumulative = YES;
        _loadingRotation.repeatCount = MAXFLOAT;
    }
    
    return _loadingRotation;
}

- (UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 25, 25)];
        _centerImageView.image = [UIImage imageNamed:@"HUDLogo"];
    }
    
    return _centerImageView;
}

- (CABasicAnimation *)centerRotation
{
    if (!_centerRotation) {
        _centerRotation = [CABasicAnimation animationWithKeyPath:@"transform"];
        _centerRotation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        //CATransform3DIdentity 是单位矩阵，该矩阵没有缩放、旋转、歪斜、透视。把该矩阵应用到图层上面会把图层几何属性修改为默认值
        //沿着Z轴旋转
        _centerRotation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1, 0)];
        //旋转效果累计（即下一次动画执行是否接着刚才的动画）
        _centerRotation.duration = 1;
        _centerRotation.speed = 1.5;
        _centerRotation.cumulative = YES;
        //旋转2遍
        _centerRotation.repeatCount = MAXFLOAT;
    }
    
    return _centerRotation;
}

@end

@interface RemindView () {
    CAShapeLayer *lineLayer;
}

@end

@implementation RemindView

+ (RemindView *)remindView:(UIView *)view {
    static RemindView * remindView;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        remindView = [[RemindView alloc] initWithFrame:CGRectMake((view.frame.size.width-120)/2, (view.frame.size.height-120)/2, 120, 120)];
        remindView.layer.masksToBounds = YES;
        remindView.layer.cornerRadius = 5;
        remindView.backgroundColor = [UIColor blackColor];
    });
    return remindView;
}

+ (RemindView *)showFailureView:(NSString *)text toView:(UIView *)view{
    [[self remindView:view] drawFailureView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, [self remindView:view].frame.size.height-25, [self remindView:view].frame.size.width, 20)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    [[self remindView:view] addSubview:label];
    return [self remindView:view];
}

+ (RemindView *)showSuccessView:(NSString *)text toView:(UIView *)view{
    [[self remindView:view] drawSuccessView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, [self remindView:view].frame.size.height-25, [self remindView:view].frame.size.width, 20)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    [[self remindView:view] addSubview:label];
    return [self remindView:view];
}

- (void)drawFailureView {
    [self drawFailureView:self];
    [self setPopAnimation];
}

- (void)drawSuccessView {
    [self drawSuccessView:self];
    [self setPopAnimation];
}

- (void)drawFailureView:(UIView *)view{
    lineLayer.path = nil;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 15, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
    [path moveToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+AUTOLAYTOU(20)-2, AUTOLAYTOU(25)+7)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-AUTOLAYTOU(20)+2, WARN_WIDTH-AUTOLAYTOU(15)+AUTOLAYTOU(3)+7)];
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-AUTOLAYTOU(20)+2, AUTOLAYTOU(25)+7)];
    [path addLineToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+AUTOLAYTOU(20)-2, WARN_WIDTH-AUTOLAYTOU(15)+AUTOLAYTOU(3)+7)];
    [self setDrawAnimationWithPath:path StrokeColor:[UIColor redColor]toView:view];
}

- (void)drawSuccessView:(UIView *)view{
    lineLayer.path = nil;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 15, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
    [path moveToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+14, WARN_WIDTH/2+15)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0-5, WARN_WIDTH-5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-16, 32)];
    [self setDrawAnimationWithPath:path StrokeColor:[UIColor greenColor] toView:view];
}

- (void)setDrawAnimationWithPath:(UIBezierPath *)path StrokeColor:(UIColor *)strokeColor toView:(UIView *)view{
    lineLayer = [CAShapeLayer layer];
    lineLayer. frame = CGRectMake(0, 0, 100, 100);
    lineLayer. fillColor = [UIColor clearColor ]. CGColor ;
    lineLayer. path = path. CGPath ;
    lineLayer. strokeColor = strokeColor. CGColor ;
    lineLayer.lineWidth = 2;
    lineLayer.cornerRadius = 5;
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    ani. fromValue = @0 ;
    ani. toValue = @1 ;
    ani. duration = 0.5 ;
    [lineLayer addAnimation :ani forKey : NSStringFromSelector ( @selector (strokeEnd))];
    
    [self.layer addSublayer :lineLayer];
}

- (void)setPopAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:
                                      kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
}

@end

