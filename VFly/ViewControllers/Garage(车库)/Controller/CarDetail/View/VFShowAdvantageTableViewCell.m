//
//  VFShowAdvantageTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/20.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFShowAdvantageTableViewCell.h"

@implementation VFShowAdvantageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _showlabel = [UILabel initWithFont:kTextBigSize textColor:HexColor(0x1f1f1f)];
        _showlabel.numberOfLines = 0;
        [self addSubview:_showlabel];
        [_showlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(-30);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
    }
    
    return self;
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
