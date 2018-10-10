//
//  VFBananaDetailViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/10.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFBananaDetailViewController.h"
#import "VFbananaDetailModel.h"

@interface VFBananaDetailViewController ()

@property (nonatomic , strong)VFbananaDetailPayModel *bananaObj;

@end

@implementation VFBananaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"明细详情";
    self.view.backgroundColor = kWhiteColor;
    [self loadData];
}

- (void)loadData{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpManage getWalletDetailParameter:@{@"token":token,@"logId":_logId} Success:^(NSDictionary *data) {
        VFbananaDetailModel *model = [[VFbananaDetailModel alloc]initWithDic:data];
        _bananaObj = [[VFbananaDetailPayModel alloc]initWithDic:model.logDetail];
        [self createView];
    } withFailedBlock:^{
        
    }];
}

- (void)createView{
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(114+kStatutesBarH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    UILabel *topLabel = [UILabel initWithTitle:@"出账金额" withFont:kTitleBigSize textColor:kdetailColor];
    [topView addSubview:topLabel];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.centerY.equalTo(topLabel);
    }];
    
    UILabel *rightLabel = [UILabel initWithTitle:_bananaObj.change withFont:kNewTitle textColor:kNewSelectColor];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:rightLabel];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(topView);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(200);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kNewLineColor;
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
    NSArray *titleArr = @[@"变更说明",@"变更时间",@"账户余额"];
    NSArray *dataArr = @[_bananaObj.des,[CustomTool changTimeStr:_bananaObj.createTime],_bananaObj.balance];
    for (int i=0; i<3; i++) {
        UILabel *leftLabel = [UILabel initWithTitle:titleArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        [self.view addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(90);
            make.top.equalTo(lineView.mas_bottom).offset(12+40*i);
        }];
        
        UILabel *rightLabel = [UILabel initWithTitle:dataArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        [self.view addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(kScreenW-120);
            make.top.equalTo(lineView.mas_bottom).offset(12+40*i);
        }];
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
