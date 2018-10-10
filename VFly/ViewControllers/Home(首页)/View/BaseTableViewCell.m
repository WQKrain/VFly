//
//  BaseTableViewCell.m
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;  // 左边标题

@end


@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lineImageV];
        [self.lineImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(SpaceW(20));
            make.right.equalTo(self.contentView.mas_right).offset(SpaceW(-20));
            make.height.mas_equalTo(SpaceH(1));
        }];
        self.lineImageV.hidden = YES;
    }
    return self;
}

- (void)createSubviewsWithLabelString:(NSString *)labelStr LabelWidth:(CGFloat)labelWidth TextFieldHolder:(NSString *)holderStr
{
    self.titleLabel.text = labelStr;
    [self addSubview:self.titleLabel];
    // 宽度可传入或根据文字自适应
    if (labelWidth == 0) {
        [self.titleLabel sizeToFit];
        labelWidth = Width(self.titleLabel);
    }
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SpaceW(20));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(self);
    }];
    
    if (holderStr.length > 0) {
        self.textField.placeholder = holderStr;
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(SpaceW(20));
            make.top.bottom.equalTo(self.titleLabel);
            make.right.equalTo(self).offset(SpaceW(-20));
        }];
    }
}

#pragma mark - Getters

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];;
    }
    
    return _titleLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeyDone;
    }
    
    return _textField;
}

- (UIImageView *)lineImageV
{
    if (!_lineImageV) {
        _lineImageV = [[UIImageView alloc] init];
        _lineImageV.backgroundColor = kGrayColor;
    }
    return _lineImageV;
}


@end
