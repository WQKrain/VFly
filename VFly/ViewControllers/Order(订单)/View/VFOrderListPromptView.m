//
//  VFOrderListPromptView.m
//  VFly
//
//  Created by Hcar on 2018/5/2.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFOrderListPromptView.h"

@interface VFOrderListPromptView ()
@property (nonatomic, strong)UIView *viewBg;
@end

@implementation VFOrderListPromptView

-(void)show
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kOrderAlertShow];
    self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self addSubview:_viewBg];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_previous"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [self.viewBg addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(kStatutesBarH);
    }];
    
    UIImageView *bottomImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reminder_previous"]];
    bottomImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.viewBg addSubview:bottomImage];
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-7);
        make.width.mas_equalTo(262);
        make.height.mas_equalTo(144);
        make.top.mas_equalTo(kStatutesBarH+3);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

@end
