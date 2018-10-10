//
//  MyPhoneViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/3.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MyPhoneViewController.h"

@interface MyPhoneViewController ()
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)NSArray *detailArr;
@property (nonatomic , strong)NSArray *imageArr;
@property (nonatomic , strong)UITextField *textField;
@property (nonatomic , strong)GlobalConfigModel *obj;
@end

@implementation MyPhoneViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navSandow = YES;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
    _obj = [[GlobalConfigModel alloc]initWithDic:dic];
    self.centerBlodTitle = @"修改注册手机号请联系客服";
    self.view.backgroundColor = kWhiteColor;
    [self createView];
}

- (void)createView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 182, kScreenW, 50)];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    UILabel *leftLabel = [UILabel initWithTitle:@"手机号" withFont:kTitleBigSize textColor:kdetailColor];
    [self.view addSubview:leftLabel];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kNavBarH+82);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *rightLabel = [UILabel initWithTitle:self.message withFont:kTitleBigSize textColor:kdetailColor];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:rightLabel];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(kNavBarH+82);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(22);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = klineColor;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW-30);
        make.top.equalTo(leftLabel.mas_bottom).offset(21);
        make.height.mas_equalTo(1);
    }];
    
    anyButton *button = [anyButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [button setImage:[UIImage imageNamed:@"icon_call"] forState:UIControlStateNormal];
    [button setTitle:@"400-117-8880" forState:UIControlStateNormal];
    [button changeImageFrame:CGRectMake((kScreenW-30-132)/2, 11, 22, 22)];
    [button changeTitleFrame:CGRectMake((kScreenW-30-132)/2+22, 11, 110, 22)];
    [button setBackgroundColor:kMainColor];
    [button addTarget:self action:@selector(callServiceTel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW-30);
        make.top.equalTo(lineView.mas_bottom).offset(40);
        make.height.mas_equalTo(44);
    }];
}

- (void)callServiceTel{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_obj.customerServiceTel]]];
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
