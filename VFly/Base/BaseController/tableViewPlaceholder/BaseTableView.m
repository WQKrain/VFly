//
//  BaseTableView.m
//  TableViewNoContentView
//
//  Created by 蔡强 on 2017/4/26.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "BaseTableView.h"
#import "NoContentView.h"

@interface BaseTableView (){
    
}

@end

@implementation BaseTableView
/**
 展示无数据占位图
 
 @param emptyViewType 无数据占位图的类型
 */

- (void)showEmptyViewWithType:(NSInteger)emptyViewType image:(UIImage *)image title:(NSString *)title{
    self.bounces = NO;
    // 如果已经展示无数据占位图，先移除
    if (_noContentView) {
        [_noContentView removeFromSuperview];
        _noContentView = nil;
    }
    //------- 再创建 -------//
    if (_header) {
        _noContentView = [[NoContentView alloc]initWithFrame:CGRectMake(0, 0, self.width,  self.height)];
    }else{
        _noContentView = [[NoContentView alloc]initWithFrame:CGRectMake(0, 0, self.width,  self.height)];
    }
    
    [self addSubview:_noContentView];
    _noContentView.type = emptyViewType;
    [_noContentView setType:emptyViewType image:image title:title];
    
    //------- 添加单击手势 -------//
    [_noContentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noContentViewDidTaped:)]];
}

/* 移除无数据占位图 */
- (void)removeEmptyView{
    self.bounces = YES;
    [_noContentView removeFromSuperview];
    _noContentView = nil;
}

- (void)noContentViewFrame:(CGRect)frame{
    _noContentView.frame = frame;
}

- (void)noContentViewTop:(NSString *)top{
    _noContentView.imageTop = top;
}

// 无数据占位图点击
- (void)noContentViewDidTaped:(NoContentView *)noContentView{
    if (self.noContentViewTapedBlock)
    {
        self.noContentViewTapedBlock();//调用回调函数
    }
}

- (void)setHeader:(NSString *)header{
    _header = header;
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, kScreenW, kNavTitleH);
    UILabel *label = [UILabel initWithNavTitle:header];
    label.frame = CGRectMake(15, 0, kScreenW-30, kNavTitleH);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kNewBigTitle];
    [headerView addSubview:label];
    self.tableHeaderView = headerView;
}

@end
