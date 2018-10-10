//
//  VFMyCouponCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFMyCouponCell.h"

@implementation VFMyCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(20, 16, kScreenW - 40, 120)];
    backgroundView.backgroundColor = HexColor(0xFAFAFA);
    [self.contentView addSubview:backgroundView];
    
    
    self.couponLabel = [[UILabel alloc]init];
    self.couponLabel.font = [UIFont boldSystemFontOfSize:18];
    self.couponLabel.backgroundColor = HexColor(0xFAFAFA);
    self.couponLabel.textAlignment = NSTextAlignmentLeft;
    self.couponLabel.textColor = [UIColor blackColor];
    self.couponLabel.text = @"尾款支付优惠券";
    [backgroundView addSubview:self.couponLabel];
    self.couponLabel.sd_layout
    .leftSpaceToView(backgroundView, 16)
    .topSpaceToView(backgroundView, 10)
    .heightIs(24);
    [self.couponLabel setSingleLineAutoResizeWithMaxWidth:0];
    
    self.mkLabel = [[UILabel alloc]init];
    self.mkLabel.font = [UIFont boldSystemFontOfSize:12];
    self.mkLabel.backgroundColor = HexColor(0xFAFAFA);
    self.mkLabel.textAlignment = NSTextAlignmentLeft;
    self.mkLabel.textColor = HexColor(0xA8A8A8);
    self.mkLabel.text = @"满3000元可用";
    [backgroundView addSubview:self.mkLabel];
    self.mkLabel.sd_layout
    .leftSpaceToView(backgroundView, 16)
    .topSpaceToView(backgroundView, 34)
    .heightIs(18);
    [self.mkLabel setSingleLineAutoResizeWithMaxWidth:0];
    
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.font = [UIFont boldSystemFontOfSize:24];
    self.priceLabel.backgroundColor = HexColor(0xFAFAFA);
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.text = @"¥ 500.00";
    [backgroundView addSubview:self.priceLabel];
    self.priceLabel.sd_layout
    .rightSpaceToView(backgroundView, 16)
    .topSpaceToView(backgroundView, 10)
    .heightIs(40);
    [self.priceLabel setSingleLineAutoResizeWithMaxWidth:0];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont boldSystemFontOfSize:12];
    self.timeLabel.backgroundColor = HexColor(0xFAFAFA);
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = HexColor(0xA8A8A8);
    self.timeLabel.text = @"有效期至L：2018-08-08";
    [backgroundView addSubview:self.timeLabel];
    self.timeLabel.sd_layout
    .leftSpaceToView(backgroundView, 16)
    .bottomSpaceToView(backgroundView, 10)
    .heightIs(18);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:0];
    
    self.isOutTimeLabel = [[UILabel alloc]init];
    self.isOutTimeLabel.font = [UIFont systemFontOfSize:12];
    self.isOutTimeLabel.backgroundColor = HexColor(0xFAFAFA);
    self.isOutTimeLabel.textAlignment = NSTextAlignmentRight;
    self.isOutTimeLabel.textColor = [UIColor blackColor];
    self.isOutTimeLabel.text = @"立即使用";
    [backgroundView addSubview:self.isOutTimeLabel];
    self.isOutTimeLabel.sd_layout
    .rightSpaceToView(backgroundView, 16)
    .bottomSpaceToView(backgroundView, 10)
    .heightIs(24);
    [self.isOutTimeLabel setSingleLineAutoResizeWithMaxWidth:0];
    

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
