//
//  ChooseCouponsListViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/25.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "ChooseCouponsListViewController.h"
#import "CouponsTableViewCell.h"
#import "couponModel.h"

@interface ChooseCouponsListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , assign)BOOL isCancelChoose;
@property (nonatomic , strong)NSString *header;
@end

@implementation ChooseCouponsListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = @"我的优惠券";
    _isCancelChoose = NO;
    _dataArr = [[NSMutableArray alloc]init];
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStylePlain];
    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerClass:[CouponsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tableView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
    
    [self loadData];
//    UIButton *cancelButton = [UIButton newButtonWithTitle:@"不使用优惠券" sel:@selector(cancalChooseBtnClick) target:self cornerRadius:NO];
//
//    cancelButton.frame = CGRectMake(0, kScreenH-51, kScreenW, 51);
//    [self.view addSubview:cancelButton];
}

- (void)defaultLeftBtnClick {
//    if (_isCancelChoose) {
//        if ([_delegate respondsToSelector:@selector(backCancleCoupons)]) {
//            [_delegate backCancleCoupons];
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    
    if (_isNew) {
        [VFHttpRequest couponAvailableListParameter:@{@"money":_money} successBlock:^(NSDictionary *data) {
            VFBaseListMode *model = [[VFBaseListMode alloc]initWithDic:data];
            for (NSDictionary *dic in model.data) {
                chooseCouponListModel *obj = [[chooseCouponListModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            if (model.data.count == 0) {
                [_tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_Coupon"] title:@"暂无优惠券，跟客服小姐姐撩一张试试？"];
            }
            [_tableView reloadData];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];

        }];
        
    }else{
        
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        [JSFProgressHUD showHUDToView:self.view];
        [HttpManage chooseListParameter:@{@"token":token,@"money":self.money} success:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            couponModel *model = [[couponModel alloc]initWithDic:data];
            for (NSDictionary *dic in model.couponList) {
                chooseCouponListModel *obj = [[chooseCouponListModel alloc]initWithDic:dic];
                [_dataArr addObject:obj];
            }
            if (model.couponList.count == 0) {
                [_tableView showEmptyViewWithType:1 image:[UIImage imageNamed:@"image_blankpage_Coupon"] title:@"暂无优惠券，跟客服小姐姐撩一张试试？"];
            }
            [_tableView reloadData];
        } failedBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
        }];
    }
}

- (UIView *)tableHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 65+kNavTitleH)];
    headerView.backgroundColor = kWhiteColor;
    
    UILabel *topLabel = [UILabel initWithNavTitle:_header];
    topLabel.frame = CGRectMake(15, 0, kScreenW-30, kNavTitleH);
    topLabel.font = [UIFont systemFontOfSize:kNewBigTitle];
    [headerView addSubview:topLabel];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavTitleH, kScreenW, 65)];
    [headerView addSubview:bgView];
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coupon_img_background"]];
    backgroundImage.frame = CGRectMake(7, 0, kScreenW-14, 65);
    [bgView addSubview:backgroundImage];
    
    UILabel *label = [UILabel initWithTitle:@"不使用优惠券" withFont:kTextSize textColor:kdetailColor];
    label.frame = CGRectMake(23, 0, 100, 65);
    [backgroundImage addSubview:label];
    
    anyButton *chooseButton = [anyButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(0, 0, kScreenW, 65);
    [chooseButton setImage:[UIImage imageNamed:@"icon_checkbox_off"] forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton changeImageFrame:CGRectMake(kScreenW-55, (65-22)/2, 22, 22)];
    [bgView addSubview:chooseButton];
    return headerView;
}

- (void)changeValue:(UIButton *)sender{
    [sender setImage:[UIImage imageNamed:@"icon_checkbox_on"] forState:UIControlStateNormal];
    if ([_delegate respondsToSelector:@selector(backCancleCoupons)]) {
        [_delegate backCancleCoupons];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)changeValues:(UISwitch *)swith{
//    if (swith.on) {
//        _isCancelChoose = YES;
//    }else{
//        _isCancelChoose = NO;
//    }
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = kBackgroundColor;
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    
    cell.backgroundColor = kWhiteColor;
    chooseCouponListModel *list =_dataArr[indexPath.row];
    NSInteger style = [list.style integerValue];
    
    switch (style) {
        case 0:
            cell.topImage.image = [UIImage imageNamed:@"image_Coupon_Invalid"];
            break;
        case 1:
            cell.topImage.image = [UIImage imageNamed:@"image_Coupon_red"];
            break;
        case 2:
            cell.topImage.image = [UIImage imageNamed:@"image_Coupon_blue"];
            break;
        case 3:
            cell.topImage.image = [UIImage imageNamed:@"image_Coupon_yellow"];
            break;
        default:
            break;
    }
    
    if ([list.useable isEqualToString:@"0"]) {
         cell.topImage.image = [UIImage imageNamed:@"image_Coupon_Invalid"];
    }
    
    cell.bottonLabel.text = [NSString stringWithFormat:@"%@～%@",[CustomTool changTimeStr:list.startTimestamp formatter:@"yyyy/MM/dd"] ,[CustomTool changTimeStr:list.endTimestamp formatter:@"yyyy/MM/dd"]];
    cell.topLabel.text = [NSString stringWithFormat:@"¥%@",list.money];
//    cell.topLabel.textColor =kNewDetailColor;
    cell.detaillabel.text = [NSString stringWithFormat:@"满%@元可用",list.mk];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kScreenW-16)*272/722+16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    chooseCouponListModel *list =_dataArr[indexPath.row];
    if ([list.useable isEqualToString:@"0"]) {
        
    }else{
        chooseCouponListModel *model = _dataArr[indexPath.row];
        if ([_delegate respondsToSelector:@selector(chooseCouponsModel:)]) {
            [_delegate chooseCouponsModel:model];
        }
        [self.navigationController popViewControllerAnimated:YES];
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
