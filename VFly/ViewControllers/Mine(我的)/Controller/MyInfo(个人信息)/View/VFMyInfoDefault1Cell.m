//
//  VFMyInfoDefault1Cell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFMyInfoDefault1Cell.h"

@implementation VFMyInfoDefault1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.pushImageV];

    self.leftLabel.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 10)
    .heightIs(30);
    [self.leftLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.pushImageV.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 17)
    .heightIs(16)
    .widthIs(16);
    
    self.titleLabel.sd_layout
    .rightSpaceToView(self.pushImageV, 10)
    .topSpaceToView(self.contentView, 10)
    .heightIs(30);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:200];

}

- (UILabel *)leftLabel {
    if (!_leftLabel)
    {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = [UIFont boldSystemFontOfSize:16];
        _leftLabel.backgroundColor = [UIColor whiteColor];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.textColor = HexColor(0x212121);
    }
    return _leftLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor = HexColor(0x212121);
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UIImageView *)pushImageV {
    if (!_pushImageV )
    {
        _pushImageV = [[UIImageView alloc]init];
        _pushImageV.image = [UIImage imageNamed:@"page_icon_go_hui"];
    }
    return _pushImageV;
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
