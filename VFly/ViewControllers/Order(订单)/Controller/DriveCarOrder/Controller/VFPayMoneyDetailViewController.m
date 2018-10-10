//
//  VFPayMoneyDetailViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/21.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFPayMoneyDetailViewController.h"
#import "VForderMoneyDetailModel.h"


@interface VFPayMoneyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)NSArray *detailArr;
@property (nonatomic , strong)NSString *header;
@end

@implementation VFPayMoneyDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"付款明细";
    
    NSString *freeMoney = _freeDeposit?@"预估租金总额(包含服务费)":@"预估租金总额";
    
    if ([_type isEqualToString:@"1"]) {
        NSString *deposit = _freeDeposit?@"押金":@"车辆预估押金";
        NSString *depositMoney = _freeDeposit?kFormat(@"¥%d", [self.model.depositMoney intValue]):self.model.depositMoney;
        
        _dataArr = @[freeMoney,@"需要支付订金(可抵租金)",deposit,@"违章保证金(无违章即退回)",@"会员折扣"];
        
        _detailArr = @[kFormat(@"¥%ld", (long)[self.model.rentalMoney intValue]+(long)[self.model.frontMoney intValue]),kFormat(@"¥%@", self.model.frontMoney),depositMoney,kFormat(@"¥%@", self.model.illegalMoney),kFormat(@"-¥%@", self.model.vipDiscount)];
        
    }else if ([_type isEqualToString:@"3"]){
        _dataArr = @[freeMoney,@"会员折扣"];
        _detailArr = @[kFormat(@"¥%@", self.allRentMoney),kFormat(@"-¥%@",self.vipZK)];
    }else if ([_type isEqualToString:@"2"]){
        _dataArr = @[freeMoney,@"会员折扣"];
        _detailArr = @[kFormat(@"¥%@", self.allRentMoney),kFormat(@"-¥%@", self.vipZK)];
    }
    
    self.view.backgroundColor = kWhiteColor;
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH-49) style:UITableViewStylePlain];
    _tableView.header = _header;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 84)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    lineView.backgroundColor = klineColor;
    [footView addSubview:lineView];
    UILabel *label = [UILabel initWithTitle:kFormat(@"总租金 ¥%ld", (long)[self.model.rentalMoney intValue]+(long)[self.model.frontMoney intValue]) withFont:kNewTitle textColor:kdetailColor];
    label.frame = CGRectMake(15, 0, kScreenW-15, 84);
    [footView addSubview:label];
    self.tableView.tableFooterView = footView;
    
    if ([_type isEqualToString:@"1"]) {
        label.text = kFormat(@"总租金 ¥%ld", (long)[self.model.rentalMoney intValue]+(long)[self.model.frontMoney intValue]);
    }else if ([_type isEqualToString:@"3"]){
        label.text = kFormat(@"总租金 ¥%@",_rentMoney);
    }else if ([_type isEqualToString:@"2"]){
        label.text = kFormat(@"总租金 ¥%@",_rentMoney);
    }
    
    UIButton *button = [UIButton newButtonWithTitle:@"知道了"  sel:@selector(popToVC) target:self cornerRadius:NO];
    button.frame = CGRectMake(0, kScreenH-49-kSafeBottomH, kScreenW, 49);
    [self.view addSubview:button];
}

- (void)popToVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        if ([self.model.depositMoney intValue]>0) {
            return 64;
        }else{
            return 0;
        }
    }
    
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = kWhiteColor;
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
              @"cell"];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    cell.textLabel.textColor = kdetailColor;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    cell.detailTextLabel.text = _detailArr[indexPath.row];
    if (![_type isEqualToString:@"2"]) {
        if (indexPath.row == _dataArr.count-2 || indexPath.row == _dataArr.count-1) {
            cell.detailTextLabel.textColor = kMainColor;
        }
    }else{
        if (indexPath.row == _dataArr.count-1) {
            cell.detailTextLabel.textColor = kMainColor;
        }
    }
    
    if (indexPath.row == 2) {
        if ([self.model.depositMoney intValue]>0) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
