//
//  VFConfirmOrderTableViewCell.m
//  VFly
//
//  Created by Hcar on 2018/4/9.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFConfirmOrderTableViewCell.h"
#import "ZJSwitch.h"

@implementation VFConfirmOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    return self;
    
}

- (void)createView{
   _leftLabel  = [UILabel initWithTitle:@"姓名" withFont:kTitleBigSize textColor:kdetailColor];
    [self addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.font = [UIFont systemFontOfSize:kTitleBigSize];
    [self addSubview:_textField];
    _textField.placeholder = @"请输入";
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLabel.mas_right).offset(10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    _switchCar = [[ZJSwitch alloc] init];
    _switchCar.backgroundColor = [UIColor clearColor];
    _switchCar.tintColor = kTextBlueColor;
    _switchCar.onTintColor = kTextBlueColor;
    [_switchCar setOn:YES];
    [self addSubview:_switchCar];
    [_switchCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(20);
    }];
    _switchCar.hidden = YES;
    
    _rightView = [[UIView alloc]init];
    [self addSubview:_rightView];
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_more_black"]];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_rightView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(6);
    }];
    
    UILabel *label = [UILabel initWithTitle:@"选择已有" withFont:kTitleBigSize textColor:kdetailColor];
    [_rightView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.equalTo(rightImageView.mas_left).offset(-5);
        make.width.mas_equalTo(70);
    }];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = klineColor;
    [_rightView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-15);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(1);
    }];
}

- (void)setIndexRow:(NSString *)indexRow{
    int index = [indexRow intValue];
    
    if (index == 0) {
        _switchCar.onText = @"否";
        _switchCar.offText = @"是";
        _switchCar.tintColor = kTextBlueColor;
        _switchCar.onTintColor = kGrayColor;
        [_switchCar mas_updateConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(45);
        }];
    }else if (index == 1){
        _switchCar.onText = @"送上门";
        _switchCar.offText = @"到店取";
        _switchCar.tintColor = kTextBlueColor;
        _switchCar.onTintColor = kTextBlueColor;
        [_switchCar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(65);
        }];
    }else{
        
    }
    
    if (index == 4) {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (index >2 && index <4) {
        self.rightView.hidden = NO;
        self.switchCar.hidden = YES;
        [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenW-130-30);
        }];
    }else if (index == 2){
        self.rightView.hidden = NO;
        self.switchCar.hidden = YES;
        [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenW-130-120);
        }];
    }else if(index == 5 || index == 4){
        self.rightView.hidden = YES;
        self.switchCar.hidden = YES;
        [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenW-50);
        }];
    }else{
        self.rightView.hidden = YES;
        self.switchCar.hidden = NO;
        _textField.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
