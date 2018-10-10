//
//  VFSettingDefault1Cell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/13.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFSettingDefault1Cell.h"

@implementation VFSettingDefault1Cell

/*
 - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
 
 self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
 
 if (self) {
 [self setupView];
 }
 
 return self;
 
 }

 */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 10)
    .heightIs(30)
    .widthIs(200);
    
    [self.contentView addSubview:self.infomationLabel];
    self.infomationLabel.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 10)
    .heightIs(30)
    .widthIs(100);
    
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HexColor(0x212121);
    }
    return _titleLabel;
}

- (UILabel *)infomationLabel {
    if (!_infomationLabel)
    {
        _infomationLabel = [[UILabel alloc]init];
        _infomationLabel.font = [UIFont systemFontOfSize:12];
        _infomationLabel.backgroundColor = [UIColor whiteColor];
        _infomationLabel.textAlignment = NSTextAlignmentRight;
        _infomationLabel.textColor = HexColor(0xA8A8A8);
    }
    return _infomationLabel;
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
