//
//  VFSettingLogOutCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/19.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFSettingLogOutCell.h"

@implementation VFSettingLogOutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self.contentView addSubview:self.logoutButton];
    self.logoutButton.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10);
    
}

- (UIButton *)logoutButton {
    if (!_logoutButton)
    {
        _logoutButton = [[UIButton alloc]init];
        _logoutButton.backgroundColor = [UIColor whiteColor];
        [_logoutButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
        [_logoutButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _logoutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_logoutButton addTarget:self action:@selector(logout:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _logoutButton;
}

- (void)logout:(UIButton *)sender {
    if (self.logoutHander)
    {
        self.logoutHander();
    }
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
