//
//  EditAddressViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "EditAddressViewController.h"
#import "EditAddressTableViewCell.h"
#import "AddAddressViewController.h"
#import "AddressModel.h"
#import "VFChooseAddressModel.h"

@interface EditAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)BaseTableView *tableView;

@property (nonatomic , assign)NSInteger page;
@property (nonatomic , strong)NSString *header;
@property (nonatomic , strong)NSArray *addressArr;

@end

@implementation EditAddressViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.UMPageStatistical = @"addressManager";
    if (_mineChoose) {
        _header = @"我的地址";
    }else{
        _header = @"选择地址";
    }
    self.navTitleLabel.text = _header;
    self.addressArr = [[NSArray alloc]init];
    [self createView];
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
    [self createMJRefresh];

}


- (void)addBtnAction{
    AddAddressViewController *vc =[[AddAddressViewController alloc]init];
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)loadData{
    kWeakself;
    [VFHttpRequest addressParameter:@{} successBlock:^(NSDictionary *data) {
        VFBaseListMode *obj = [[VFBaseListMode alloc]initWithDic:data];
        _addressArr = obj.data;
        if (_addressArr.count == 0) {
            [weakSelf.tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_address"] title:@"您还没有添加地址哦"];
        }else {
            [weakSelf.tableView removeEmptyView];
        }
        [_tableView reloadData];
        [self endRefresh];
        
    } withFailureBlock:^(NSError *error) {
        [weakSelf.tableView showEmptyViewWithType:0 image:nil title:nil];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)createView{
    _tableView = [[BaseTableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[EditAddressTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.header = _header;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = kBackgroundColor;
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VFChooseAddressModel *obj = [[VFChooseAddressModel alloc]initWithDic:_addressArr[indexPath.row]];
    cell.addressLabel.text = obj.address;
//    cell.defaultBtn.tag = indexPath.row;
//    if (indexPath.row == 0) {
//        cell.defaultBtn.selected = YES;
//        cell.defaultLabel.hidden = YES;
//    }
//    [cell.defaultBtn addTarget:self action:@selector(defaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//- (void)defaultBtnClick:(UIButton *)sender{
//    kWeakself;
//    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
//    AddressListModel *obj = _dataArr[sender.tag];
//    [HttpManage setAddressParameter:@{@"token":token,@"id":obj.addressID} success:^(NSDictionary *data) {
//        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
//        if ([obj.info isEqualToString:@"ok"]) {
//            [weakSelf loadData];
//            [ProgressHUD showSuccess:@"设置成功"];
//        }else{
//            [ProgressHUD showError:obj.info];
//        }
//    } failedBlock:^(NSError *error) {
//        [ProgressHUD showError:@"请求失败"];
//    }];
//}

//- (void)editBtnClick:(UIButton *)sender{
//    AddressListModel *obj = _dataArr[sender.tag];
//    AddAddressViewController *vc = [[AddAddressViewController alloc]init];
//    vc.isEdit = YES;
//    vc.model = obj;
//    //self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)deleteBtnClick:(UIButton *)sender{
//    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
//    AddressListModel *obj = _dataArr[sender.tag];
//    [HttpManage delAddressParameter:@{@"token":token,@"id":obj.addressID} success:^(NSDictionary *data) {
//        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
//        if ([obj.info isEqualToString:@"ok"]) {
//            [_dataArr removeObjectAtIndex:sender.tag];
//            [_tableView reloadData];
//        }else{
//            [ProgressHUD showError:obj.info];
//        }
//    } failedBlock:^(NSError *error) {
//        [ProgressHUD showError:@"请求失败"];
//    }];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AddressListModel *obj = _dataArr[indexPath.row];
//    if (_mineChoose) {
//        AddAddressViewController *vc = [[AddAddressViewController alloc]init];
//        vc.isEdit = YES;
//        vc.model = obj;
//        //self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        if ([_delegate respondsToSelector:@selector(rentCarChooseAddressModel:)]) {
//            [_delegate rentCarChooseAddressModel:obj];
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

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
