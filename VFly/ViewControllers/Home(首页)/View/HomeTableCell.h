//
//  HomeTableCell.h
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/15.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHomeCellReuseID    @"kHomeCellReuseID"

@interface HomeTableCell : UITableViewCell

- (void)createHeader:(UIView *)headerV Middle:(UIView *)middleV Footer:(UIView *)footerV;

@end
