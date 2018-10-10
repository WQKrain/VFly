//
//  RHFiltrateCell.m
//  MCSchool
//
//  Created by 郭人豪 on 2016/12/24.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import "RHFiltrateCell.h"

@interface RHFiltrateCell ()

@property (nonatomic, strong) UILabel * lab_title;
@end
@implementation RHFiltrateCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lab_title];
    }
    return self;
}

#pragma mark - layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _lab_title.frame = self.bounds;
}

#pragma mark - config cell

- (void)configCellWithData:(NSDictionary *)dic {
    
    _lab_title.text = dic[@"title"];
    if ([dic[@"isSelected"] boolValue]) {
        _lab_title.backgroundColor = kHomeBgColor;
        _lab_title.textColor = kWhiteColor;
    } else {
        
        _lab_title.layer.borderWidth = 0.0;
        _lab_title.backgroundColor = kNewBgColor;
        _lab_title.textColor = kdetailColor;
    }
}

#pragma mark - setter and getter

- (UILabel *)lab_title {
    
    if (!_lab_title) {
        _lab_title = [[UILabel alloc] init];
        _lab_title.textAlignment = NSTextAlignmentCenter;
        _lab_title.font = [UIFont systemFontOfSize:kTitleBigSize];
    }
    return _lab_title;
}




@end
