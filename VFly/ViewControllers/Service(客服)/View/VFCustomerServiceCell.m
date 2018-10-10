//
//  VFCustomerServiceCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCustomerServiceCell.h"

@implementation VFCustomerServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createView];
    }
    return self;
}

- (void)createView{

    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.bottomLabel];
    
    self.topLabel.sd_layout
    .leftSpaceToView(self.contentView , 20)
    .topSpaceToView(self.contentView, 5)
    .heightIs(20);
    [self.topLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    self.bottomLabel.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .bottomSpaceToView(self.contentView , 5)
    .heightIs(20);
    [self.bottomLabel setSingleLineAutoResizeWithMaxWidth:300];
}

- (UILabel *)topLabel {
    if (!_topLabel)
    {
        _topLabel = [[UILabel alloc]init];
        _topLabel.font = [UIFont boldSystemFontOfSize:16];
        _topLabel.backgroundColor = [UIColor whiteColor];
        _topLabel.textAlignment = NSTextAlignmentLeft;
        _topLabel.textColor = HexColor(0x212121);
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel)
    {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font = [UIFont boldSystemFontOfSize:16];
        _bottomLabel.backgroundColor = [UIColor whiteColor];
        _bottomLabel.textAlignment = NSTextAlignmentRight;
        _bottomLabel.textColor = HexColor(0x212121);
        _bottomLabel.text = @"";
    }
    return _bottomLabel;
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
