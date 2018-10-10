//
//  ListCell.m
//  LuxuryCar
//
//  Created by wang on 16/8/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "HotCarModel.h"
@interface HomeCollectionViewCell ()

@property (nonatomic, strong) UIImageView *carPic;   // 车辆图片
@property (nonatomic, strong) UILabel *carTitle;     // 车辆标题
@property (nonatomic, strong) UILabel *carPrice;     // 车辆现价
@property (nonatomic, strong) UILabel *offerArea;    // 车辆原价
@property (nonatomic, strong) UIView *bottomView;


@end

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgImage = [[UIImageView alloc]init];
        bgImage.image = [UIImage imageNamed:@"background_hot"];
        [self addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        [self addSubview:self.carPic];
        self.carPic.frame = CGRectMake(6, 6, self.width-12, (self.width-12)*kPicZoom);
        
        [self addSubview:self.carTitle];
        [self addSubview:self.carPrice];
    }
    return self;
}

- (void)setModel:(HotCarListModel *)model
{
    _model = model;
    [self setNeedsLayout];
    NSArray *tags = model.tags;
    
    if (_bottomView) {
        [self.bottomView removeFromSuperview];
    }
    _bottomView = [[UIView alloc]init];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_carTitle.mas_bottom).offset(5);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(self.width);
    }];
    
    for (int i=0; i<tags.count; i++) {
        UILabel *label = [UILabel initWithTitle:tags[i] withFont:kTextSmallSize textColor:kWhiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = kTitleBoldColor;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 2;
        [_bottomView addSubview:label];
        if (i == 0) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(17);
                make.top.mas_offset(0);
                [label sizeToFit];
                make.width.mas_equalTo(label.width+8);
                make.height.mas_equalTo(13);
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_selectLabel.mas_right).offset(5);
                make.top.equalTo(_carTitle.mas_bottom).offset(5);
                [label sizeToFit];
                make.width.mas_equalTo(label.width+8);
                make.height.mas_equalTo(13);
            }];
        }
        _selectLabel = label;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.carPic fadeImageWithURL:self.model.image];
    self.carTitle.text = self.model.title;
    self.carPrice.text = kFormat(@"¥%@/天", self.model.price);
    
    NSString *contentStr = [NSString stringWithFormat:@"%@",self.model.price];
    NSRange range = [self.carPrice.text rangeOfString:contentStr];
    [CustomTool setTextColor:self.carPrice FontNumber:[UIFont systemFontOfSize:kTitleSize] AndRange:range AndColor:kMainColor];
    

    [self.carTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.carPic).offset(10);
        make.right.equalTo(self.carPic).offset(-10);
        make.top.equalTo(self.carPic.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];

    [self addSubview:self.offerArea];
    [self.offerArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.carTitle);
        make.top.equalTo(self.carTitle.mas_bottom).offset(SpaceH(15));
        make.height.mas_equalTo(@(SpaceH(24)));
        make.width.equalTo(self.carTitle);
    }];


    [self.carPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.carTitle);
        make.top.equalTo(self.carTitle.mas_bottom).offset(33);
        make.height.mas_equalTo(25);
    }];
    
}

#pragma mark - Getters/Setters

- (UIImageView *)carPic
{
    if (!_carPic) {
        _carPic = [[UIImageView alloc] init];
        _carPic.image = [UIImage imageNamed:@"place_holer_750x500"];
    }
    return _carPic;
}

- (UILabel *)carTitle
{
    if (!_carTitle) {
        _carTitle = [[UILabel alloc] init];
        _carTitle.font = [UIFont systemFontOfSize:kTextSize];;
        _carTitle.textColor = kdetailColor;
    }
    return _carTitle;
}

- (UILabel *)carPrice
{
    if (!_carPrice) {
        _carPrice = [[UILabel alloc] init];
        _carPrice.font = [UIFont systemFontOfSize:kTextSize];;
        _carPrice.textColor = kMainColor;
    }
    return _carPrice;
}

- (UILabel *)offerArea
{
    if (!_offerArea) {
        _offerArea = [[UILabel alloc] init];
        _offerArea.font = [UIFont systemFontOfSize:kTextSize];
        _offerArea.textColor = ktitleColor;
    }
    return _offerArea;
}

@end
