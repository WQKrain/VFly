//
//  VFCommonProDetailCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCommonProDetailCell.h"

@implementation VFCommonProDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView {
    
    _deslabel = [UILabel initWithFont:kTextBigSize textColor:kdetailColor];
    _deslabel.numberOfLines = 0;
    _deslabel.font = [UIFont systemFontOfSize:18];
    _deslabel.textColor = HexColor(0xA8A8A8);
    [self addSubview:_deslabel];
    [_deslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-46);
        make.bottom.mas_equalTo(-10);
    }];
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
