//
//  ShowBankTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/8/4.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ShowBankTableViewCell.h"

@implementation ShowBankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:bgView];
    
    _leftImage = [[UIImageView alloc]init];
    [bgView addSubview:_leftImage];
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    _topLabel = [[UILabel alloc]init];
    _topLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [bgView addSubview:_topLabel];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImage.mas_right).offset(10);
        make.top.equalTo(self).offset(24);
        make.width.mas_equalTo(kScreenW-100);
        make.height.mas_equalTo(kTextSize);
    }];
    
    _detaillabel = [[UILabel alloc]init];
    _detaillabel.textColor = kdetailColor;
    _detaillabel.font = [UIFont systemFontOfSize:kTextSize];
    [bgView addSubview:_detaillabel];
    
    [_detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topLabel);
        make.top.equalTo(_topLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(kScreenW-100);
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
