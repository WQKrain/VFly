//
//  VFSettingPushCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/13.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFSettingPushCell.h"

@implementation VFSettingPushCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 10)
    .heightIs(30)
    .widthIs(200);
    
    [self.contentView addSubview:self.pushSwitch];
    self.pushSwitch.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 10)
    .heightIs(30)
    .widthIs(50);
    
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HexColor(0x212121);
    }
    return _titleLabel;
}

- (UISwitch *)pushSwitch {
    if (!_pushSwitch)
    {
        _pushSwitch = [[UISwitch alloc]init];
        //缩小或者放大switch的size
        _pushSwitch.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        _pushSwitch.layer.anchorPoint = CGPointMake(0, 0.3);
        _pushSwitch.on = YES;
        [_pushSwitch setOn:YES animated:true];  //animated
        
        //判断开关的状态
        if (_pushSwitch.on)
        {
            NSLog(@"switch is on");
        }
        else
        {
            NSLog(@"switch is off");
        }
        
        //添加事件监听
        [_pushSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _pushSwitch.layer.cornerRadius = 15.0;
        _pushSwitch.backgroundColor = HexColor(0xA8A8A8);
        //定制开关颜色UI
        //tintColor 关状态下的背景颜色
//        _pushSwitch.tintColor = [UIColor yellowColor];
//        //onTintColor 开状态下的背景颜色
        _pushSwitch.onTintColor = [UIColor greenColor];
//        //thumbTintColor 滑块的背景颜色
        _pushSwitch.thumbTintColor = [UIColor whiteColor];
    }
    return _pushSwitch;
}

- (void)switchAction:(UISwitch *)sender {
    NSLog(@"_______switch");

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
