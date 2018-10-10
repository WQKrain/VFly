//
//  RentCarHearderView.h
//  LuxuryCar
//
//  Created by Wang_zY on 2017/3/24.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH_RATE (SCREEN_WIDTH/375)   // 屏幕宽度系数（以4.7英寸为基准）
#define HEIGHT_RATE (SCREEN_HEIGHT/667)

#define NumberOfSinglePage 10 // 一个页面可容纳的最多按钮数
#define leftRightGap 14*WIDTH_RATE
#define topBottomGap 14*HEIGHT_RATE
#define ViewMargin 20
#define BtnWH 65

typedef void(^HeaderSelectedItemBlock)(NSInteger tag);

@interface RentCarHearderView : BaseView

/// 按钮数据源
@property (nonatomic,strong) NSArray * dataArr;
/// 按钮宽高，默认（65，65）
@property (nonatomic,assign) CGSize viewSize;
/// 一页可容纳的最多按钮数 默认 8
@property (nonatomic,assign) NSInteger numberOfSinglePage;
/// 按钮之间纵向间距 默认25
@property (nonatomic,assign) CGFloat viewGap;
/// 按钮的内边距 默认20
@property (nonatomic,assign) CGFloat viewMargin;

@property (nonatomic, copy) HeaderSelectedItemBlock selectedBlock;

@end
