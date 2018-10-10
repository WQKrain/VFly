//
//  MyOrderTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/13.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    _CarImage = [[UIImageView alloc]init];
    [self addSubview:_CarImage];
    [_CarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(75);
    }];
    _statelabel = [UILabel initWithFont:kTextBigSize textColor:kMainColor];
    [self addSubview:_statelabel];
    _statelabel.textAlignment = NSTextAlignmentRight;
    [_statelabel setFont:[UIFont fontWithName:kBlodFont size:kTextBigSize]];
    [_statelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];
    
    _CarTitlelabel = [UILabel initWithFont:kTextBigSize textColor:kdetailColor];
    [self addSubview:_CarTitlelabel];
    [_CarTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.right.equalTo(_statelabel.mas_left).offset(-5);
        make.left.equalTo(_CarImage.mas_right).offset(20);
    }];
    
    _timeLabel = [UILabel initWithFont:kTextBigSize textColor:kMainColor];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_CarTitlelabel.mas_bottom).offset(10);
        make.right.mas_equalTo(15);
        make.left.equalTo(_CarImage.mas_right).offset(20);
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
