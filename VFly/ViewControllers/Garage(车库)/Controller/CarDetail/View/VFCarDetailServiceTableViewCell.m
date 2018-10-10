//
//  VFCarDetailServiceTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/18.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFCarDetailServiceTableViewCell.h"
#import "anyButton.h"

@implementation VFCarDetailServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = kViewBgColor;
        
        NSArray *imageArr = @[[UIImage imageNamed:@"icon_service_transit"],[UIImage imageNamed:@"icon_service_CarState"],[UIImage imageNamed:@"icon_service_conpensate"],[UIImage imageNamed:@"icon_service_24hour"]];
        NSArray *titleArr = @[@"送货上门",@"车况保证",@"事故赔付",@"24h服务"];
        
        for (int i=0; i<4; i++) {
            anyButton *button = [anyButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(kScreenW-kSpaceW(46))/4, 7, (kScreenW-kSpaceW(46))/4, 108);
            [button setTitleColor:kdetailColor forState:UIControlStateNormal];
            [button setImage:imageArr[i] forState:UIControlStateNormal];
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button changeImageFrame:CGRectMake(30, 18, 30, 30)];
            [button changeTitleFrame:CGRectMake(0, 58, 91, kTitleBigSize)];
            [self.contentView addSubview:button];
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Rectangle2copy"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(kSpaceW(22));
            make.right.equalTo(self).offset(kSpaceW(-24));
        }];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender{
    if (self.carDetailServerClickBlock) {
        self.carDetailServerClickBlock(sender.tag);
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
