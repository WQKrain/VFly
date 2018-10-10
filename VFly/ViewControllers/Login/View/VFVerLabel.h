//
//  VFVerLabel.h
//  VFly
//
//  Created by 毕博洋 on 2018/9/12.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VFVerLabel : UILabel


/**验证码/密码的位数*/
@property (nonatomic,assign)NSInteger numberOfVertificationCode;
/**控制验证码/密码是否密文显示*/
@property (nonatomic,assign)bool secureTextEntry;

@end
