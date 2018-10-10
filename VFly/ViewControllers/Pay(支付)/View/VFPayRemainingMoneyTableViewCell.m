//
//  VFPayRemainingMoneyTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/12/23.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFPayRemainingMoneyTableViewCell.h"

@implementation VFPayRemainingMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    _chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 21, 22, 22)];
    _chooseImage.image = [UIImage imageNamed:@"icon_checkbox_off"];
    [self addSubview:_chooseImage];
    
    _leftlabel = [UILabel initWithTitle:@"" withFont:kTextSize textColor:kMainColor];
    _leftlabel.frame = CGRectMake(47, 24, 200, kTitleBigSize);
    [self addSubview:_leftlabel];
    
    _rightlabel =[UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kdetailColor];
    _rightlabel.frame = CGRectMake(kScreenW-115, 24, 100, kTitleBigSize);
    _rightlabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_rightlabel];
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
