//
//  MineCell.m
//  LuxuryCar
//
//  Created by wang on 16/8/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

//复写初始化方法，在初始化方法中创建子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.moreLabel];
    }
    
    return self;
    
}


- (UILabel *)titleLable {
    if (!_titleLable)
    {
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake( 20, 22, 100, 20)];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.textColor = HexColor(0x212121);
        _titleLable.font = [UIFont boldSystemFontOfSize:18];
        _titleLable.text = @"我的订单";
    }
    return _titleLable;
}

- (UILabel *)moreLabel {
    if (!_moreLabel)
    {
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 170, 22, 150, 20)];
        _moreLabel.textColor = HexColor(0xA8A8A8);
        _moreLabel.textAlignment = NSTextAlignmentRight;
        _moreLabel.font = [UIFont boldSystemFontOfSize:12];
        _moreLabel.text = @"更多";
    }
    return _moreLabel;
}






@end
