//
//  CollectionViewCell.m
//  JSFLuxuryCar
//
//  Created by joyingnet on 16/7/30.
//  Copyright © 2016年 joyingnet. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Header.h"
#import "DriveTravelModel.h"

@interface CollectionViewCell ()
@property (nonatomic , strong)UIImageView *bgView;
@property (nonatomic , strong)UIImageView *carImage;
@property (nonatomic , strong)UILabel *decriptionLabel;
@property (nonatomic , strong)UILabel *price;
@property (nonatomic , strong)UIView *bottomView;
@property (nonatomic , strong)UILabel *selectlabel;
@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_car_MianYaJin_car"]];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        _carImage = [[UIImageView alloc]init];
        [self addSubview:_carImage];
        [_carImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(6);
            make.right.mas_equalTo(-6);
            make.height.mas_equalTo((self.width-14) *kPicZoom);
        }];
        
        _decriptionLabel = [UILabel initWithFont:kTextBigSize textColor:kTitleBoldColor];
        _decriptionLabel.font = [UIFont fontWithName:kBlodFont size:kTextBigSize];
        [self addSubview:_decriptionLabel];
        [_decriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_carImage.mas_bottom).offset(10);
            make.left.mas_equalTo(17);
            make.right.mas_equalTo(-17);
            make.height.mas_equalTo(20);
        }];
        
        _price = [UILabel initWithFont:kTextSize textColor:kMainColor];
        [self addSubview:_price];
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_decriptionLabel);
            make.top.equalTo(_decriptionLabel.mas_bottom).offset(27);
            make.right.mas_equalTo(-17);
            make.height.mas_equalTo(28);
        }];
    }
    
    return self;
}

- (void)setModel:(DriveTravelListModel *)model{
    if (model) {
        _model = model;
        if (_bottomView) {
            [_bottomView removeFromSuperview];
        }
        _bottomView = [[UIView alloc]init];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.equalTo(_decriptionLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(16);
            make. right.mas_equalTo(0);
        }];
        
        self.decriptionLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.brand,self.model.model];
        self.price.text = [NSString stringWithFormat:@"¥%@/天",self.model.price];
        NSRange range = [self.price.text rangeOfString:self.model.price];
        [CustomTool setTextColor:self.price FontNumber:[UIFont fontWithName:kBlodFont size:kTitleSize] AndRange:range AndColor:kMainColor];
        
        [self.carImage sd_setImageWithURL:[NSURL URLWithString:self.model.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        NSArray *tags = model.tags;
        for (int i=0; i<tags.count; i++) {
            UILabel *label = [UILabel initWithTitle:tags[i] withFont:kTextSmallSize textColor:kWhiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = kdetailColor;
            [_bottomView addSubview:label];
            if (i == 0) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(0);
                    make.height.mas_equalTo(kTextBigSize);
                    [label sizeToFit];
                    make.width.mas_equalTo(label.width+4);
                }];
            }else{
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(_selectlabel.mas_right).offset(9);
                    make.top.mas_equalTo(0);
                    make.height.mas_equalTo(kTextBigSize);
                    [label sizeToFit];
                    make.width.mas_equalTo(label.width+4);
                }];
            }
            _selectlabel = label;
        }
    }
}



@end
