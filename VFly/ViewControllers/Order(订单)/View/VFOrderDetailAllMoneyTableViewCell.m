//
//  VFOrderDetailAllMoneyTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2018/3/16.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFOrderDetailAllMoneyTableViewCell.h"
#import "VFOrderDetailModel.h"
#import "OrderDetailModel.h"

@interface VFOrderDetailAllMoneyTableViewCell ()
@property (nonatomic , strong)UILabel *priceLabel;
@property (nonatomic , strong)UILabel *showLabel;
@end

@implementation VFOrderDetailAllMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)setModel:(VFOrderDetailModel *)model{
    _priceLabel.text = kFormat(@"总租金 ￥%@",model.re_rental);
    
    NSRange range = [_priceLabel.text rangeOfString:@"￥"];
    [CustomTool setTextColor:_priceLabel FontNumber:[UIFont fontWithName:kBlodFont size:kTitleSize] AndRange:range AndColor:kTitleBoldColor];
    
    _showLabel.text = @"取车前需支付押金与违章保证金，还车后退回";
}

- (void)setOldModel:(OrderDetailModel *)oldModel{
    _priceLabel.text = kFormat(@"总租金 ￥%.2f",[oldModel.rentalMoney floatValue]+[oldModel.frontMoney floatValue]);
    
    NSRange range = [_priceLabel.text rangeOfString:@"￥"];
    [CustomTool setTextColor:_priceLabel FontNumber:[UIFont fontWithName:kBlodFont size:kTitleSize] AndRange:range AndColor:kTitleBoldColor];
    
    _showLabel.text = kFormat(@"取车前需支付押金与违章保证金总计￥%.2f，还车后退回",[oldModel.depositMoney floatValue]+[oldModel.illegalMoney floatValue]);
}

- (void)createView{
    _priceLabel = [UILabel initWithTitle:@"" withFont:kNewTitle textColor:kTitleBoldColor];
    [_priceLabel setFont:[UIFont fontWithName:kBlodFont size:kNewTitle]];
    [self addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_offset(21);
        make.height.mas_offset(33);
    }];
    
    _showLabel = [UILabel initWithTitle:@"" withFont:kTextSize textColor:kMainColor];
    [self addSubview:_showLabel];
    [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.equalTo(_priceLabel.mas_bottom).offset(7);
        make.height.mas_offset(17);
    }];
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
