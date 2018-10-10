//
//  VFSeachCityViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/21.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSeachCityViewController.h"
#import "VFChooseCityModel.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import "VFChooseCountyViewController.h"
#import "VFChooseCityViewController.h"
#import <objc/runtime.h>

@interface VFSeachCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) VFChooseCityModel *model;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@end

@implementation VFSeachCityViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"城市选择";
    _dataSource = [[NSMutableArray alloc]init];
    [self.navigationController.navigationBar setBackgroundColor:kWhiteColor];
    [self loadData];
    [self createView];
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"搜索";
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - UISearchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [_searchDataSource removeAllObjects];
    NSArray *ary = [NSArray new];
    //对排序好的数据进行搜索
    _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"name"];
    ary = [HCSortString getAllValuesFromDict:_allDataSource];
    
    if (searchController.searchBar.text.length == 0) {
        [_searchDataSource addObjectsFromArray:ary];
    }else {
        ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:searchController.searchBar.text andSearchByPropertyName:@"name"];
        [_searchDataSource addObjectsFromArray:ary];
    }
    [self.tableView reloadData];
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    self.tableView.frame= CGRectMake(0, 0, kScreenW, kScreenH);
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    self.tableView.frame= CGRectMake(0, 114, kScreenW, kScreenH-114);
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.searchController.active) {
        return _dataSource.count;
    }else {
        return _searchDataSource.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VFChooseCityModel * model;
    if (!self.searchController.active) {
        model = _dataSource[indexPath.row];
    }else {
        model = _searchDataSource[indexPath.row];
    }
    VFChooseCityViewController *vc =[[VFChooseCityViewController alloc]init];
    //self.hidesBottomBarWhenPushed = YES;
    vc.cityID = model.cityID;
    vc.shortname = model.shortname;
    vc.pid = model.pid;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (!self.searchController.active) {
        VFChooseCityModel *model = _dataSource[indexPath.row];
        cell.textLabel.text = model.name;
    }else{
        VFChooseCityModel *model = _searchDataSource[indexPath.row];
        cell.textLabel.text = model.name;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:kTextBigSize];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)loadData{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray* dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *cityArr = [[NSMutableArray alloc]init];
    //此步骤取出所有的市
    for (NSDictionary *city in dataArr) {
        VFChooseCityModel *model = [[VFChooseCityModel alloc]initWithDic:city];
        if ([model.level isEqualToString:@"2"]) {
            [cityArr addObject:model];
        }
    }
    _dataSource = cityArr;
    _searchDataSource = [NSMutableArray new];
    [_tableView reloadData];
}

#pragma mark - block
- (void)didSelectedItem:(SelectedItem)block {
    self.block = block;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
