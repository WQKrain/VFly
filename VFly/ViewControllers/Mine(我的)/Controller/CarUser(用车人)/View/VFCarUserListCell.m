//
//  VFCarUserListCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCarUserListCell.h"
#import "VFUseCarUseeListModel.h"

@interface VFCarUserListCell ()

@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UIButton *topButton;
@property (nonatomic , strong)UILabel *mobileLabel;
@property (nonatomic , strong)UIButton *bottomButton;

@end
@implementation VFCarUserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{

    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    _nameLabel = [UILabel initWithTitle:@"" withFont:kTitleSize textColor:kTitleBoldColor];
    [bgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topButton setTitle:@"未实名认证" forState:(UIControlStateNormal)];
    [self.topButton setBackgroundColor:[UIColor clearColor]];
    [self.topButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    self.topButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.topButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.topButton.layer setMasksToBounds:YES];
    [self.topButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.topButton.layer setBorderWidth:1.0];
    self.topButton.layer.borderColor = [UIColor redColor].CGColor;
    self.topButton.tag = 0;
    [self.topButton addTarget:self action:@selector(buttonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.topButton];
    self.topButton.sd_layout
    .rightSpaceToView(bgView, 20)
    .topSpaceToView(bgView, 13)
    .heightIs(24);
    [self.topButton setupAutoSizeWithHorizontalPadding:5 buttonHeight:24];
    
    
    _mobileLabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kdetailColor];
    [bgView addSubview:_mobileLabel];
    [_mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(55);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *idLabel = [UILabel initWithTitle:@"免押金资料" withFont:kTitleBigSize textColor:HexColor(0xA8A8A8)];
    [bgView addSubview:idLabel];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.equalTo(_mobileLabel.mas_bottom).offset(+10);
        make.height.mas_equalTo(64);
    }];
    
    self.bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomButton setTitle:@"继续完善" forState:(UIControlStateNormal)];
    [self.bottomButton setBackgroundColor:[UIColor clearColor]];
    [self.bottomButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.bottomButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.bottomButton.titleLabel.textAlignment = NSTextAlignmentRight;
    self.bottomButton.tag = 1;
    [self.bottomButton addTarget:self action:@selector(buttonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.bottomButton];
    self.bottomButton.sd_layout
    .rightSpaceToView(bgView, 20)
    .topSpaceToView(bgView, 110)
    .heightIs(24);
    [self.bottomButton setupAutoSizeWithHorizontalPadding:5 buttonHeight:24];
    
    
}

- (void)buttonClcik:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(VFCarUserListCellClick:model:)]) {
        [self.delegate VFCarUserListCellClick:button.tag model:_model];
    }
}

- (void)setModel:(VFUseCarUseeListModel *)model{
    _model = model;
    if ([model.card_face isEqualToString:@""] || [model.driving_licence isEqualToString:@""])
    {
        [self.topButton setTitle:@"未实名认证" forState:(UIControlStateNormal)];
        [self.topButton setBackgroundColor:[UIColor clearColor]];
        [self.topButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        self.topButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.topButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.topButton.layer setMasksToBounds:YES];
        [self.topButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [self.topButton.layer setBorderWidth:1.0];
        self.topButton.layer.borderColor = [UIColor redColor].CGColor;
    }
    else
    {
        [self.topButton setTitle:@"已实名认证" forState:(UIControlStateNormal)];
        [self.topButton setBackgroundColor:[UIColor clearColor]];
        [self.topButton setTitleColor:HexColor(0xA8A8A8) forState:(UIControlStateNormal)];
        self.topButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.topButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.topButton.layer setMasksToBounds:YES];
        [self.topButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [self.topButton.layer setBorderWidth:1.0];
        self.topButton.layer.borderColor = HexColor(0xA8A8A8).CGColor;
    }
    _mobileLabel.text = model.mobile;
    _nameLabel.text = model.nick_name;
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
