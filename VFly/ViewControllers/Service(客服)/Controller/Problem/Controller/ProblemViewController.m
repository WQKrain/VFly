//
//  ProblemViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/9.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ProblemViewController.h"
#import "VFProblmModel.h"
#import "VFProbleDetailViewController.h"

@interface ProblemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSString *header;
@end

@implementation ProblemViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"question";
    self.header = @"常见问题";
    _dataArr = [[NSMutableArray alloc]init];
    self.leftButton.hidden = NO;
    [self loadData];
    [self createView];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(defaultLeftBtnClick)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"画板 19"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)defaultLeftBtnClick {
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.header = _header;
    _tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
     _tableView.tableFooterView = [[UIView alloc]init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VFProbleDetailViewController *vc = [[VFProbleDetailViewController alloc]init];
    VFProblmTitleModel *obj =_dataArr[indexPath.row];
    vc.name = obj.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    VFProblmTitleModel *obj =_dataArr[indexPath.row];
    cell.textLabel.text = obj.name;
    return cell;
}

- (void)loadData{
    [HttpManage getQuestionJsonDataSuccessBlock:^(NSDictionary *data) {
        VFProblmModel *model = [[VFProblmModel alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.data) {
            VFProblmTitleModel *obj = [[VFProblmTitleModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        [_tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        
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
