//
//  HomeCellHeaderV.m
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/15.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "HomeCellHeaderView.h"

@interface HomeCellHeaderView ()

@property (nonatomic, strong) UIButton *leftButton;     // 左边按钮
@property (nonatomic, strong) UIButton *rightButton;    // 右边按钮
@property (nonatomic, strong) UIButton *buttomLeftBtn;
@property (nonatomic, strong) UIButton *buttomRightBtn;

@property (nonatomic, strong) UIView *separatorH;       // 水平分割线
@property (nonatomic, strong) UIImageView *lineImageV;  // view之间分割线

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSTimer *startTimer;

@end

@implementation HomeCellHeaderView

- (instancetype)initWithType:(NSUInteger)type UpperStr:(NSString *)upperStr UnderStr:(NSString *)underStr 
{
    if (self = [super init]) {
        self.backgroundColor = kWhiteColor;
        if (type == HomeCellHeaderTypeButton) {
            self.frame = CGRectMake(0, 0, kScreenW, kScreenW/750.0*138+49);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"butto_YiJianZuChe"] forState:UIControlStateNormal];
            button.tag = 1;
            button.frame = CGRectMake(0, 0, kScreenW, kScreenW/750.0*138);
            [button addTarget:self action:@selector(homeButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
//            接送 | 婚庆
            NSArray *bottomArr = @[@"豪车接送",@"威风会员",@"车辆托管"];
            NSArray *bottomImage = @[[UIImage imageNamed:@"icon_HaoCheJieSong"],[UIImage imageNamed:@"icon_HuiYuanShenQing"],[UIImage imageNamed:@"icon_CheLiangTuoGuan"]];
            //循环创建豪车接送、成为会员、威风合伙人四个按钮
            for (int i=0; i<3; i++) {
                anyButton *button = [anyButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(kScreenW/3*i , kScreenW/750.0*138, kScreenW/3, 35);
                [button setTitleColor:kTitleBoldColor forState:UIControlStateNormal];
                [button setImage:bottomImage[i] forState:UIControlStateNormal];
                [button setTitle:bottomArr[i] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                
                [button changeImageFrame:CGRectMake((kScreenW/3-85)/2, 9, 22, 22)];
                [button changeTitleFrame:CGRectMake(button.imageView.right+5, 11, 58, 20)];
                

                
                button.tag = i+2;
                [button addTarget:self action:@selector(homeButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
                if (i<2) {
                    UIView *lineView = [[UIView alloc]init];
                    lineView.frame = CGRectMake(kScreenW/3-1, 12, 1, 20);
                    lineView.backgroundColor = kHomeLineColor;
                    [button addSubview:lineView];
                }
            }
            
            UIView *bottomView = [[UIView alloc]init];
            bottomView.backgroundColor = kHomeLineColor;
            [self addSubview:bottomView];
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
        }
        else {
            self.frame = CGRectMake(0, 0, kScreenW, 69);
            
            [self addSubview:self.upperLabel];
            [self.upperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.height.mas_equalTo(25);
                make.top.mas_equalTo(30);
            }];
            
            self.upperLabel.text = upperStr;
            self.underLabel.text = underStr;
            
            _modrButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_modrButton.titleLabel setFont:[UIFont systemFontOfSize:kTextBigSize]];
            [_modrButton addTarget:self action:@selector(moreButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
            [_modrButton setTitleColor:kNewDetailColor forState:UIControlStateNormal];
            [self addSubview:_modrButton];
            
            [_modrButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.left.mas_equalTo(15);
                make.top.bottom.mas_equalTo(0);
            }];
            
            UIImageView *moreImage = [[UIImageView alloc]init];
            moreImage.image = [UIImage imageNamed:@"icon_more_#7777773x"];
            [self addSubview:moreImage];
            [moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_upperLabel.mas_right).offset(10);
                make.top.mas_equalTo(36);
                make.width.mas_equalTo(13);
                make.height.mas_equalTo(13);
            }];

        }
    }
    
    return self;
}

#pragma mark - Private Methods

- (void)moreButtonClcik:(UIButton *)sender{
    if (self.moreClickBlock) {
        self.moreClickBlock(sender.tag);
    }
}

- (void)homeButtonClcik:(UIButton *)sender{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.tag);
    }

}


- (void)homeCellHeaderViewVolatileLabelAction:(NSTimer *)timer
{
    if (self.timeLag <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        if (self.underLabel.tag == self.upperLabel.tag == HomeCellHeaderViewVolatileLabel) {
            self.underLabel.text = @"敬请期待";
            self.upperLabel.text = @"活动时间为 10:00 ~ 22:00";
        }
    } else
    {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        //
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.timeLag];
        NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
        if (self.underLabel.tag == HomeCellHeaderViewVolatileLabel) {
            self.underLabel.text = [NSString stringWithFormat:@"仅剩:%@",confromTimespStr];
        }
        self.timeLag --;
    }
}

- (void)setIsBegin:(BOOL)isBegin
{
    _isBegin = isBegin;
    
    if (!isBegin) {
        self.underLabel.text = @"敬请期待";
        self.upperLabel.text = @"活动时间为 10:00 ~ 22:00";
    }
}

#pragma mark - Getters / Setter

- (void)setTimeLag:(NSInteger)timeLag
{
    _timeLag = timeLag;
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(homeCellHeaderViewVolatileLabelAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (UILabel *)upperLabel
{
    if (!_upperLabel) {
        _upperLabel = [[UILabel alloc] init];
        _upperLabel.textColor = kTitleBoldColor;
        _upperLabel.textAlignment = NSTextAlignmentLeft;
        _upperLabel.text = @"热门活动";
        _upperLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kTitleSize];
    }
    
    return _upperLabel;
}

- (UIView *)separatorH
{
    if (!_separatorH) {
        _separatorH = [[UIView alloc] init];
        _separatorH.backgroundColor = kMainColor;
    }
    
    return _separatorH;
}

- (UILabel *)underLabel
{
    if (!_underLabel) {
        _underLabel = [[UILabel alloc] init];
        _underLabel.textColor = kMainColor;
        _underLabel.font = [UIFont boldSystemFontOfSize:kTextSize];
        _underLabel.textAlignment = NSTextAlignmentCenter;
        _underLabel.text = @"24: 32 : 10";
    }
    
    return _underLabel;
}

- (UIImageView *)lineImageV
{
    if (!_lineImageV) {
        _lineImageV = [[UIImageView alloc] init];
        _lineImageV.image = kImageOriginal(@"HeaderLine");
    }
    
    return _lineImageV;
}

@end
