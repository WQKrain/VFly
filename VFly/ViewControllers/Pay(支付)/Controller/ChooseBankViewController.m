//
//  ChooseBankViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/8/28.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ChooseBankViewController.h"
#import "ShowBankTableViewCell.h"
#import "MyBankCardModel.h"
#import "showBankModel.h"
#import "LLAddNameAndCardIDViewController.h"
#import "VFAddBankCardViewController.h"

@interface ChooseBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)BaseTableView *tableView;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)NSString *header;
@end

@implementation ChooseBankViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"选择银行";
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.header = _header;
    [_tableView registerClass:[ShowBankTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [self loaddata];
    
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)loaddata{
    
    if (_isNew) {
        [VFHttpRequest getBankLimitListSuccessBlock:^(NSDictionary *data) {
            VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
            if ([model.code intValue] == 1) {
                NSMutableArray *tempArr = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in model.data) {
                    showBankListModel *obj = [[showBankListModel alloc]initWithDic:dic];
                    [tempArr addObject:obj];
                }
                _dataArr =tempArr;
                [_tableView reloadData];
            }
        } withFailureBlock:^(NSError *error) {

        }];
    }else{
        [HttpManage bankLimitListSuccess:^(NSDictionary *data) {
            showBankModel *model = [[showBankModel alloc]initWithDic:data];
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in model.list) {
                showBankListModel *obj = [[showBankListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            _dataArr =tempArr;
            [_tableView reloadData];
        } failedBlock:^(NSError *error) {
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowBankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    
    showBankListModel *model = _dataArr[indexPath.row];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    //    NSString *str1 = [model.icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:str1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        cell.leftImage.image = image;
    //    }];
    cell.topLabel.text = model.bank;
    cell.detaillabel.text = model.brief;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //连连支付
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VFAddBankCardViewController *vc = [[VFAddBankCardViewController alloc]init];
    //self.hidesBottomBarWhenPushed = YES;
    vc.orderInfo = self.orderInfo;
    vc.payType = self.payType;
    vc.orderID = self.orderID;
    vc.money = self.money;
    vc.couponId = _couponId;
    vc.score = _score;
    vc.handler = _handler;
    vc.isNew = _isNew;
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    LLAddNameAndCardIDViewController *vc = [[LLAddNameAndCardIDViewController alloc]init];
//    vc.orderInfo = self.orderInfo;
//    vc.payType = self.payType;
//    vc.orderID = self.orderInfo;
//    vc.money = self.money;
//    [self.navigationController pushViewController:vc animated:YES];
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
