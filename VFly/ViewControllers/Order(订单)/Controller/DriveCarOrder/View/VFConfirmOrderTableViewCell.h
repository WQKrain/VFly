//
//  VFConfirmOrderTableViewCell.h
//  VFly
//
//  Created by Hcar on 2018/4/9.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJSwitch;
@interface VFConfirmOrderTableViewCell : UITableViewCell
@property (nonatomic , strong) ZJSwitch *switchCar;
@property (nonatomic , strong) UIView *rightView;
@property (nonatomic , strong) UILabel *leftLabel;
@property (nonatomic , strong) NSString *indexRow;
@property (nonatomic , strong) UITextField *textField;
@property (nonatomic , strong) UIView *lineView;

@end
