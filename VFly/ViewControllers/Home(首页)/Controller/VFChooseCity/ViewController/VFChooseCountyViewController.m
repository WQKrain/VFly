//
//  VFChooseCountyViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChooseCountyViewController.h"
#import "VFChooseCityModel.h"

@interface VFChooseCountyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)BaseTableView *tableView;
@end

@implementation VFChooseCountyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UILabel *titlelabel = [UILabel initWithTitle:@"选择区县" withFont:kTitleSize textColor:kdetailColor];
    titlelabel.frame = CGRectMake(lineView.right+15, backButton.top, 100, 44);
    [navView addSubview:titlelabel];
    
    return navView;
}
- (void)backButtonnClcik{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kStatutesBarH+ 44, kScreenW, kScreenH-kStatutesBarH-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (void)clearButtonClcik{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"hotSearchCar"];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VFChooseCityModel *model = _dataArr[indexPath.row];
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray* dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    //此步骤取出所有的市
    NSString *provinceName = @"";
    NSString *provinceID=@"";
    for (NSDictionary *temoCity in dataArr) {
        VFChooseCityModel *model = [[VFChooseCityModel alloc]initWithDic:temoCity];
        if ([model.cityID isEqualToString:_pid]) {
            provinceID = model.cityID;
            provinceName = model.shortname;
        }
    }
    NSDictionary *dic = @{@"provinceName":provinceName,@"provinceID":provinceID,@"cityName":self.cityName,@"cityID":self.cityID,@"countyID":model.cityID,@"countyName":model.name};
    [[NSUserDefaults standardUserDefaults]setObject:model.cityID forKey:kLocalCityID];
    [[NSNotificationCenter   defaultCenter] postNotificationName:@"changeCity" object:self userInfo:dic];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    VFChooseCityModel *model = _dataArr[indexPath.row];
    cell.textLabel.text = model.name;
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
        if ([model.pid isEqualToString:self.cityID]) {
            [cityArr addObject:model];
        }
        _dataArr = cityArr;
    }
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
