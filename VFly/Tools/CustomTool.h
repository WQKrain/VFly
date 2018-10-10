//
//  CustomTool.h
//  LuxuryCar
//
//  Created by Hcar on 2017/5/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTool : NSObject

+(BOOL) runningInBackground;

+(BOOL) runningInForeground;

//对比版本号
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;

//校验车牌号
+(BOOL)checkCarID:(NSString *)carID;

//金额千分位显示
+ (NSString *)positiveFormat:(NSString *)text;

//判断是否银行卡
+ (BOOL) IsBankCard:(NSString *)cardNumber;

//正则判断手机号
+ (BOOL) IsPhoneNumber:(NSString *)number;

//正则判断身份证号
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber;

//计算最后一条消息时间
+ (NSString *)format:(NSString *)string;

////弹出框
+ (void)alertViewShow:(NSString *)message;
//转换时间格式 年 月 日
+ (NSString *)changYearStr:(NSString *)str;
//转换时间格式 年 月 日 时 分
+ (NSString *)changTimeStr:(NSString *)str;

//转换时间格式 年 月 日 时 分
+ (NSString *)changChineseTimeStr:(NSString *)str;

//转换时间格式 为汉字
+ (NSString *)changChineseStr:(NSString *)str;
//转换时间格式 年／ 月 ／日
+ (NSString *)changMonthStr:(NSString *)str;

//将时间转化为时间戳
+ (NSString *)toDateChangTimeStr:(NSString *)str;

//转换时间为某月某日
+ (NSString *)changDayStr:(NSString *)str;

//时间转化为星期
+ (NSString *)changWeekStr:(NSString *)str;

//转换为小时
+ (NSString *)changHoursStr:(NSString *)str;
//设置不同字体颜色
+ (void)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;

+(void)setStatusBarBackgroundColor:(UIColor *)color;

//银行卡四位展示
+(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum;

//将时间戳转化为时间(最终版)
+ (NSString *)changTimeStr:(NSString *)str formatter:(NSString *)formatter;

//将时间转化为时间戳(最终版)
+ (NSString *)toDateChangTimeStr:(NSString *)str formatter:(NSString *)formatter;

//仿安卓自动 消失弹框
+ (void)showOptionMessage:(NSString *)message;

+ (BOOL)isAllNum:(NSString *)string;

//iOS 中去掉浮点数后面多余的0
+ (NSString*)removeFloatAllZero:(NSString*)string;

//计算行高
+ (CGFloat)getSpaceLabelHeightwithContentString:(NSString *)content;

// 创建label
+ (UILabel *)createUILabelWithText:(NSString *)textString textColor:(UIColor *)textColor textFont:(UIFont *)textFont backGroungColor:(UIColor *)backColor;

// 创建View
+ (UIView *)createUIViewWithBackColor:(UIColor *)backColor;

// 创建imageView（本地）
+ (UIImageView *)createUIImageViewWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius;

// 创建imageView（url）
+ (UIImageView *)createUrlImageViewWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius imageurlString:(NSString *)imageUrlString;

// 创建cell的线
+ (UILabel *)getLineLabel;

// 创建btn
+ (UIButton*)createButtonWithTitle:(NSString*)title backgroundColor:(UIColor*)color;

// 创建textField
+ (UITextField *)createUITextFieldWithPlaceholder:(NSString *)placeholder andText:(NSString *)text andTextColor:(UIColor *)textColor andClearButtonMode:(UITextFieldViewMode)clearButtonMode;

// 创建textView
+ (UITextView *)createUITextViewWithText:(NSString *)text andTextColor:(UIColor *)textColor;

//订单根据状态值给出提示
+ (NSString *)orderState:(NSString *)state;

@end
