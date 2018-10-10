//
//  VFBillTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/18.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFBillTableViewCell.h"

@implementation VFBillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _statelabel = [[UILabel alloc]init];
    _statelabel.textColor = kWhiteColor;
    _statelabel.textAlignment = NSTextAlignmentCenter;
    _statelabel.layer.cornerRadius = 24;
    _statelabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_statelabel];
    
    [self.statelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(48);
    }];
    
    _titeLabel  = [[UILabel alloc]init];
    _titeLabel.textColor = ktitleColor;
    _titeLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    _titeLabel.numberOfLines = 0;
    [self.contentView addSubview:_titeLabel];
    
    [_titeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statelabel.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(31);
        make.bottom.mas_equalTo(-31);
    }];
    
    _timelabel = [[UILabel alloc]init];
    _timelabel.textColor = kNewDetailColor;
    _timelabel.font = [UIFont systemFontOfSize:kTextBigSize];
    _timelabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timelabel];
    
    [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(kTextBigSize);
        make.top.mas_equalTo(15);
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
