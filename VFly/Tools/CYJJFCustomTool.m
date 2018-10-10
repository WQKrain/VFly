//
//  CustomTool.m
//  LuxuryCar
//
//  Created by Hcar on 2017/5/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "CustomTool.h"

@implementation CustomTool

+(BOOL) runningInBackground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateBackground);
    
    return result;
}

+(BOOL) runningInForeground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    
    return result;
}

+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

//校验车牌号
+(BOOL)checkCarID:(NSString *)carID
{
    if (carID.length!=7) {
        return NO;
    }
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carID];
    
    return YES;
}


//金额千分位显示
+ (NSString *)positiveFormat:(NSString *)text{
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }
    if (text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.2f",text.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###.00;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
}

//判断是否银行卡
+ (BOOL) IsBankCard:(NSString *)cardNumber

{
    
    if(cardNumber.length==0)
        
    {
        
        return NO;
        
    }
    
    NSString *digitsOnly = @"";
    
    char c;
    
    for (int i = 0; i < cardNumber.length; i++)
        
    {
        
        c = [cardNumber characterAtIndex:i];
        
        if (isdigit(c))
            
        {
            
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
            
        }
        
    }
    
    int sum = 0;
    
    int digit = 0;
    
    int addend = 0;
    
    BOOL timesTwo = false;
    
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
        
    {
        
        digit = [digitsOnly characterAtIndex:i] - '0';
        
        if (timesTwo)
            
        {
            
            addend = digit * 2;
            
            if (addend > 9) {
                
                addend -= 9;
                
            }
            
        }
        
        else {
            
            addend = digit;
            
        }
        
        sum += addend;
        
        timesTwo = !timesTwo;
        
    }
    
    int modulus = sum % 10;
    
    return modulus == 0;
    
}


//正则判断手机号
+ (BOOL) IsPhoneNumber:(NSString *)number
{
    NSString *phoneRegex = @"^[1][0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:number];
    
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:number];
    
//    NSString *phoneRegex1 = @"1(3[0-9]|5[0-35-9]|7[0-9]|8[0-9])\\d{8}$";
//    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
//
//    NSString *phoneRegex2 = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[0-9])\\d)\\d{7}$";
//    NSPredicate *phoneTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex2];
//
//    NSString *phoneRegex3 = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    NSPredicate *phoneTest3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex3];
//
//    NSString *phoneRegex4 = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    NSPredicate *phoneTest4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex4];
//
//    NSString *phoneRegex5 = @"^^0(10|2[0-5789]|\\d{3})-\\d{7,8}$";
//    NSPredicate *phoneTest5 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex5];
//
//    if ([phoneTest1 evaluateWithObject:number] || [phoneTest2 evaluateWithObject:number] || [phoneTest3 evaluateWithObject:number] || [phoneTest4 evaluateWithObject:number] ||[phoneTest5 evaluateWithObject:number]) {
//        return YES;
//    }else{
//        return NO;
//    }
    
}

//正则判断身份证号
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

//弹出框
+ (void)alertViewShow:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

//转换时间格式 年 月 日 时 分
+ (NSString *)changTimeStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

//转换时间格式 年 月 日 时 分
+ (NSString *)changChineseTimeStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

//转换时间格式 年 月 日
+ (NSString *)changYearStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


//转换时间格式 年／ 月 ／日
+ (NSString *)changMonthStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;

}

+ (NSString *)changChineseStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}


//转换时间为某月某日
+ (NSString *)changDayStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM.dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

//时间转化为星期
+ (NSString *)changWeekStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEE"];
    NSString *  weekString = [dateformatter stringFromDate:detaildate];
    return weekString;
}

//将时间转化为时间戳
+ (NSString *)toDateChangTimeStr:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate *date = [dateFormatter dateFromString:str];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

//转换为小时
+ (NSString *)changHoursStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


//设置不同字体颜色
+ (void)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    label.attributedText = str;
}

//设置状态栏颜色
+(void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


+(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum
{
    NSMutableString *mutableStr;
    if (bankNum.length) {
        mutableStr = [NSMutableString stringWithString:bankNum];
        for (int i = 0 ; i < mutableStr.length; i ++) {
            if (i>2&&i<mutableStr.length - 3) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    return bankNum;
    
}

//将时间戳转化为时间(最终版)
+ (NSString *)changTimeStr:(NSString *)str formatter:(NSString *)formatter{
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}

//将时间转化为时间戳(最终版)
+ (NSString *)toDateChangTimeStr:(NSString *)str formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [dateFormatter dateFromString:str];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

//仿安卓自动 消失弹框
+ (void)showOptionMessage:(NSString *)message {
    // 获取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *showView = [[UIView alloc] init];
    showView.backgroundColor = [UIColor blackColor];
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.layer.cornerRadius = 5.0f;
    showView.layer.masksToBounds = YES;
    [window addSubview:showView];
    
    UILabel *label = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGRect labelRect = [message boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    label.frame = CGRectMake(10, 5, ceil(CGRectGetWidth(labelRect)), CGRectGetHeight(labelRect));
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [showView addSubview:label];
    showView.frame = CGRectMake((kScreenW - CGRectGetWidth(labelRect) - 20)/2, kScreenH-kSafeBottomH-kSpaceH(127), CGRectGetWidth(labelRect)+20, CGRectGetHeight(labelRect)+10);
    [UIView animateWithDuration:3 animations:^{
        showView.alpha = 0;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
    
}

+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

+ (NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    float number = [testNumber floatValue]/10000;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(number)];
    return outNumber;
}

//计算行高
+ (CGFloat)getSpaceLabelHeightwithContentString:(NSString *)content
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行高
    paraStyle.lineSpacing = 8.0f;
    //    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:kTextSize], NSParagraphStyleAttributeName:paraStyle};
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:kTextSize], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.1f};
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenW-30,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


+ (UILabel *) createUILabelWithText:(NSString *)textString textColor:(UIColor *)textColor textFont:(UIFont *)textFont backGroungColor:(UIColor *)backColor
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = textString.length?textString:@"";
    label.textColor = textColor?textColor:[UIColor whiteColor];
    label.backgroundColor = backColor?backColor:[UIColor whiteColor];
    if (textFont) {
        label.font = textFont;
    }
    return label;
}

+ (UIView *) createUIViewWithBackColor:(UIColor *)backColor
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    //    view.backgroundColor = backColor?backColor:[UIColor whiteColor];
    return view;
}

+ (UIImageView *) createUIImageViewWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    if (image) {
        imageView.image = image;
    }
    if (cornerRadius) {
        imageView.layer.cornerRadius = cornerRadius;
        imageView.clipsToBounds = YES;
    }
    return imageView;
}

+ (UIImageView *) createUrlImageViewWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius imageurlString:(NSString *)imageUrlString{
    UIImageView * imageView = [self createUIImageViewWithImage:image cornerRadius:cornerRadius];
    //[imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil];
    return imageView;
}

+ (UILabel *) getLineLabel
{
    UILabel * lineLabel = [CustomTool createUILabelWithText:@"" textColor:[UIColor clearColor] textFont:[UIFont systemFontOfSize:0.0] backGroungColor:HexColor(0xebebeb)];
    return lineLabel;
}

+ (UIButton*)createButtonWithTitle:(NSString*)title backgroundColor:(UIColor*)color
{
    UIButton *button = [[UIButton alloc ]initWithFrame:CGRectZero];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = color;
    
    return button;
}

/*
 typedef enum {
 UITextFieldViewModeNever,  重不出现
 UITextFieldViewModeWhileEditing, 编辑时出现
 UITextFieldViewModeUnlessEditing,  除了编辑外都出现
 UITextFieldViewModeAlways   一直出现
 } UITextFieldViewMode;
 */
+ (UITextField *)createUITextFieldWithPlaceholder:(NSString *)placeholder andText:(NSString *)text andTextColor:(UIColor *)textColor andClearButtonMode:(UITextFieldViewMode)clearButtonMode
{
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = placeholder;
    textField.text = text;
    textField.textColor = textColor;
    textField.clearButtonMode = clearButtonMode;
    textField.borderStyle = UITextBorderStyleNone;
    return textField;
}

+ (UITextView *)createUITextViewWithText:(NSString *)text andTextColor:(UIColor *)textColor
{
    UITextView *textV = [[UITextView alloc]init];
    textV.text = text;
    textV.textColor = textColor;
    ViewBorderRadius(textV, 6, 0.5, kGrayColor);
    textV.backgroundColor = kWhiteColor;
    
    return textV;
}


+ (NSString *)orderState:(NSString *)state{
    NSInteger orderState = [state integerValue];
    switch (orderState) {
        case 101:
            return @"待支付订金";
            break;
        case 201:
            return @"待调配";
            break;
        case 211:
            return @"待取车";
            break;
        case 221:
            return @"用车中";
            break;
        case 301:
            return @"还车确认中";
            break;
        case 311:
            return @"已完成";
            break;
        case 321:
            return @"已关闭";
            break;
        default:
            break;
    }
    return @"";
}



@end
