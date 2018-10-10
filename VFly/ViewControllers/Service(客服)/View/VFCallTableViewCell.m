//
//  VFCallTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/25.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFCallTableViewCell.h"

@implementation VFCallTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    _leftImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImage];
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(15);
    }];
    
    _topLabel = [UILabel initWithFont:kTextBigSize textColor:kTitleBoldColor];
    [self.contentView addSubview:_topLabel];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(kScreenW-80);
        make.left.equalTo(_leftImage.mas_right).offset(15);
    }];
    
    _bottomLabel = [UILabel initWithFont:kTextSize textColor:kNewDetailColor];
    _bottomLabel.numberOfLines = 0;
    [self.contentView addSubview:_bottomLabel];
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-11);
        make.top.equalTo(_topLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(kScreenW-80);
        make.left.equalTo(_topLabel);
    }];
}

- (void)setIndexRow:(NSString *)indexRow{
    [_topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(kScreenW-80);
        make.left.equalTo(_leftImage.mas_right).offset(15);
    }];
    _topLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    _topLabel.text = @"威风总部 400-117-8880";
    _leftImage.image = [UIImage imageNamed:@"ZongBu"];
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
