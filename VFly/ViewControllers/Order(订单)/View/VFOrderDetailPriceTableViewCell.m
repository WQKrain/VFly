//
//  VFOrderDetailPriceTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2018/3/16.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFOrderDetailPriceTableViewCell.h"

@implementation VFOrderDetailPriceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    _leftlabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kdetailColor];
    [self addSubview:_leftlabel];
    [_leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(9);
        make.height.mas_equalTo(22);
    }];
    
    _rightlabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kdetailColor];
    _rightlabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_rightlabel];
    [_rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(9);
        make.height.mas_equalTo(22);
    }];
    
    _leftImage = [[UIImageView alloc]init];
    [self addSubview:_leftImage];
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftlabel.mas_right);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(13);
    }];
    
    _stateLabel = [UILabel initWithTitle:@"" withFont:kTextSmallSize textColor:kWhiteColor];
    [self addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImage.mas_right).offset(-1);
        make.top.mas_equalTo(13);
        make.height.mas_equalTo(14);
    }];
}

- (void)setNeedLine:(BOOL)needLine{
    if (needLine) {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = kHomeLineColor;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(49);
        }];
    }
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
