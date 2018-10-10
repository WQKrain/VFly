//
//  VFIntegralTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFIntegralTableViewCell.h"

@implementation VFIntegralTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    
    _titleLabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kdetailColor];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW/2);
        make.height.mas_equalTo(kTitleBigSize);
    }];
    
    _topLabel = [UILabel initWithTitle:@"" withFont:kTextSize textColor:kNewDetailColor];
    [self.contentView addSubview:_topLabel];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(kScreenW-100);
        make.height.mas_equalTo(kTextSize);
    }];

    _detaillabel = [UILabel initWithTitle:@"" withFont:kNewTitle textColor:kdetailColor];
    _detaillabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_detaillabel];
    [_detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo((kScreenW-30)/2);
        make.height.mas_equalTo(kNewTitle);
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
