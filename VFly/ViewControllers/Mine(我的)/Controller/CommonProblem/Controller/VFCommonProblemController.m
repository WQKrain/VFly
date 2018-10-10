//
//  VFCommonProblemController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCommonProblemController.h"
#import "VFCommonProblemModel.h"
#import "VFCommonProblemCell.h"
#import "VFProbleDetailViewController.h"
#import "VFCommonProblemDetailController.h"

@interface VFCommonProblemController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)BaseTableView *tableView;

@end

@implementation VFCommonProblemController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    [self setupNav];
    [self loadData];
    [self setupView];
    
}


- (void)setupNav {
    
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
    titleLabel.text = @"常见问题";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    [HttpManage getQuestionJsonDataSuccessBlock:^(NSDictionary *data) {
        VFCommonProblemModel *model = [[VFCommonProblemModel alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.data) {
            VFCommonProblmTitleModel *obj = [[VFCommonProblmTitleModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        [_tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)setupView {
    
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[VFCommonProblemCell class] forCellReuseIdentifier:@"cell"];
    
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VFCommonProblemDetailController *vc = [[VFCommonProblemDetailController alloc]init];
    VFCommonProblmTitleModel *obj =_dataArr[indexPath.row];
    vc.name = obj.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFCommonProblemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[VFCommonProblemCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    VFCommonProblmTitleModel *obj =_dataArr[indexPath.row];
    cell.titleLabel.text = obj.name;
    return cell;
}









- (NSMutableArray *)dataArr {
    if (!_dataArr)
    {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}





@end
