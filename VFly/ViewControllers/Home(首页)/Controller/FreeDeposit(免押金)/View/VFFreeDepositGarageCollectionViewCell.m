//
//  VFFreeDepositGarageCollectionViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/30.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFFreeDepositGarageCollectionViewCell.h"
#import "DriveTravelModel.h"

@implementation VFFreeDepositGarageCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_car_MianYaJin_car"]];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    _carImage = [[UIImageView alloc]init];
    [self addSubview:_carImage];
    [_carImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo((self.width-14) *kPicZoom);
    }];
    
    _decriptionLabel = [UILabel initWithFont:kTextBigSize textColor:kTitleBoldColor];
    [self addSubview:_decriptionLabel];
    [_decriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carImage.mas_bottom).offset(10);
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.height.mas_equalTo(20);
    }];
    
    _borderView = [[UIView alloc]init];
    _borderView.layer.borderWidth = 1;
    _borderView.layer.borderColor = kdetailColor.CGColor;
    [self addSubview:_borderView];
    [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_decriptionLabel);
        make.top.equalTo(_decriptionLabel.mas_bottom).offset(26);
        make.width.mas_equalTo(58);
        make.height.mas_equalTo(14);
    }];
    
    _deposit = [UILabel initWithFont:kTextSmallSize textColor:kdetailColor];
    [_borderView addSubview:_deposit];
    [_deposit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-5);
    }];

    _freeMoney = [UILabel initWithFont:kTextSmallSize textColor:kMainColor];
    [self addSubview:_freeMoney];
    [_freeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_borderView);
        make.top.equalTo(_borderView.mas_bottom).offset(17);
        make.right.mas_equalTo(-17);
        make.height.mas_equalTo(14);
    }];
  
    _price = [UILabel initWithFont:kTextSize textColor:kMainColor];
    [self addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_freeMoney);
        make.top.equalTo(_freeMoney.mas_bottom);
        make.right.mas_equalTo(-17);
        make.height.mas_equalTo(28);
    }];
    
    _rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"label_QuanMian"]];
    [self addSubview:_rightImage];
    _rightImage.hidden = YES;
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-6);
        make.width.height.mas_equalTo(68);
    }];
}


- (void)setModel:(DriveTravelListModel *)model{
    if (model) {
        _model = model;
        
        _bottomView = [[UIView alloc]init];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.equalTo(_decriptionLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(16);
            make. right.mas_equalTo(0);
        }];
        
        self.decriptionLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.brand,self.model.model];
        self.price.text = [NSString stringWithFormat:@"¥%@元/天",self.model.price];
        [self.carImage sd_setImageWithURL:[NSURL URLWithString:self.model.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        self.deposit.text = kFormat(@"押金 %@万", [CustomTool removeFloatAllZero:self.model.deposit]);
        _freeMoney.text = kFormat(@"免押金服务费¥%@", self.model.service_fee);

        CGSize titleSize = [self.deposit.text sizeWithFont:[UIFont systemFontOfSize:kTextSmallSize] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        
        [self.deposit sizeToFit];
        
        [_borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_deposit.width +10);
        }];
        
        if ([_model.label isEqualToString:@""]) {
            _rightImage.hidden = YES;
        }else{
            _rightImage.hidden = NO;
        }
        
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
