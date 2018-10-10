//
//  TXTimeChoose.m
//  TYSubwaySystem
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 TXZhongJiaowang. All rights reserved.
//kDateTopRightBtnX, kDateTopBtnY, kDateTopRightBtnWidth, kDateTopBtnHeight

#import "TXTimeChoose.h"

#define kZero 0
#define kFullWidth [UIScreen mainScreen].bounds.size.width
#define kFullHeight [UIScreen mainScreen].bounds.size.height

#define kDatePicY kFullHeight/3*2
#define kDatePicHeight kFullHeight/3

#define kDateTopBtnY kDatePicY - 30
#define kDateTopBtnHeight 30

#define kDateTopRightBtnWidth kDateTopLeftBtnWidth
#define kDateTopRightBtnX kFullWidth - 30 - kDateTopRightBtnWidth

#define kDateTopLeftbtnX 30
#define kDateTopLeftBtnWidth kFullWidth/6


@interface TXTimeChoose()

@property (nonatomic,strong)UIView *groundV;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIView *topView;

@property (nonatomic,assign)UIDatePickerMode type;
@end

@implementation TXTimeChoose
- (instancetype)initWithFrame:(CGRect)frame type:(UIDatePickerMode)type tag:(NSInteger)starTag{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.starTag = starTag;
        [self addSubview:self.groundV];
        [self addSubview:self.dateP];
        [self addSubview:self.topView];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.dateLabel];
    }
    return self;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2-40,self.leftBtn.top , 80, self.leftBtn.height)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UIDatePicker *)dateP{
    if (!_dateP) {
        self.dateP = [[UIDatePicker alloc]initWithFrame:CGRectMake(kZero, kDatePicY, kFullWidth, kDatePicHeight)];
        self.dateP.backgroundColor = [UIColor whiteColor];
     
        self.dateP.datePickerMode = UIDatePickerModeDateAndTime;
        self.dateP.minuteInterval = 30;
        self.dateP.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        if (_starTag==666) {
            NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
            late1  = late1 + 1800;
            NSTimeInterval late2= late1+86400;
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:late2];
            [self.dateP setMinimumDate: confromTimesp];
        }else if(_starTag==671)
        {
            NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
            late1 = late1 + 1800;
            NSTimeInterval late2= late1+3600 * 4;
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:late2];
            [self.dateP setMinimumDate: confromTimesp];
        } else
        {
            NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
            late1  = late1 + 1800;
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:late1];
            [self.dateP setMinimumDate:confromTimesp];
        }
        [self.dateP addTarget:self action:@selector(handleDateP:) forControlEvents:UIControlEventValueChanged];
    }
    return _dateP;
}

- (UIView *)groundV {
    if (!_groundV) {
        self.groundV = [[UIView alloc]initWithFrame:self.bounds];
        self.groundV.backgroundColor = [UIColor blackColor];
        self.groundV.alpha = 0.7;
    }
    return _groundV;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(kDateTopLeftbtnX, kDateTopBtnY, kDateTopLeftBtnWidth+20, kDateTopBtnHeight+10);
        [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(handleDateTopViewLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(kDateTopRightBtnX-20, kDateTopBtnY, kDateTopRightBtnWidth+20, kDateTopBtnHeight+10);
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [self.rightBtn addTarget:self action:@selector(handleDateTopViewRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)topView {
    if (!_topView) {
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(kZero, kDateTopBtnY, kFullWidth, kDateTopBtnHeight)];
        self.topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (void)setNowTime:(NSString *)dateStr{
    
    [self.dateP setDate:[self dateFromString:dateStr] animated:YES];
    self.dateLabel.text = [dateStr substringToIndex:5];
//    self.dateLabel.text = dateStr;
}

- (void)end{
    [self removeFromSuperview];
}

- (void)handleDateP :(NSDate *)date {
   
    [self.delegate changeTime:self.dateP.date];
    NSString *textStr = [NSDateFormatter localizedStringFromDate:self.dateP.date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];
    self.dateLabel.text = [textStr substringToIndex:5];
}

- (void)handleDateTopViewLeft {
    [self end];
}

- (void)handleDateTopViewRight {
    [self.delegate determine:self.dateP.date];
    [self end];
}



// NSDate --> NSString
- (NSString*)stringFromDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (self.type) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
         case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

//NSDate <-- NSString
- (NSDate*)dateFromString:(NSString*)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
//    switch (self.type) {
//        case UIDatePickerModeTime:
//            [dateFormatter setDateFormat:@"HH:mm"];
//            break;
//        case UIDatePickerModeDate:
//            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//            break;
//        case UIDatePickerModeDateAndTime:
//            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
//            break;
//        case UIDatePickerModeCountDownTimer:
//            [dateFormatter setDateFormat:@"HH:mm"];
//            break;
//        default:
//            break;
//    }
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}




@end
