//
//  VFAddressCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFAddressCell.h"

@implementation VFAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.height.equalTo(self.contentView);
    }];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.textColor = ktitleColor;
    _addressLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:_addressLabel];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(20);
        make.top.mas_offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(kScreenW-30);
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
