//
//  VFChooseCityViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChooseCityViewController.h"
#import "VFChooseCountyViewController.h"
#import "VFSeachCityViewController.h"
#import "VFChooseCityModel.h"
#import "VFhotCarModel.h"
#import "HCSortString.h"
#import <objc/runtime.h>

@interface VFChooseCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) VFChooseCityModel *model;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *ary;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (strong, nonatomic) UIView *tableHeaderView;
@property (strong, nonatomic) NSMutableArray *hotCityArr;

@end

@implementation VFChooseCityViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didSelectedItem:(SelectedItem)block {
    self.block = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"城市选择";
    _hotCityArr = [[NSMutableArray alloc]init];
    [self loadData];
    [self createView];
    [self replaceDefaultNavBar:[self createNavView]];
}

- (UIView *)createNavView{
    UIView *navView = [[UIView alloc]init];
    navView.frame = CGRectMake(0, 0, kScreenW, kStatutesBarH+44);
    
    anyButton *backButton = [anyButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, kStatutesBarH, 52, 44);
    [backButton setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
    [backButton changeImageFrame:CGRectMake(15, 11, 22, 22)];
    [backButton addTarget:self action:@selector(backButtonnClcik) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(backButton.right, kStatutesBarH+11, 1, 22)];
    lineView.backgroundColor = klineColor;
    [navView addSubview:lineView];
    UILabel *titlelabel = [UILabel initWithTitle:@"选择市" withFont:kTitleSize textColor:kdetailColor];
    titlelabel.frame = CGRectMake(lineView.right+15, backButton.top, 100, 44);
    [navView addSubview:titlelabel];
    
    return navView;
}

- (void)backButtonnClcik{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kStatutesBarH+44, kScreenW, kScreenH-kStatutesBarH-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark - UITableViewDataSource-----------------

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexDataSource;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _indexDataSource[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *value = [_allDataSource objectForKey:_indexDataSource[section]];
    return value.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
    VFChooseCityModel *model = value[indexPath.row];
    VFChooseCountyViewController *vc =[[VFChooseCountyViewController alloc]init];
    vc.cityID = model.cityID;
    vc.cityName = model.shortname;
    vc.pid = model.pid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
    VFChooseCityModel *model = value[indexPath.row];
    cell.textLabel.text = model.name;
    
    cell.textLabel.font = [UIFont systemFontOfSize:kTextBigSize];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

- (UIView *)createtableHeaderView{
    if (!_tableHeaderView) {
        if (_hotCityArr.count>0) {
            if (_hotCityArr.count%3>0) {
                _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20, 80+45*(_hotCityArr.count/3+1))];
            }else{
                _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20, 80+45*(_hotCityArr.count/3))];
            }
        }else{
            _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20, 80)];
        }
        UILabel *hotLabel = [UILabel initWithTitle:@"热门城市" withFont:kTitleSize textColor:kdetailColor];
        hotLabel.frame= CGRectMake(15, 0, kScreenW-15, 40);
        [_tableHeaderView addSubview:hotLabel];
        
        for (int i=0; i<_hotCityArr.count; i++) {
            VFhotCarListModel * model = _hotCityArr[i];
            UILabel *label = [UILabel initWithTitle:model.shortname withFont:kTextBigSize textColor:kdetailColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(36+i%3*((kScreenW-105)/3+15), hotLabel.bottom+7+i/3*45, (kScreenW-105)/3, 35);
            label.backgroundColor = kNewBgColor;
            [_tableHeaderView addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(36+i%3*((kScreenW-105)/3+15), hotLabel.bottom+7+i/3*45, (kScreenW-105)/3, 45);
            button.tag = i;
            [button addTarget:self action:@selector(searchButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
            [_tableHeaderView addSubview:button];
        }
        UILabel *leftlabel = [UILabel initWithTitle:@"选择城市" withFont:kTitleSize textColor:kdetailColor];
        leftlabel.frame = CGRectMake(15, _tableHeaderView.height-40, 100, 40);
        [_tableHeaderView addSubview:leftlabel];
    }
    return _tableHeaderView;
}

- (void)loadData{
    
//    [HttpManage getHotCitySuccessBlock:^(NSDictionary *data) {
//        VFhotCarModel *model = [[VFhotCarModel alloc]initWithDic:data];
//        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
//        for (NSDictionary *dic in model.hotCitys) {
//            VFhotCarListModel *model = [[VFhotCarListModel alloc]initWithDic:dic];
//            [tempArr addObject:model];
//        }
//        _hotCityArr = tempArr;
//        self.tableView.tableHeaderView = [self createtableHeaderView];
//
//    } withFailureBlock:^(NSError *error) {
//
//    }];
    kWeakSelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        NSArray* dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *cityArr = [[NSMutableArray alloc]init];
        //此步骤取出所有的市
        for (NSDictionary *city in dataArr) {
            VFChooseCityModel *model = [[VFChooseCityModel alloc]initWithDic:city];
            if ([model.pid isEqualToString:self.cityID]) {
                [cityArr addObject:model];
            }
        }
        _dataSource = cityArr;
        _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"name"];
        _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
        _searchDataSource = [NSMutableArray new];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });

}

- (void)searchButtonClcik:(UIButton *)sender{
    VFhotCarListModel * model = _hotCityArr[sender.tag];
    VFChooseCountyViewController *vc =[[VFChooseCountyViewController alloc]init];
    vc.cityID = model.cityID;
    //self.hidesBottomBarWhenPushed = YES;
    vc.cityName = model.shortname;
    
    [JSFProgressHUD showHUDToView:self.view];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray* dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    //此步骤取出所有的市
    NSString *pid=@"";
    for (NSDictionary *temoCity in dataArr) {
        VFChooseCityModel *obj = [[VFChooseCityModel alloc]initWithDic:temoCity];
        if ([obj.shortname isEqualToString:model.shortname]) {
            pid = obj.pid;
            [JSFProgressHUD hiddenHUD:self.view];
        }
    }
    vc.pid = pid;
    [self.navigationController pushViewController:vc animated:YES];
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
