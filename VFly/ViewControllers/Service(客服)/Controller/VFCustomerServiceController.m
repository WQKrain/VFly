//
//  VFCustomerServiceController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCustomerServiceController.h"
//#import "VFCallTableViewCell.h"
#import "VFCustomerServiceCell.h"
#import "VFCallModel.h"
#import "ProblemViewController.h"
#import "TableViewAnimationKitHeaders.h"
#import <SafariServices/SafariServices.h>


@interface VFCustomerServiceController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation VFCustomerServiceController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self starAnimationWithTableView:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    [self loadData];
    [self customTableView];

    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
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
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabBarH) style:UITableViewStylePlain];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[VFCustomerServiceCell class] forCellReuseIdentifier:@"VFCustomerServiceCell"];
    [self.view addSubview:_tableView];
}

- (void)defaultRightBtnClick{
    ProblemViewController *vc = [[ProblemViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFCallTableViewCell"];
    if (cell == nil)
    {
        cell = [[VFCustomerServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VFCustomerServiceCell"];
    }
    VFCallModel *model = _dataArr[indexPath.row];

    cell.topLabel.text = model.name;
    cell.bottomLabel.text = model.address;
    return cell;
}

- (UIView *)headerView {
    if (!_headerView)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSpaceH(250))];
        _headerView.backgroundColor = [UIColor blackColor];
        
        UIImageView *topBackgroundImageView = [[UIImageView alloc]init];
        topBackgroundImageView.image = [UIImage imageNamed:@"service_image_top"];
        topBackgroundImageView.frame = CGRectMake(0, 0, kScreenW, kSpaceH(180));
        topBackgroundImageView.userInteractionEnabled = YES;
        [_headerView addSubview:topBackgroundImageView];
        
        
       
        
        
        
        
        
        
        //--------------------
        UIView *backgroundBottomView = [[UIView alloc]init];
        backgroundBottomView.frame = CGRectMake(0, kSpaceH(180), kScreenW, kSpaceH(70));
        backgroundBottomView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:backgroundBottomView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backgroundBottomView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(16,16)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = backgroundBottomView.bounds;
        maskLayer.path = maskPath.CGPath;
        backgroundBottomView.layer.mask = maskLayer;
        
        UILabel *bottomTitleLabel = [[UILabel alloc]init];
        bottomTitleLabel.frame = CGRectMake(10, 10, kScreenW - 20, 30);
        bottomTitleLabel.backgroundColor = [UIColor whiteColor];
        bottomTitleLabel.text = @"全国门店热线";
        bottomTitleLabel.font = [UIFont systemFontOfSize:16];
        bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
        [backgroundBottomView addSubview:bottomTitleLabel];
        
        
    }
    return _headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.baidu.com"]];
    if (@available(iOS 9.0, *)) {
        SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:safariVc animated:YES completion:nil];

    } else {
        // Fallback on earlier versions
    }


    
    
//    VFCallModel *model = _dataArr[indexPath.row];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.tel]]];

}

- (void)starAnimationWithTableView:(UITableView *)tableView {
    [TableViewAnimationKit showWithAnimationType:2 tableView:tableView];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr)
    {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
