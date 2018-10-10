//
//  NoContentView.m
//  iDeliver
//
//  Created by 蔡强 on 2017/3/27.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

//========== 无内容占位图 ==========//

#import "NoContentView.h"
#import "Masonry.h"

@interface NoContentView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UIButton *bottomButton;

@end

@implementation NoContentView

#pragma mark - 构造方法

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    //------- 图片 -------//
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    
    //------- 内容描述 -------//
    self.topLabel = [[UILabel alloc]init];
    [self addSubview:self.topLabel];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.numberOfLines = 0;
    self.topLabel.font = [UIFont systemFontOfSize:15];
    self.topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize];
    self.topLabel.textColor = kTextColor;
    
    //------- 提示点击重新加载 -------//
    self.bottomButton = [UIButton buttonWithTitle:@""];
    [self.bottomButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.bottomButton addTarget:self action:@selector(buttonClcik) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bottomButton];
    
    //------- 建立约束 -------//
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSpaceW(201), kSpaceW(201)));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(kSpaceH(170));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(kSpaceH(15));
        make.left.mas_offset(15);
        make.width.mas_equalTo(kScreenW-30);
    }];
    
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(kSpaceH(-60));
        make.centerX.mas_equalTo(self);
        make.height.mas_offset(36);
        make.width.mas_equalTo(165);
    }];
    
}

- (void)setImageTop:(NSString *)imageTop{
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([imageTop intValue]);
    }];
}

#pragma mark - 根据传入的值创建相应的UI
/** 根据传入的值创建相应的UI */
- (void)setType:(NSInteger)type image:(UIImage *)image title:(NSString *)title{
    switch (type) {
            
        case NoContentTypeNetwork: // 没网
        {
            [self setImage:[UIImage imageNamed:@"image_blankpage_network"] topLabelText:@"信号去火星了？检查一下呗" bottomLabelText:@"检查网络"];
            _bottomButton.hidden = NO;
        }
            break;
            
        case NoContentTypeOrder:
        {
            [self setImage:image topLabelText:title bottomLabelText:@""];
            _bottomButton.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (void)buttonClcik {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark - 设置图片和文字
/** 设置图片和文字 */
- (void)setImage:(UIImage *)imageName topLabelText:(NSString *)topLabelText bottomLabelText:(NSString *)bottomLabelText{
    self.imageView.image = imageName;
    self.topLabel.text = topLabelText;
    [self.bottomButton setTitle:bottomLabelText forState:UIControlStateNormal];
}

@end
