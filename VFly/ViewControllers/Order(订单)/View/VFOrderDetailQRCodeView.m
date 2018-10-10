//
//  VFOrderDetailQRCodeView.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/15.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFOrderDetailQRCodeView.h"
#import "VFOrderQRCodeModel.h"

@interface VFOrderDetailQRCodeView (){
    NSTimer *_timer;
    VFOrderQRCodeModel *_model;
    NSString *_orderID;
    UIImageView *_qrCodeImage;
    BOOL _isNew;
}

@end


@implementation VFOrderDetailQRCodeView

- (instancetype)initWithOrderID:(NSString *)orderID isNew:(BOOL)isNew{
    if (self == [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(kScreenW*3.0/5);
            make.height.mas_equalTo(kScreenW*3.0/5+50);
        }];
    
        UILabel *titleLabel = [UILabel initWithTitle:@"取车码" withFont:kTitleBigSize textColor:kdetailColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(bgView);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(24);
        }];
        
        _qrCodeImage = [[UIImageView alloc]init];
        [bgView addSubview:_qrCodeImage];
        [_qrCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            make.top.equalTo(titleLabel.mas_bottom).offset(kSpaceW(24));
            make.width.height.mas_equalTo(kScreenW*3.0/5*4.0/5);
        }];
        
        _orderID = orderID;
        _isNew = isNew;
        if (_isNew) {
            [VFHttpRequest getOrderQrcodeParameter:orderID successBlock:^(NSDictionary *data) {
                VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                if ([model.code intValue] == 1) {
                    VFOrderQRCodeModel *obj = [[VFOrderQRCodeModel alloc]initWithDic:model.data];
                    _model = obj;
                    [_qrCodeImage sd_setImageWithURL:[NSURL URLWithString:obj.qrcode_src]];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
                }
            } withFailureBlock:^(NSError *error) {
                
            }];
        }else{
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
            NSDictionary *dic = @{@"token":token,@"order_id":orderID};
            [HttpManage getQrcodeUrlParameter:dic successBlock:^(NSDictionary *data) {
                HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                if ([model.info isEqualToString:@"ok"]) {
                    VFOrderQRCodeModel *obj = [[VFOrderQRCodeModel alloc]initWithDic:model.data];
                    _model = obj;
                    [_qrCodeImage sd_setImageWithURL:[NSURL URLWithString:obj.qrcode_src]];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
                }
            } withFailureBlock:^(NSError *error) {
                
            }];
        }
        
    }
    return self;
}

- (void)action:(NSTimer *)timer{
    NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
    NSInteger timeLog = [_model.overdue_time integerValue] - currentTime;
    if (timeLog==0) {
        
        if (_isNew) {
            [VFHttpRequest getOrderQrcodeParameter:_orderID successBlock:^(NSDictionary *data) {
                VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                if ([model.code intValue] == 1) {
                    VFOrderQRCodeModel *obj = [[VFOrderQRCodeModel alloc]initWithDic:model.data];
                    _model = obj;
                    [_qrCodeImage sd_setImageWithURL:[NSURL URLWithString:obj.qrcode_src]];
                }
            } withFailureBlock:^(NSError *error) {
                
            }];
        }else{
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
            NSDictionary *dic = @{@"token":token,@"order_id":_orderID};
            [HttpManage getQrcodeUrlParameter:dic successBlock:^(NSDictionary *data) {
                HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                if ([model.info isEqualToString:@"ok"]) {
                    VFOrderQRCodeModel *obj = [[VFOrderQRCodeModel alloc]initWithDic:model.data];
                    _model = obj;
                    [_qrCodeImage sd_setImageWithURL:[NSURL URLWithString:obj.qrcode_src]];
                }
            } withFailureBlock:^(NSError *error) {
                
            }];
        }
    
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_timer invalidate];
    [self removeFromSuperview];
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
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}


@end
