//
//  HCCarDetailCarParametersCell.m
//  LuxuryCar
//
//  Created by sunhui on 16/11/16.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "HCCarDetailCarParametersCell.h"
#import "VFCarDetailModel.h"

@interface HCCarDetailCarParametersCell ()

@property (nonatomic, strong) UIView *bgView; /* 圆角背景 */
@property (nonatomic, strong) NSArray *labelTextArr; /* 内容数据 */
@property (nonatomic, strong) UIView *createView; /* 内容数据 */

@end

@implementation HCCarDetailCarParametersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.backgroundColor = kClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Private & Public Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bgView.bounds;
    shapeLayer.path = path.CGPath;
    self.bgView.layer.mask = shapeLayer;

}
- (void)setupUI
{
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = klineColor;
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView);
        make.bottom.equalTo(_bgView);
        make.width.mas_equalTo(_bgView);
        make.height.mas_equalTo(1);
    }];
    
//    [self layoutIfNeeded];
}


#pragma mark - Getters

- (void)setCarDetailModel:(VFCarDetailModel *)carModel
{
    
    VFCarAttrDetailModel *model = [[VFCarAttrDetailModel alloc]initWithDic:carModel.attr];
    NSArray *dataArr;
    if (model.stereotype.count == 0) {
        dataArr = @[carModel.brand,model.drive,model.output,@"",model.gear,model.seats];
    }else{
        dataArr = @[carModel.brand,model.drive,model.output,model.stereotype[0],model.gear,model.seats];
    }
    self.labelTextArr = @[@"厂        商",
                          @"驱动方式",
                          @"发  动  机",
                          @"类        别",
                          @"变  速  箱",
                          @"座  位  数"];
    
    for (int i=0; i<6; i++) {
        
        UIView *bgView = [[UIView alloc]init];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            if (i==0) {
                make.top.mas_equalTo(0);
            }else{
                make.top.mas_equalTo(_createView.mas_bottom);
            }
            
            if (i== 0 || i== 2 || i==4) {
                make.height.mas_equalTo(36);
            }else{
                make.height.mas_equalTo(52);
            }
        }];
        _createView = bgView;
        if (i== 0 || i== 2 || i==4) {
            bgView.backgroundColor = kNewBgColor;
        }else{
            bgView.backgroundColor = kWhiteColor;
        }
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:kTitleBigSize];
        label.textColor = kNewDetailColor;
        [bgView addSubview:label];
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
        rightLabel.textColor = kdetailColor;
        [bgView addSubview:rightLabel];
        
        label.text = _labelTextArr[i];
        rightLabel.text = dataArr[i];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(105);
            make.height.mas_equalTo(bgView);
        }];
        label.tag = 100+i;
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(kScreenW-120);
            make.height.mas_equalTo(bgView);
        }];
        rightLabel.tag = 1000+i;
    }
    
//    for (NSInteger i = 0; i < self.labelTextArr.count; i++) {
//        UILabel *label = (UILabel *)[self viewWithTag:i+100];
//        UILabel *rightLabel = (UILabel *)[self viewWithTag:i+1000];
//        label.text = _labelTextArr[i];
//        rightLabel.text = dataArr[i];
//    }
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [CustomTool createUIViewWithBackColor:kWhiteColor];
    }
    return _bgView;
}

@end

