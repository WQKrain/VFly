//
//  BaseTableGroupedController.m
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/4.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "BaseTableGroupedController.h"

@interface BaseTableGroupedController ()

@end

@implementation BaseTableGroupedController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableDatas];
    [self setupUI];
    [self.view addSubview:self.tableView];
}

#pragma mark - Publick Methods

- (void)setupTableDatas
{

}

- (void)setupUI
{

}

#pragma mark - UITableViewDelegate,UITableViewrankingDataS>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDatasM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)tableDatasM
{
    if (!_tableDatasM) {
        _tableDatasM = [NSMutableArray array];
    }
    return _tableDatasM;
}

@end
