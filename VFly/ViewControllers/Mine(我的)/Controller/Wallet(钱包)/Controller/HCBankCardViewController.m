//
//  HCBankCardViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "HCBankCardViewController.h"
#import "MyBankCardTableViewCell.h"
#import "MyBankCardModel.h"
#import "LLAddNameAndCardIDViewController.h"

@interface HCBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)NSString *header;
@end

@implementation HCBankCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    self.header=@"我的银行卡";
    self.navTitleLabel.text = _header;
    [self createView];
    AdjustsScrollViewInsetNever(self, _tableView);
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)loadData{
    kWeakself;
    [VFHttpRequest getBankCardListSuccessBlock:^(NSDictionary *data) {
        VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
        if ([model.code intValue] == 1) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in model.data) {
                MyBankCardListModel *obj = [[MyBankCardListModel alloc]initWithDic:dic];
                [tempArr addObject:obj];
            }
            _dataArr = tempArr;
            if (_dataArr.count == 0) {
                [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_BankCard"] title:@"选择银行卡支付将自动添加"];
            }
            [self.tableView reloadData];
        }else{
            [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_BankCard"] title:@"选择银行卡支付将自动添加"];
        }
    } withFailureBlock:^(NSError *error) {
        [weakSelf.tableView showEmptyViewWithType:1 image:nil title:nil];

    }];
}

- (void)didSelectTableViewCell:(NSIndexPath *)index{
    kWeakSelf;
    if (_dataArr != 0) {
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        NSDictionary *dic =@{@"token":token,@"money":@"0.01"};
        [HttpManage rechargeParameter:dic With:^(NSDictionary *data) {
            HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
            LLAddNameAndCardIDViewController *vc = [[LLAddNameAndCardIDViewController alloc]init];
            vc.orderInfo = @"绑卡";
            vc.payType = @"7";
            vc.orderID = model.data[@"orderId"];
            vc.money = @"0.01";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } failedBlock:^{
        }];
    }else {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"已添加过银行卡"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
    }
}


- (void)createView{
    _tableView = [[BaseTableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.header = _header;
    [_tableView registerNib:[UINib nibWithNibName:@"MyBankCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
     _tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBankCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    MyBankCardListModel *obj = _dataArr[indexPath.row];
    
//    NSString *str1 = [obj.icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [cell.bankIconImage sd_setImageWithURL:[NSURL URLWithString:str1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        cell.bankIconImage.image = image;
//    }];
//    [cell.bankIconImage sd_setImageWithURL:[NSURL URLWithString:obj.icon]];
    cell.bankNameLabel.text = @"";
    cell.cardIDLabel.text = [CustomTool getNewBankNumWitOldBankNum:obj.bankCard];
    cell.cardTypeLabel.text = obj.cardType;
    cell.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:obj.backImage]];
//    cell.cardIDLabel.font = [UIFont fontWithName:@"OCRAStd" size:15];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(BankCardListSenderModel:)]) {
        MyBankCardListModel *model = _dataArr[indexPath.row];
        [_delegate BankCardListSenderModel:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    if (editingStyle==UITableViewCellEditingStyleInsert)
//    {
//        //         先在数据源里面给它添加进去数据然后再刷表
//        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        
//    }
//    else if (editingStyle==UITableViewCellEditingStyleDelete)
//    {
//    }
//}


//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        MyBankCardListModel *obj = _dataArr[indexPath.row];
//        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
//        NSDictionary *dic =@{@"id":obj.carId,@"token":token};
//        [HttpManage delBankCardParameter:dic Success:^(NSString *data) {
//            if ([data isEqualToString:@"ok"]) {
//                [self loadData];
//            }
//        } withFailedBlock:^{
//            
//        }];
//
//    }];
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        AddBankCardViewController *vc = [[AddBankCardViewController alloc]init];
//        vc.isAdd = NO;
//        vc.bankObj = _dataArr[indexPath.row];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    editAction.backgroundColor = [UIColor grayColor];
//    return @[deleteAction, editAction];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

