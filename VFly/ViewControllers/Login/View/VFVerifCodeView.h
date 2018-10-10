//
//  VFVerifCodeView.h
//  VFly
//
//  Created by 毕博洋 on 2018/9/12.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VFVerifCodeView : UIView

/**背景图片*/
@property (nonatomic,copy)NSString *backgroudImageName;
/**验证码/密码的位数*/
@property (nonatomic,assign)NSInteger numberOfVertificationCode;
/**控制验证码/密码是否密文显示*/
@property (nonatomic,assign)bool secureTextEntry;
/**验证码/密码内容，可以通过该属性拿到验证码/密码输入框中验证码/密码的内容*/
@property (nonatomic,copy)NSString *vertificationCode;

@property (copy,nonatomic) void(^verifCodeBlock)(NSString *string);

-(void)becomeFirstResponder;

@end