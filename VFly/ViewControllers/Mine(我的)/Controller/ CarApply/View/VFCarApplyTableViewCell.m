//
//  VFCarApplyTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/11/17.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFCarApplyTableViewCell.h"

@implementation VFCarApplyTableViewCell

//复写初始化方法，在初始化方法中创建子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    _titlelabel = [[UILabel alloc]init];
    [self addSubview:_titlelabel];
    
    _inputField = [[UITextField alloc]init];
    [self addSubview:_inputField];
    
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.image = [UIImage imageNamed:@"资源 10"];
    [self addSubview:_iconImageView];
    
    _alertlabel = [UILabel initWithFont:kTextSize textColor:kMainColor];
    [self addSubview:_alertlabel];
    
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(21);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(22);
    }];
    
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titlelabel.mas_right).offset(20);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenW-120);
        make.height.mas_equalTo(64);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_titlelabel.mas_bottom).offset(9);
        make.width.height.mas_equalTo(10);
    }];
    
    [_alertlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(6);
        make.top.equalTo(_iconImageView);
        make.right.mas_equalTo(-15);
    }];
}

- (void)setIndex:(NSString *)index{
    _inputField.tag = [index intValue];
}

- (void)setState:(NSString *)state{
    if ([state isEqualToString:@"NO"]) {
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        [_alertlabel mas_updateConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo(0);
        }];
    }else{
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10);
        }];
        
        [_alertlabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10);
        }];
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
