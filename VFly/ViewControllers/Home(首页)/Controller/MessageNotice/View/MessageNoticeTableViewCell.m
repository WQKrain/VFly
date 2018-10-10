//
//  MessageNoticeTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MessageNoticeTableViewCell.h"

@implementation MessageNoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initView {
    _markImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_markImage];
    
    [self.markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.height.mas_equalTo(48);
    }];
    
    _titeLabel  = [[UILabel alloc]init];
    _titeLabel.textColor = kdetailColor;
    _titeLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [self.contentView addSubview:_titeLabel];
    
    [_titeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_markImage.mas_right).offset(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(kTitleBigSize);
    }];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.textColor = kNewDetailColor;
    _detailLabel.font = [UIFont systemFontOfSize:kTextBigSize];
    [self.contentView addSubview:_detailLabel];
    
    _mesCountlabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kWhiteColor];
    _mesCountlabel.textAlignment = NSTextAlignmentCenter;
    _mesCountlabel.backgroundColor = kMainColor;
    _mesCountlabel.layer.masksToBounds = YES;
    _mesCountlabel.layer.cornerRadius = 8;
    [self.contentView addSubview:_mesCountlabel];
    _mesCountlabel.hidden = YES;
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_markImage.mas_right).offset(15);
        make.top.equalTo(_titeLabel.mas_bottom).offset(11);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    _timelabel = [[UILabel alloc]init];
    _timelabel.textColor = kNewDetailColor;
    _timelabel.font = [UIFont systemFontOfSize:kTextBigSize];
    _timelabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timelabel];
    
    [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(19);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(kTextBigSize);
    }];
    
    [_mesCountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timelabel.mas_bottom).offset(11);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
