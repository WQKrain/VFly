//
//  BaseTableView.h
//  TableViewNoContentView
//
//  Created by 蔡强 on 2017/4/26.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoContentView;
@interface BaseTableView : UITableView

// 无数据占位图点击的回调函数
@property (copy,nonatomic) void(^noContentViewTapedBlock)(void);
@property (nonatomic , strong)NSString *header;
@property (nonatomic , strong)NoContentView *noContentView;
/**
 展示无数据占位图

 @param emptyViewType 无数据占位图的类型
 */
- (void)showEmptyViewWithType:(NSInteger)emptyViewType image:(UIImage *)image title:(NSString *)title;
- (void)updataContentViewTop:(NSString *)top;
/* 移除无数据占位图 */
- (void)removeEmptyView;

- (void)noContentViewFrame:(CGRect)frame;

- (void)noContentViewTop:(NSString *)top;

@end
