//
//  VFObtainPlacesTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/30.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFObtainPlacesTableViewCell.h"

@implementation VFObtainPlacesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    _indexlabel = [UILabel initWithFont:kTextSize textColor:kTitleBoldColor];
    [self addSubview:_indexlabel];
    _indexlabel.textAlignment = NSTextAlignmentCenter;
    [_indexlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kSpaceW(75));
    }];
    
    _namelabel = [UILabel initWithFont:kTextSize textColor:kTitleBoldColor];
    [self addSubview:_namelabel];
    _namelabel.textAlignment = NSTextAlignmentCenter;
    [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_indexlabel.mas_right);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kSpaceW(120));
    }];
    
    _moneylabel = [UILabel initWithFont:kTextSize textColor:kTitleBoldColor];
    [self addSubview:_moneylabel];
    _moneylabel.textAlignment = NSTextAlignmentCenter;
    [_moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_namelabel.mas_right);
        make.top.bottom.right.mas_equalTo(0);
    }];
}

- (void)setIndexRow:(NSString *)indexRow{
    
    [_topLine removeFromSuperview];
    [_bottomLine removeFromSuperview];
    
    if ([indexRow isEqualToString:@"0"]) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = kHomeLineColor;
        [self addSubview:_topLine];
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = kHomeLineColor;
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
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
