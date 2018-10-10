//
//  VFMyInfoHeaderImageViewCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFMyInfoHeaderImageViewCell.h"

@implementation VFMyInfoHeaderImageViewCell

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
    [self.contentView addSubview:self.headerImageView];
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
    
    self.headerImageView.sd_layout
    .rightSpaceToView(self.pushImageV, 10)
    .topSpaceToView(self.contentView, 7)
    .widthIs(36)
    .heightIs(36);
    self.headerImageView.layer.cornerRadius = 18;

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

- (UIImageView *)headerImageView {
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.layer.cornerRadius = 18;
    }
    return _headerImageView;
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
