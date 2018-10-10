//
//  BaseTableGroupedController.h
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewCell.h"

@interface BaseTableGroupedController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView; // tableView
@property (nonatomic, strong) NSMutableArray *tableDatasM; // 数据源

- (void)setupUI;
- (void)setupTableDatas;

@end
