//
//  VFMyCouponViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFMyCouponViewController.h"
#import "CouponsTableViewCell.h"
#import "VFMyCouponCell.h"
#import "couponModel.h"

@interface VFMyCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *inTimeArray;
@property (nonatomic, strong) NSMutableArray *outTimeArray;

@end

@implementation VFMyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexColor(0xFAFAFA);
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self loadInTimeData];
    [self createView];
 
    [self setNav];
}

- (void)setNav {
    
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
    titleLabel.text = @"我的优惠券";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)endRefreshTableView:(UITableView *)tableView{
    [tableView.mj_footer endRefreshing];
    [tableView.mj_header endRefreshing];
}

- (void)beginRefershTableView:(UITableView *)tableView{
    [tableView.mj_header beginRefreshing];
}

- (void)loadInTimeData{
    kWeakSelf;
    [VFHttpRequest couponListParameter:@{@"type":@"1"} successBlock:^(NSDictionary *data) {
        NSLog(@">>>>>>>>>>>%@",data);
        [self loadOutTimeData];
        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        if (model.data.count == 0)
        {
        }
        else
        {
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in model.data) {
                newCouponListModel *obj = [[newCouponListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            self.inTimeArray = tempArr;
        }
//        [weakSelf.tableView reloadData];
//        [weakSelf endRefreshTableView:_tableView];
    } withFailureBlock:^(NSError *error) {
        [weakSelf endRefreshTableView:_tableView];
        [ProgressHUD showError:@"加载失败"];
    }];
}

- (void)loadOutTimeData{
    kWeakSelf;
    [VFHttpRequest couponListParameter:@{@"type":@"0"} successBlock:^(NSDictionary *data) {        
        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        if (model.data.count == 0)
        {
        }
        else
        {
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in model.data)
            {
                newCouponListModel *obj = [[newCouponListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            self.outTimeArray = tempArr;
        }
        [weakSelf.tableView reloadData];
        [weakSelf endRefreshTableView:_tableView];
    } withFailureBlock:^(NSError *error) {
        [weakSelf endRefreshTableView:_tableView];
        [ProgressHUD showError:@"加载失败"];
    }];
}


- (void)createView{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[VFMyCouponCell class] forCellReuseIdentifier:@"VFMyCouponCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadInTimeData];
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return self.inTimeArray.count;
    }
    else if(section == 1)
    {
        return self.outTimeArray.count;
    }
    else
    {
        return 0;
    }
//    return self.inTimeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120 + 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        VFMyCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyCouponCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyCouponCell"];
        }
        newCouponListModel *list =self.inTimeArray[indexPath.row];
        
        cell.couponLabel.text = [NSString stringWithFormat:@"%@",list.text];
        cell.mkLabel.text = [NSString stringWithFormat:@"满%@元可用",list.mk];
        cell.timeLabel.text = [NSString stringWithFormat:@"有效期至：%@",[CustomTool changYearStr:list.endTime]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",list.money];
        cell.isOutTimeLabel.text = @"立即使用";

        return cell;
        
    }
    else if (indexPath.section == 1)
    {
        VFMyCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyCouponCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyCouponCell"];
        }
        newCouponListModel *list =self.outTimeArray[indexPath.row];
        
        cell.couponLabel.text = [NSString stringWithFormat:@"%@",list.text];
        cell.couponLabel.textColor = HexColor(0xA8A8A8);
        cell.mkLabel.text = [NSString stringWithFormat:@"满%@元可用",list.mk];
        cell.mkLabel.textColor = HexColor(0xA8A8A8);
        cell.timeLabel.text = [NSString stringWithFormat:@"有效期至：%@",[CustomTool changYearStr:list.endTime]];
        cell.timeLabel.textColor = HexColor(0xA8A8A8);
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",list.money];
        cell.priceLabel.textColor = HexColor(0xA8A8A8);
        cell.isOutTimeLabel.text = @"立即使用";
        cell.isOutTimeLabel.textColor = HexColor(0xA8A8A8);

        return cell;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNotification *notification =[NSNotification notificationWithName:@"jumpRent" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}







#pragma mark - lazyLoad
- (NSMutableArray *)inTimeArray {
    if (!_inTimeArray)
    {
        _inTimeArray = [NSMutableArray array];
    }
    return _inTimeArray;
}

- (NSMutableArray *)outTimeArray {
    if (!_outTimeArray)
    {
        _outTimeArray = [NSMutableArray array];
    }
    return _outTimeArray;
}




@end
