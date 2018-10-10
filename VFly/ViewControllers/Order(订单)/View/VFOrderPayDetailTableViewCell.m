//
//  VFOrderPayDetailTableViewCell.m
//  VFly
//
//  Created by Hcar on 2018/4/18.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFOrderPayDetailTableViewCell.h"
#import "VFOrderDetailModel.h"

@interface VFOrderPayDetailTableViewCell()
@property (nonatomic , strong) UILabel *leftLabel;
@property (nonatomic , strong) UILabel *rightLabel;
@property (nonatomic , strong) UILabel *timeLabel;

@end

@implementation VFOrderPayDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    _leftLabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kTitleBoldColor];
    [self addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(self);
    }];
    
    _rightLabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kdetailColor];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    _timeLabel = [UILabel initWithTitle:@"" withFont:kTextSize textColor:kdetailColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightLabel.mas_left);
        make.left.lessThanOrEqualTo(_leftLabel.mas_right);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(17);
    }];
}

- (void)setModel:(VFOrderDetailPayListModel *)model{
    _leftLabel.text = kFormat(@"¥%@", model.price);
    _rightLabel.text = model.method;
    _timeLabel.text = [CustomTool changChineseTimeStr:model.created_at];
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
