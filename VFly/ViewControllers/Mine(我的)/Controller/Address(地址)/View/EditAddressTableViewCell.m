//
//  EditAddressTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "EditAddressTableViewCell.h"

@implementation EditAddressTableViewCell

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
    _addressLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [topView addSubview:_addressLabel];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(15);
        make.top.mas_offset(15);
        make.height.mas_equalTo(22);
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
