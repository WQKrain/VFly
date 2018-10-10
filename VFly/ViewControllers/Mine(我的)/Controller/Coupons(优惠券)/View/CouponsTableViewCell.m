//
//  CouponsTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/19.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "CouponsTableViewCell.h"

@implementation CouponsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    
    _topImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_topImage];
    [_topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.height.mas_equalTo((kScreenW-16)*272/722);
    }];
    
    _topLabel = [UILabel initWithFont:kNewBigTitle textColor:kWhiteColor];
    [self.contentView addSubview:_topLabel];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topImage).offset(23);
        make.top.equalTo(_topImage).offset((kSpaceW(25)));
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(kSpaceW(42));
    }];
    
    _detaillabel = [[UILabel alloc]init];
    _detaillabel.textColor = kdetailColor;
    _detaillabel.textAlignment = NSTextAlignmentRight;
    _detaillabel.font = [UIFont systemFontOfSize:kTextSize];
    [self.contentView addSubview:_detaillabel];
    
    [_detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topImage.mas_right).offset(-33);
        make.top.equalTo(_topImage).offset(kSpaceW(70));
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(kTextSize);
    }];

    UILabel *showlabel = [UILabel initWithTitle:@"立即使用" withFont:kTitleBigSize textColor:kdetailColor];
    showlabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:showlabel];
    [showlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topImage.mas_right).offset(-33);
        make.top.equalTo(_detaillabel.mas_bottom).offset(kSpaceW(9));
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(22);
    }];
    
    _bottonLabel = [UILabel initWithFont:kTextSize textColor:kWhiteColor];
    [self.contentView addSubview:_bottonLabel];
    [_bottonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topImage).offset(29);
        make.top.equalTo(_topLabel.mas_bottom).offset(kSpaceW(31));
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(kTextSize);
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
