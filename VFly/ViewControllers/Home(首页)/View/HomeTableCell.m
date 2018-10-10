//
//  HomeTableCell.m
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/15.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "HomeTableCell.h"
#import "HomeCollectionView.h"

@implementation HomeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = CGRectZero;
        self.backgroundColor = kWhiteColor;
    }
    
    return self;
}

- (void)prepareForReuse
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.frame = CGRectZero;
}

- (void)createHeader:(UIView *)headerV Middle:(UIView *)middleV Footer:(UIView *)footerV
{
    if (headerV) {
        headerV.frame = CGRectMake(0, 0, kScreenW, Height(headerV));
        [self addSubview:headerV];
    }
    if (middleV) {
        middleV.frame = CGRectMake(0, Height(headerV), kScreenW, Height(middleV));
        [self addSubview:middleV];
    }
    if (footerV) {
        footerV.frame = CGRectMake(0, Height(headerV) + Height(middleV), kScreenW, Height(footerV));
        [self addSubview:footerV];
    }
    
    self.size = CGSizeMake(kScreenW, Height(headerV) + Height(middleV) + Height(footerV));
//    DLog(@"HomeCell的高度为%f", self.size.height);
}

@end
