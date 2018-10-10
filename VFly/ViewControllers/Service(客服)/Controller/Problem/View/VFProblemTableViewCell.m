//
//  VFProblemTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/12.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFProblemTableViewCell.h"

@implementation VFProblemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{

    
    _deslabel = [UILabel initWithFont:kTextBigSize textColor:kdetailColor];
    _deslabel.numberOfLines = 0;
    [_deslabel setFont:[UIFont fontWithName:kBlodFont size:kTextBigSize]];
    [self addSubview:_deslabel];
    [_deslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-46);
        make.bottom.mas_equalTo(-18);
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
