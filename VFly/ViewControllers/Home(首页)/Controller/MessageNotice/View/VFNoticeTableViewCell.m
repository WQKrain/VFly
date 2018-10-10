//
//  VFNoticeTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/18.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFNoticeTableViewCell.h"

@implementation VFNoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"background_News"];
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenW-16);
        make.height.mas_equalTo((kScreenW-30)*6/13+141);
    }];
    
    _titeLabel  = [[UILabel alloc]init];
    _titeLabel.textColor = kdetailColor;
    _titeLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [self.contentView addSubview:_titeLabel];
    
    [_titeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(22);
        make.top.equalTo(bgView).offset(20);
        make.width.mas_equalTo(kScreenW-50);
        make.height.mas_equalTo(22);
    }];
    
    _timelabel = [[UILabel alloc]init];
    _timelabel.textColor = kNewDetailColor;
    _timelabel.text = @"活动时间:";
    _timelabel.font = [UIFont systemFontOfSize:kTextBigSize];
    [self.contentView addSubview:_timelabel];
    
    [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titeLabel.mas_bottom).offset(5);
        make.left.equalTo(_titeLabel);
        make.width.mas_equalTo(kScreenW-50);
        make.height.mas_equalTo(22);
    }];
    
    _markImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_markImage];
    
    [self.markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(7);
        make.top.equalTo(_timelabel.mas_bottom).offset(15);
        make.height.mas_equalTo((kScreenW-30)*6/13);
        make.width.mas_equalTo(kScreenW-30);
    }];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.textColor = kdetailColor;
    _detailLabel.font = [UIFont systemFontOfSize:kTextBigSize];
    [self.contentView addSubview:_detailLabel];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(22);
        make.top.equalTo(_markImage.mas_bottom).offset(15);
        make.width.mas_equalTo(kScreenW-50);
        make.height.mas_equalTo(22);
    }];
    
//    UIView *lineView = [[UIView alloc]init];
//    lineView.backgroundColor = klineColor;
//    [self.contentView addSubview:lineView];
//
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_markImage);
//        make.top.equalTo(_detailLabel.mas_bottom).offset(15);
//        make.width.mas_equalTo(kScreenW-50);
//        make.height.mas_equalTo(1);
//    }];
//
//    UILabel *morelabel = [UILabel initWithTitle:@"查看详情" withFont:kTextBigSize textColor:kNewDetailColor];
//    [self.contentView addSubview:morelabel];
//
//    [morelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_markImage);
//        make.top.equalTo(lineView.mas_bottom).offset(17);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(kTextBigSize);
//    }];
//
//    UIImageView *iconImage = [[UIImageView alloc]init];
//    iconImage.image = [UIImage imageNamed:@"前进"];
//    [self.contentView addSubview:iconImage];
//
//    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(bgView.mas_right).offset(-10);
//        make.top.equalTo(lineView.mas_bottom).offset(16);
//        make.width.height.mas_equalTo(16);
//    }];
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
