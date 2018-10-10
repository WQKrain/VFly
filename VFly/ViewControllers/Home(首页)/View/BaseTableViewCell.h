//
//  BaseTableViewCell.h
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *lineImageV;// 分割线

// 快速创建提示或输入栏, 注意要实现UITextField相关代理方法
- (void)createSubviewsWithLabelString:(NSString *)labelStr LabelWidth:(CGFloat)labelWidth TextFieldHolder:(NSString *)holderStr;

@end
