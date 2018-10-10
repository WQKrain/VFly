//
//  VFServiceViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2018/1/24.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFServiceViewController.h"
#import "VFCallTableViewCell.h"
#import "VFCallModel.h"
#import "ProblemViewController.h"
#import "TableViewAnimationKitHeaders.h"

@interface VFServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@property(nonatomic , strong)NSMutableArray *dataArr;
@end

@implementation VFServiceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self starAnimationWithTableView:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    [self loadData];
    [self customTableView];
    UIImage *image = [UIImage imageNamed:@"icon_server-questions"];
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [self.rightButton setImage:image forState:UIControlStateNormal];
    self.header = @"拨打电话";
    self.navTitleLabel.text = _header;
    self.tableView.header = _header;
    self.leftButton.hidden = YES;
    self.tableView.tableFooterView = [self createFooterView];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 70, 0, 0)];
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options: HYHidenControlOptionLeft |HYHidenControlOptionTitle];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onlineServiceClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"button_service_online"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(127);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-kTabBarHeght-22);
    }];
}

- (void)onlineServiceClick{
    kWeakSelf;
    if([HChatClient sharedClient].isLoggedInBefore)
    {
        HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else
    {
        //未登录
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kHXUsernameAndPsw];
        if (dic)
        {
            VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:dic];
            HChatClient *client = [HChatClient sharedClient];
            [client loginWithUsername:model.username password:model.password];
        }
        else
        {
            [HttpManage getHxUserSuccessBlock:^(NSDictionary *data) {
                VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:data];
                [[NSUserDefaults standardUserDefaults]setObject:@{@"activated":model.activated,@"created":model.created,@"modified":model.modified,@"password":model.password,@"type":model.type,@"username":model.username,@"uuid":model.uuid} forKey:kHXUsernameAndPsw];
                HChatClient *client = [HChatClient sharedClient];
                HError *error = [client loginWithUsername:model.username password:model.password];
                if (!error)
                { //登录成功
                    HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
                    [weakSelf.navigationController pushViewController:chatVC animated:YES];
                } else { //登录失败
                    return;
                }
            } withFailureBlock:^(NSError *error) {

            }];
        }
    }
}

- (void)loadData{
    kWeakSelf;
    [HttpManage getStoresSuccessBlock:^(NSDictionary *data) {
        NSLog(@">>>>>>>>%@",data);
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        if ([model.info isEqualToString:@"ok"]) {
            for (NSDictionary *dic in model.data) {
                VFCallModel *obj = [[VFCallModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
                [_tableView reloadData];
                [weakSelf starAnimationWithTableView:_tableView];
            }
        }
    } withFailureBlock:^(NSError *error) {

    }];
}

- (void)customTableView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.header = _header;
    [_tableView registerClass:[VFCallTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (void)defaultRightBtnClick{
    ProblemViewController *vc = [[ProblemViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArr.count == 0) {
        return 0;
    }else{
        return _dataArr.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = [NSString stringWithFormat:@"CellIdentifier%zd%zd", indexPath.section, indexPath.row];
    VFCallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[VFCallTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.indexRow = @"0";
    }else{
        VFCallModel *model = _dataArr[indexPath.row-1];
        [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        cell.topLabel.text = model.name;
        cell.bottomLabel.text = model.address;
    }
    return cell;
}

- (UIView *)createFooterView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 57)];
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = kHomeLineColor;
    [footView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33);
        make.left.mas_equalTo((kScreenW-223)/2);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *label = [UILabel initWithTitle:@"更多门店，敬请期待" withFont:kTextSize textColor:kNewDetailColor];
    [footView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.equalTo(leftLine.mas_right).offset(9);
        make.height.mas_equalTo(17);
    }];
    
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = kHomeLineColor;
    [footView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33);
        make.left.mas_equalTo(label.mas_right).offset(10);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(1);
    }];
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
        GlobalConfigModel *obj = [[GlobalConfigModel alloc]initWithDic:dic];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",obj.customerServiceTel]]];
    }else{
        VFCallModel *model = _dataArr[indexPath.row-1];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.tel]]];
    }
}

- (void)starAnimationWithTableView:(UITableView *)tableView {
    [TableViewAnimationKit showWithAnimationType:2 tableView:tableView];
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
