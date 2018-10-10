//
//  VFUseCarUserViewController.m
//  VFly
//
//  Created by Hcar on 2018/4/12.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFUseCarUserViewController.h"
#import "VFUseCarUserTableViewCell.h"
#import "VFUseCarUseeListModel.h"
#import "VFAddUseCarUserViewController.h"
#import "VFIdentityAuthenticationViewController.h"
#import "WebViewVC.h"

@interface VFUseCarUserViewController ()<UITableViewDelegate,UITableViewDataSource,VFUseCarUserListCellDelegate>
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)BaseTableView *tabeleView;

@end

@implementation VFUseCarUserViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSArray alloc]init];
    [self createView];
    self.navTitleLabel.text = @"用车人";
}

- (void)loadData{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [VFHttpRequest usePeopleParameter:@{@"token":token} successBlock:^(NSDictionary *data) {
        NSLog(@"________________%@",data);
        
        VFBaseListMode *obj = [[VFBaseListMode alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in obj.data) {
            VFUseCarUseeListModel *model = [[VFUseCarUseeListModel alloc]initWithDic:dic];
            [tempArr addObject:model];
        }
        _dataArr = tempArr;
        [_tabeleView reloadData];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)createView{
    _tabeleView = [[BaseTableView alloc]init];
    _tabeleView.delegate = self;
    _tabeleView.dataSource = self;
    _tabeleView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tabeleView];

    [_tabeleView registerClass:[VFUseCarUserTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [_tabeleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFUseCarUseeListModel *model = _dataArr[indexPath.row];
    VFUseCarUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenW);
    if (cell == nil)
    {
        cell = [[VFUseCarUserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCell"];
    }
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = model;
    return cell;
}

- (void)VFUseCarUserListCellClick:(NSInteger)tag model:(VFUseCarUseeListModel *)model{
    if (tag == 0) {
        if ([model.card_face isEqualToString:@""] || [model.driving_licence isEqualToString:@""]) {
            VFIdentityAuthenticationViewController *vc = [[VFIdentityAuthenticationViewController alloc]init];
            vc.userID = model.useman_id;
            if ([model.card_face isEqualToString:@""]) {
                vc.card_status = @"0";
            }else{
                vc.card_status = @"1";
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        WebViewVC *vc = [[WebViewVC alloc]init];
        vc.urlStr = kFormat(@"https://wechat.weifengchuxing.com/forApp/noDeposit_v2/noDeposit.html?useman_id=%@&token=",model.useman_id);
        vc.needToken = YES;
        vc.noNav = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
