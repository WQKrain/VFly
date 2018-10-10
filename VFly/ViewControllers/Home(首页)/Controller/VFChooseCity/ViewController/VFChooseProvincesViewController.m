//
//  VFChooseProvincesViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/11/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChooseProvincesViewController.h"
#import "VFChooseCityModel.h"
#import "VFhotCarModel.h"
#import "VFChooseCityViewController.h"
#import "VFChooseCountyViewController.h"
#import "HCSortString.h"

@interface VFChooseProvincesViewController ()<UITableViewDelegate,UITableViewDataSource>
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
@property (strong, nonatomic) NSString *header;
@end

@implementation VFChooseProvincesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    _hotCityArr = [[NSMutableArray alloc]init];
    [self loadData];
    [self createView];
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatutesBarH + 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc]init];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.frame = CGRectMake(0, 0, 64, kStatutesBarH + 44);
    [navView addSubview:backButton];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_icon_back_black"]];
    [backButton addSubview:backImageView];
    backImageView.sd_layout
    .leftSpaceToView(backButton, 20)
    .bottomSpaceToView(backButton, 0)
    .heightIs(24)
    .widthIs(24);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择城市";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    VFChooseCityViewController *vc =[[VFChooseCityViewController alloc]init];
    vc.cityID = model.cityID;
    vc.shortname = model.shortname;
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

- (UIView *)createtableHeaderView {
    if (!_tableHeaderView) {
        if (_hotCityArr.count>0) {
            if (_hotCityArr.count%3>0) {
                _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20, 80+kNavTitleH+45*(_hotCityArr.count/3+1))];
            }else{
                _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20, 80+kNavTitleH+45*(_hotCityArr.count/3))];
            }
        }else{
            _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20, 80+kNavTitleH)];
        }
        
        UILabel *label = [UILabel initWithNavTitle:_header];
        label.frame = CGRectMake(15, 0, kScreenW-30, kNavTitleH);
        label.font = [UIFont systemFontOfSize:kNewBigTitle];
        [_tableHeaderView addSubview:label];
        
        UILabel *hotLabel = [UILabel initWithTitle:@"热门城市" withFont:kTitleSize textColor:HexColor(0xA8A8A8)];
        hotLabel.font = [UIFont boldSystemFontOfSize:16];
        hotLabel.frame= CGRectMake(15, kNavTitleH, kScreenW-15, 40);
        [_tableHeaderView addSubview:hotLabel];
        
        for (int i=0; i<_hotCityArr.count; i++)
        {
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
        UILabel *leftlabel = [[UILabel alloc]init];
        leftlabel.font = [UIFont boldSystemFontOfSize:16];
        leftlabel.text = @"选择省份";
        leftlabel.textColor = HexColor(0xA8A8A8);
        [_tableHeaderView addSubview:leftlabel];

        leftlabel.sd_layout
        .leftSpaceToView(_tableHeaderView, 15)
        .bottomSpaceToView(_tableHeaderView, 0)
        .heightIs(40);
        [leftlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.font = [UIFont boldSystemFontOfSize:12];
        rightLabel.text = @"(按首字母顺序)";
        rightLabel.textColor = HexColor(0xA8A8A8);
        [_tableHeaderView addSubview:rightLabel];

        rightLabel.sd_layout
        .leftSpaceToView(leftlabel, 0)
        .bottomSpaceToView(_tableHeaderView, 0)
        .heightIs(40);
        [rightLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
//        [_tableHeaderView addSubview:leftlabel];
    }
    return _tableHeaderView;
}

- (void)loadData{
    
    [HttpManage getHotCitySuccessBlock:^(NSDictionary *data) {
        VFhotCarModel *model = [[VFhotCarModel alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.hotCitys) {
            VFhotCarListModel *model = [[VFhotCarListModel alloc]initWithDic:dic];
            [tempArr addObject:model];
        }
        _hotCityArr = tempArr;
        self.tableView.tableHeaderView = [self createtableHeaderView];
        
    } withFailureBlock:^(NSError *error) {
        
    }];
    kWeakSelf;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray* dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *cityArr = [[NSMutableArray alloc]init];
    NSMutableArray *cityNameArr= [[NSMutableArray alloc]init];
    //此步骤取出所有的市
    for (NSDictionary *city in dataArr) {
        VFChooseCityModel *model = [[VFChooseCityModel alloc]initWithDic:city];
        if ([model.level isEqualToString:@"1"]) {
            [cityArr addObject:model];
            [cityNameArr addObject:model.name];
        }
    }
    _dataSource = cityArr;
    _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"name"];
    _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
    _searchDataSource = [NSMutableArray new];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
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
