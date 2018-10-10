//
//  VFChoosePayTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/28.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChoosePayTableViewCell.h"

@implementation VFChoosePayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 21, 22, 22)];
    [self addSubview:_iconImage];
    
    _leftlabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kdetailColor];
    _leftlabel.frame = CGRectMake(_iconImage.right+10, 0, kScreenW-80, 67);
    [self addSubview:_leftlabel];
    
    _rightIamge = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-37, 25, 16, 16)];
    [self addSubview:_rightIamge];
    _rightIamge.image = [UIImage imageNamed:@"前进"];
    [self addSubview:_rightIamge];
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
