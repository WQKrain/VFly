//
//  VFUseCarUserTableViewCell.m
//  VFly
//
//  Created by Hcar on 2018/4/25.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFUseCarUserTableViewCell.h"
#import "VFUseCarUseeListModel.h"

@interface VFUseCarUserTableViewCell ()
@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UILabel *showLabel;
@property (nonatomic , strong)UILabel *mobileLabel;
@property (nonatomic , strong)UIImageView *headerImage;
@property (nonatomic , strong)UIImageView *backImage;
@property (nonatomic , strong)UIImageView *cardImage;
@property (nonatomic , strong)UILabel *cardStateLabel;

@end

@implementation VFUseCarUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    
//    UIImageView *bgImgae = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_News"]];
//    [self addSubview:bgImgae];
//    [bgImgae mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(10);
//        make.right.bottom.mas_equalTo(-10);
//    }];
//
//    _nameLabel = [UILabel initWithTitle:@"" withFont:kTitleSize textColor:kTitleBoldColor];
//    [self addSubview:_nameLabel];
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(25);
//        make.top.mas_equalTo(40);
//        make.height.mas_equalTo(25);
//    }];
//
//    _showLabel = [UILabel initWithTitle:@"已有用车人信息不能编辑" withFont:kTextSize textColor:kdetailColor];
//    [self addSubview:_showLabel];
//    [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_nameLabel.mas_right).offset(10);
//        make.top.mas_equalTo(47);
//        make.height.mas_equalTo(17);
//    }];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = kViewBgColor;
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
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    _mobileLabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kdetailColor];
    [bgView addSubview:_mobileLabel];
    [_mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.height.equalTo(_nameLabel);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = klineColor;
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(54);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *leftLabel = [UILabel initWithTitle:@"实名认证" withFont:kTitleBigSize textColor:kdetailColor];
    [bgView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(64);
    }];
    
    _cardImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"前进"]];
    [bgView addSubview:_cardImage];
    [_cardImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLabel).offset(25);
        make.right.mas_equalTo(-10);
        make.height.width.mas_equalTo(16);
    }];
    
    _cardStateLabel = [UILabel initWithTitle:@"" withFont:kTitleBigSize textColor:kTextBlueColor];
    _cardStateLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_cardStateLabel];
    [_cardStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(leftLabel);
        make.right.equalTo(_cardImage.mas_left).offset(-5);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLabel);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(leftLabel);
    }];
    
    UIView *bottomlineView = [[UIView alloc]init];
    bottomlineView.backgroundColor = klineColor;
    [bgView addSubview:bottomlineView];
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(leftLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    

    UILabel *idLabel = [UILabel initWithTitle:@"免押信用资料" withFont:kTitleBigSize textColor:kdetailColor];
    [bgView addSubview:idLabel];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.equalTo(leftLabel.mas_bottom);
        make.height.mas_equalTo(64);
    }];
    
    _backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"前进"]];
    [bgView addSubview:_backImage];
    [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idLabel).offset(25);
        make.right.mas_equalTo(-10);
        make.height.width.mas_equalTo(16);
    }];
    
    UILabel *bottomStateLabel = [UILabel initWithTitle:@"去完善" withFont:kTitleBigSize textColor:kTextBlueColor];
    bottomStateLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:bottomStateLabel];
    [bottomStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(idLabel);
        make.right.equalTo(_backImage.mas_left).offset(-5);
        
    }];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.tag = 1;
    [bottomButton addTarget:self action:@selector(buttonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idLabel);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(idLabel);
    }];
}

- (void)buttonClcik:(UIButton *)button{
    
    if (button.tag == 0) {
        if ([_model.card_face isEqualToString:@""] || [_model.driving_licence isEqualToString:@""]) {
           
        }else{
             return;
        }
    }
    if ([self.delegate respondsToSelector:@selector(VFUseCarUserListCellClick:model:)]) {
        [self.delegate VFUseCarUserListCellClick:button.tag model:_model];
    }
}

- (void)setModel:(VFUseCarUseeListModel *)model{
    _model = model;
    if ([model.card_face isEqualToString:@""] || [model.driving_licence isEqualToString:@""]) {
        _cardStateLabel.text = @"未认证";
        [_cardImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(16);
        }];
    }else{
        [_cardImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        _cardStateLabel.text = @"已认证";
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
