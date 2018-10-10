//
//  DrivceTravelCollectionViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "DrivceTravelCollectionViewCell.h"
#import "VFhotCarMode.h"

@implementation DrivceTravelCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        
    }
    return self;
}

- (void)setModel:(VFhotCarListMode *)model {
    _model = model;
    NSArray *tags = _model.tags;
    for (int i=0; i<tags.count; i++)
    {
        UILabel *label = [UILabel initWithTitle:tags[i]
                                       withFont:kTextSmallSize
                                      textColor:HexColor(0xA8A8A8)];
        
        label.layer.cornerRadius = 4;
        label.layer.borderColor = HexColor(0xA8A8A8).CGColor;
        label.layer.borderWidth = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
        if (i == 0)
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.equalTo(_titleLabel).offset(27);
                make.height.mas_equalTo(kTextBigSize);
                [label sizeToFit];
                make.width.mas_equalTo(label.width+4);
            }];
        }
        else
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_selectLabel.mas_right).offset(9);
                make.top.equalTo(_titleLabel).offset(27);
                make.height.mas_equalTo(kTextBigSize);
                [label sizeToFit];
                make.width.mas_equalTo(label.width+4);
            }];
        }
        _selectLabel = label;
    }
}


- (void)initView {
    _titleImage = [[UIImageView alloc]init];
    _titleImage.image = [UIImage imageNamed:@"place_holer_750x500"];
    _titleImage.layer.cornerRadius = 4;
    _titleImage.layer.masksToBounds = YES;
    _titleImage.layer.borderWidth = 1;
    _titleImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.contentView addSubview:_titleImage];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = kTextColor;
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.textColor = kTextColor;
    _priceLabel.font = [UIFont systemFontOfSize:kTextBigSize];
    [_priceLabel sizeToFit];
    _priceLabel.textColor = kTextColor;
    _priceLabel.textColor = kMainColor;
    [self.contentView addSubview:_priceLabel];
    
    _tagLabel = [UILabel initWithTitle:@""
                              withFont:kTextSmallSize
                             textColor:kdetailColor];
    [self.contentView addSubview:_tagLabel];
    
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-109);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleImage.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
    }];

    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(13);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kTextSmallSize);
    }];

    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(6);
        make.left.right.mas_equalTo(0);
    }];
    
    
    
}



@end
