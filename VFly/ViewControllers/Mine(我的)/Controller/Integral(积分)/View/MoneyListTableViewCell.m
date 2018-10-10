//
//  MoneyListTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MoneyListTableViewCell.h"

@implementation MoneyListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-1);
    }];
    
    _topLabel = [[UILabel alloc]init];
    _topLabel.font  =[UIFont systemFontOfSize:kTitle];
    _topLabel.textColor = ktitleColor;
    _topLabel.text = @"+6000";
    [bgView addSubview:_topLabel];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.top.equalTo(bgView).offset(20);
        make.width.mas_equalTo(kScreenW-20);
        make.height.mas_equalTo(kTitle);
    }];
    
    UILabel *instructions = [self createLeftLabelTitle:@"变更说明"];
    [bgView addSubview:instructions];
    [instructions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.top.equalTo(_topLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
    }];
    
    UILabel *time = [self createLeftLabelTitle:@"变更时间"];
    [bgView addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.top.equalTo(instructions.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
    }];
    
    _integral = [self createLeftLabelTitle:@"变更积分"];
    [bgView addSubview:_integral];
    [_integral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.top.equalTo(time.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
    }];
    
    _instructionsLabel = [self createRightLabelTitle:@"订单"];
    [bgView addSubview:_instructionsLabel];
    [_instructionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-10);
        make.top.equalTo(_topLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(14);
    }];
    
    _timeLabel = [self createRightLabelTitle:@"2017"];
    [bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-10);
        make.top.equalTo(_instructionsLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
    }];
    
    _integralLabel = [self createRightLabelTitle:@"0"];
    [bgView addSubview:_integralLabel];
    [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-10);
        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
    }];
}

-(UILabel *)createLeftLabelTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = ktextGrayClolr;
    label.font = [UIFont systemFontOfSize:kTextBigSize];
    label.text = title;
    return label;
}

-(UILabel *)createRightLabelTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = ktitleColor;
    label.font = [UIFont systemFontOfSize:kTextBigSize];
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    return label;
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
