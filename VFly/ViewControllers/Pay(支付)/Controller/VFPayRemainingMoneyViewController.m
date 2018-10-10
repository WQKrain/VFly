//
//  VFPayRemainingMoneyViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFPayRemainingMoneyViewController.h"
#import "OrderDetailModel.h"
#import "VFChoosePayViewController.h"
#import "VFPayRemainingMoneyTableViewCell.h"
#import "VFBreaksTheDepositOrderDetailModel.h"
#import "VFPayRemainingMoneyModel.h"
#import "VFOldChoosePayViewController.h"

@interface VFPayRemainingMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
    {
        dispatch_group_t _groupEnter;
    }
@property (nonatomic , strong)OrderDetailModel* orderDetailModel;

@property (nonatomic , strong)NSArray *moneyStatePay;

@property (nonatomic , strong)BaseTableView *tabelView;
@property (nonatomic , strong)NSArray *leftArr;
@property (nonatomic , strong)NSArray *rightArr;

@property (nonatomic , strong)NSArray *stateArr;

@property (nonatomic , assign)NSInteger selectIndex;

@property (nonatomic , strong)VFBreaksTheDepositOrderDetailStateModel *breakDepositModel;
@property (nonatomic , strong)VFBreaksTheDepositOrderDetailModel *breakOrderModel;

@property (nonatomic , strong)NSArray *dataArr;

@end

@implementation VFPayRemainingMoneyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAllData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"支付尾款";
    _dataArr = [[NSArray alloc]init];
    _leftArr = @[@"免押金服务费",@"租金尾款(包含服务费)",@"车辆押金",@"违章保证金"];
    if (_isNew) {
        _selectIndex = 0;
    }else{
        _selectIndex = 10;
    }
    [self createTableView];
}

- (void)loadAllData{
    if (_isNew) {
        [VFHttpRequest getOrderShouldPayParameter:@{@"order_id":_orderID} successBlock:^(NSDictionary *data) {
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            if ([model.code isEqualToString:@"1"]) {
                VFPayRemainingMoneyModel *obj = [[VFPayRemainingMoneyModel alloc]initWithDic:model.data];
                NSMutableArray *tempArr = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in obj.lists) {
                    VFPayRemainingMoneyListModel *listModel = [[VFPayRemainingMoneyListModel alloc]initWithDic:dic];
                    [tempArr addObject:listModel];
                }
                _dataArr = tempArr;
                [_tabelView reloadData];
            }
        } withFailureBlock:^(NSError *error) {
            
        }];
        
    }else{
        dispatch_queue_t queueEnter = dispatch_get_global_queue(0, 0);
        dispatch_async(queueEnter, ^{
            _groupEnter = dispatch_group_create();
            dispatch_group_async(_groupEnter, queueEnter, ^{
                //            [self loadBreaksTheDeposit];
            });
            //在请求中加入了dispatch_group_enter和dispatch_group_leave时,就可以放心使用AFN进行请求了.可以拿到前几个请求完成之后的参数再进行最后一个请求
            dispatch_group_notify(_groupEnter, queueEnter, ^{
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [self loadData];
                }];
            });
        });
    }
}

- (void)createTableView{
    _tabelView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kOldNavBarH, kScreenW, kScreenH-kOldNavBarH)];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    [_tabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    _tabelView.tableFooterView = [self createTableFooterView];
//    _tabelView.tableHeaderView = [self createTableHeaderView];
    [_tabelView registerClass:[VFPayRemainingMoneyTableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isNew) {
        return _dataArr.count;
    }else{
        return _leftArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isNew) {
        return 64;
    }else{
        if ([_rightArr[indexPath.row] floatValue]>0) {
            if (indexPath.row == 0) {
                return 0;
            }
            
            if (indexPath.row == 2) {
                return 64;
            }
        }else{
            return 0;
        }
    }
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFPayRemainingMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell = [[VFPayRemainingMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    if (_selectIndex == indexPath.row) {
        cell.chooseImage.image = [UIImage imageNamed:@"icon_checkbox_on"];
    }else{
        cell.chooseImage.image = [UIImage imageNamed:@"icon_checkbox_off"];
    }
    
    
    if (_isNew) {
        VFPayRemainingMoneyListModel *listModel = _dataArr[indexPath.row];
        if ([listModel.unpay intValue]>0) {
            cell.leftlabel.text =kFormat(@"%@  已支付¥%d",listModel.item , [listModel.should_pay intValue] - [listModel.unpay intValue]);
        }else{
            cell.leftlabel.text =kFormat(@"%@  已支付", listModel.item);
        }
        
        if ([listModel.should_pay intValue] == [listModel.unpay intValue]) {
            cell.leftlabel.text =kFormat(@"%@", listModel.item);
        }
        
        cell.rightlabel.text = kFormat(@"¥%@", listModel.unpay);
        
        NSRange range = [cell.leftlabel.text rangeOfString:listModel.item];
        [CustomTool setTextColor:cell.leftlabel FontNumber:[UIFont systemFontOfSize:kTextSize] AndRange:range AndColor:kdetailColor];
        
    }else{
        
        if ([_stateArr[indexPath.row] isEqualToString:@"2"]) {
            cell.leftlabel.text =kFormat(@"%@  已支付", _leftArr[indexPath.row]);
        }else{
            if ([_moneyStatePay[indexPath.row] floatValue]>0) {
                cell.leftlabel.text =kFormat(@"%@  已支付¥%@", _leftArr[indexPath.row],_moneyStatePay[indexPath.row]);
            }else{
                cell.leftlabel.text =kFormat(@"%@", _leftArr[indexPath.row]);
            }
        }
        
        if (indexPath.row == 1) {
            NSString *contentStr = @"可通过信用评估调整押金";
            NSRange range = [cell.leftlabel.text rangeOfString:contentStr];
            [CustomTool setTextColor:cell.leftlabel FontNumber:[UIFont systemFontOfSize:kTextSmallSize] AndRange:range AndColor:kTextBlueColor];
        }
        
        
        if ([_rightArr[indexPath.row] floatValue]>0) {
            if (indexPath.row == 0) {
                cell.hidden = YES;
            }
            
            if (indexPath.row == 2) {
                cell.hidden = NO;
            }
        }else{
            cell.hidden = YES;
        }
        
        
        cell.rightlabel.text = _rightArr[indexPath.row];
        
        NSRange range = [cell.leftlabel.text rangeOfString:_leftArr[indexPath.row]];
        [CustomTool setTextColor:cell.leftlabel FontNumber:[UIFont systemFontOfSize:kTextSize] AndRange:range AndColor:kdetailColor];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _selectIndex = indexPath.row;
    [_tabelView reloadData];
}

- (void)loadData{
    [HttpManage getOrderMessageWithOrderID:self.orderID With:^(NSDictionary *dic) {
        [JSFProgressHUD hiddenHUD:self.view];
        _orderDetailModel = [[OrderDetailModel alloc]initWithDic:dic];
        _moneyStatePay = @[@"",kFormat(@"%.2f", [_orderDetailModel.rentalMoney floatValue]-[_orderDetailModel.unpaidRentalMoney floatValue]),kFormat(@"%.2f", [_orderDetailModel.depositMoney floatValue]-[_orderDetailModel.unpaidDepositMoney floatValue]),kFormat(@"%.2f", [_orderDetailModel.illegalMoney floatValue]-[_orderDetailModel.unpaidIllegalMoney floatValue]),@""];
        
        if ([_orderDetailModel.is_free_deposit isEqualToString:@"0"]) {
            _leftArr = @[@"免押金服务费",@"租金尾款",@"车辆押金",@"违章保证金"];
        }else{
            _leftArr = @[@"免押金服务费",@"租金余款(包含服务费)",@"车辆押金",@"违章保证金"];
        }
        
        _stateArr  = @[@"",_orderDetailModel.rentalMoneyStatus,_orderDetailModel.depositMoneyStatus,_orderDetailModel.illegalMoneyStatus,_orderDetailModel.totalMoneyStatus];
        
        
        _rightArr = @[_breakDepositModel.service_fee?_breakDepositModel.service_fee:@"",_orderDetailModel.unpaidRentalMoney,_orderDetailModel.unpaidDepositMoney,_orderDetailModel.unpaidIllegalMoney,_orderDetailModel.unpaid];
         [_tabelView reloadData];
    }];
}

- (void)loadBreaksTheDeposit{
    dispatch_group_enter(_groupEnter);
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpManage depositBreaksOrderDetailWithParameter:@{@"token":token,@"order_id":self.orderID} withSuccessBlock:^(NSDictionary *data) {
        _breakOrderModel = [[VFBreaksTheDepositOrderDetailModel alloc]initWithDic:data];
        _breakDepositModel = [[VFBreaksTheDepositOrderDetailStateModel alloc]initWithDic:_breakOrderModel.free_deposit];
        _rightArr = @[kFormat(@"¥%@", _breakDepositModel.service_fee),kFormat(@"¥%@", _orderDetailModel.unpaidRentalMoney),kFormat(@"¥%@", _orderDetailModel.unpaidDepositMoney),kFormat(@"¥%@", _orderDetailModel.unpaidIllegalMoney),kFormat(@"¥%@", _orderDetailModel.unpaid)];
         dispatch_group_leave(_groupEnter);
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (UIView *)createTableHeaderView{
    UIView *headerViwe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    UILabel *label = [UILabel initWithTitle:@"您可以选择单项依次支付，也可以选择一次性支付" withFont:kTextSize textColor:kdetailColor];
    label.frame =CGRectMake(15, 0, kScreenW-30, 44);
    [headerViwe addSubview:label];
    return headerViwe;
}

- (UIView *)createTableFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 74)];
    UIButton *paybutton = [UIButton newButtonWithTitle:@"去支付"  sel:@selector(payButtonClcik) target:self cornerRadius:YES];
    paybutton.frame = CGRectMake((kScreenW-165)/2, 15, 165, 44);
    [footerView addSubview:paybutton];
    return footerView;
}

- (void)payButtonClcik{
    if (_isNew) {
        VFChoosePayViewController *vc = [[VFChoosePayViewController alloc]init];
        VFPayRemainingMoneyListModel *listModel = _dataArr[_selectIndex];
        vc.orderID = self.orderID;
        vc.moneyType = listModel.should_pay_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        if (_selectIndex != 10) {
            if (_selectIndex == 0) {
                if (_breakOrderModel.free_deposit) {
                    if (_breakDepositModel.sign_bankcard) {
                        if ([_breakDepositModel.service_fee_status isEqualToString:@"0"]) {
                            VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
                            vc.orderID = self.orderID;
                            vc.moneyType = @"11";
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }else{
                        //此处做操作
                    }
                }
            }else{
                VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
                if (_selectIndex == 2) {
                    float deposit = [_orderDetailModel.depositMoney floatValue]-[_orderDetailModel.unpaidDepositMoney floatValue];
                    if (deposit>0 || [_breakOrderModel.open_free_deposit isEqualToString:@"0"]) {
                        vc.depositPay = @"YES";
                    }
                }
                vc.orderID = self.orderID;
                vc.moneyType = kFormat(@"%zi", _selectIndex+1);
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [CustomTool alertViewShow:@"请选择支付款项"];
        }
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
