//
//  VFChhoosepaybankCardTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/11/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChhoosepaybankCardTableViewCell.h"

@implementation VFChhoosepaybankCardTableViewCell

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
    _leftlabel.frame = CGRectMake(_iconImage.right+10, 10, kScreenW-80, 22);
    [self addSubview:_leftlabel];
    UILabel *alertlabel = [UILabel initWithTitle:@"单笔交易超过限额时请选择银行卡支付" withFont:(NSInteger)kTextSize textColor:kWhiteColor];
    alertlabel.backgroundColor = kMainColor;
    alertlabel.frame = CGRectMake(_iconImage.right+10, _leftlabel.bottom+5, kScreenW-80, 22);
    [alertlabel sizeToFit];
    alertlabel.frame = CGRectMake(_iconImage.right+10, _leftlabel.bottom+5, alertlabel.width+10, 17);
    alertlabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:alertlabel];
    
    _rightIamge = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-37, 25, 16, 16)];
    [self addSubview:_rightIamge];
    _rightIamge.image = [UIImage imageNamed:@"前进"];
    [self addSubview:_rightIamge];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
