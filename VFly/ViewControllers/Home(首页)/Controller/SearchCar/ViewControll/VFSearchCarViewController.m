//
//  VFSearchCarViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/26.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFSearchCarViewController.h"
#import "VFSearchCarListViewController.h"

@interface VFSearchCarViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic , strong)NSArray *hotListArr;
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)UIView *tableHeaderView;
@end

@implementation VFSearchCarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    _hotListArr = [[NSArray alloc]init];
    [self createView];
    [self loadData];
}




- (UIView *)createtableHeaderView {
    if (!_tableHeaderView)
    {
        if (_hotListArr.count>0) {
            if (_hotListArr.count%3>0) {
                _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100+45*(_hotListArr.count/3+1))];
            }else{
                _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100+45*(_hotListArr.count/3))];
            }
        }else{
            _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
        }
        
        UIImageView *searchImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon_search"]];
        searchImageView.frame = CGRectMake(15, 20, 26, 26);
        [_tableHeaderView addSubview:searchImageView];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.returnKeyType = UIReturnKeySearch;
        textField.delegate = self;
        textField.frame = CGRectMake(60, 15, kScreenW-30, 40);
        textField.placeholder = @"根据品牌、型号、敞篷等搜索...";
        [textField becomeFirstResponder];
        textField.font = [UIFont systemFontOfSize:kTitleBigSize];
        [_tableHeaderView addSubview:textField];
        
        UILabel *hotLabel = [UILabel initWithTitle:@"热门搜索" withFont:kTitleBigSize textColor:HexColor(0xA8A8A8)];
        hotLabel.frame= CGRectMake(15, textField.bottom+30, kScreenW-15, kTitleBigSize);
        [_tableHeaderView addSubview:hotLabel];
        
        for (int i=0; i<_hotListArr.count; i++)
        {
            UILabel *label = [UILabel initWithTitle:_hotListArr[i] withFont:kTextBigSize textColor:kdetailColor];
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(36+i%3*((kScreenW-105)/3+15), hotLabel.bottom+15+i/3*45, (kScreenW-105)/3, 35);
            label.backgroundColor = kNewBgColor;
            [_tableHeaderView addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(36+i%3*((kScreenW-105)/3+15), hotLabel.bottom+7+i/3*45, (kScreenW-105)/3, 45);
            button.tag = i;
            [button addTarget:self action:@selector(searchButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
            [_tableHeaderView addSubview:button];
        }
    }
    return _tableHeaderView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSArray *hotSearchCar = [[NSUserDefaults standardUserDefaults]objectForKey:@"hotSearchCar"];
    NSMutableArray *mutHotSearchCar = [NSMutableArray arrayWithArray:hotSearchCar];
    if (![textField.text isEqualToString:@""]) {
        [mutHotSearchCar removeObject:textField.text];
        [mutHotSearchCar insertObject:textField.text atIndex:0];
        NSArray *tempArr = mutHotSearchCar;
        [[NSUserDefaults standardUserDefaults]setObject:tempArr forKey:@"hotSearchCar"];
        [self jumpSearchCarListCar:textField.text];
    }
    
    return YES;
}

- (void)searchButtonClcik:(UIButton *)sender {
    NSArray *hotSearchCar = [[NSUserDefaults standardUserDefaults]objectForKey:@"hotSearchCar"];
    NSMutableArray *mutHotSearchCar = [NSMutableArray arrayWithArray:hotSearchCar];
    [mutHotSearchCar removeObject:_hotListArr[sender.tag]];
    [mutHotSearchCar insertObject:_hotListArr[sender.tag] atIndex:0];
    NSArray *tempArr = mutHotSearchCar;
    [[NSUserDefaults standardUserDefaults]setObject:tempArr forKey:@"hotSearchCar"];
    [self jumpSearchCarListCar:_hotListArr[sender.tag]];
}

- (void)jumpSearchCarListCar:(NSString *)car{
    VFSearchCarListViewController *vc = [[VFSearchCarListViewController alloc]init];
    vc.carModel = car;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    titleLabel.text = @"搜索";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *hotSearchCar = [[NSUserDefaults standardUserDefaults]objectForKey:@"hotSearchCar"];
    if (hotSearchCar) {
        return hotSearchCar.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    
    UILabel *leftlabel = [UILabel initWithTitle:@"历史搜索" withFont:kTitleBigSize textColor:HexColor(0xA8A8A8)];
    leftlabel.frame = CGRectMake(15, 24, 100, 16);
    [sectionHeaderView addSubview:leftlabel];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setTitle:@"清空" forState:UIControlStateNormal];
    [clearButton setTitleColor:HexColor(0xA8A8A8) forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:kTextSize];
    clearButton.frame = CGRectMake(kScreenW-80, 0, 80, 64);
    [clearButton addTarget:self action:@selector(clearButtonClcik) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:clearButton];
    
    return sectionHeaderView;
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
    NSArray *hotSearchCar = [[NSUserDefaults standardUserDefaults]objectForKey:@"hotSearchCar"];
    NSMutableArray *mutHotSearchCar = [NSMutableArray arrayWithArray:hotSearchCar];
    [mutHotSearchCar removeObject:hotSearchCar[indexPath.row]];
    [mutHotSearchCar insertObject:hotSearchCar[indexPath.row] atIndex:0];
    NSArray *tempArr = mutHotSearchCar;
    [[NSUserDefaults standardUserDefaults]setObject:tempArr forKey:@"hotSearchCar"];
    [self jumpSearchCarListCar:hotSearchCar[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *hotSearchCar = [[NSUserDefaults standardUserDefaults]objectForKey:@"hotSearchCar"];
    cell.textLabel.text = hotSearchCar[indexPath.row];
    return cell;
}


- (void)loadData{
    [VFHttpRequest hotVocabularyParameter:@{@"limit":@"6"} successBlock:^(NSDictionary *data) {
        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        if ([model.code intValue] == 1) {
            _hotListArr = model.data;
            self.tableView.tableHeaderView = [self createtableHeaderView];
            [self.tableView reloadData];
        }
    } withFailureBlock:^(NSError *error) {
        [ProgressHUD showError:@"加载失败"];

    }];
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
