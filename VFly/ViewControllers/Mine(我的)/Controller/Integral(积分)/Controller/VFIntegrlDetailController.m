//
//  VFIntegrlDetailController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFIntegrlDetailController.h"
#import "VFbananaDetailModel.h"

@interface VFIntegrlDetailController ()

@property (nonatomic , strong)VFbananaDetailPayModel *bananaObj;

@end

@implementation VFIntegrlDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self loadData];
    [self setNav];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    
    
}

- (void)loadData {
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpManage scoreDetailParameter:@{@"token":token,
                                       @"logId":_loginID} success:^(NSDictionary *data) {
        VFbananaDetailModel *model = [[VFbananaDetailModel alloc]initWithDic:data];
        _bananaObj = [[VFbananaDetailPayModel alloc]initWithDic:model.logDetail];
        [self createView];
    } failedBlock:^(NSError *error) {
        
    }];
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
    titleLabel.text = @"积分明细";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView{
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44+kStatutesBarH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    

    
    UILabel *topLabel = [UILabel initWithTitle:@"减少积分" withFont:kTitleBigSize textColor:kdetailColor];
    [topView addSubview:topLabel];
    
    if ([self.isAdd intValue] == 1)
    {
        topLabel.text = @"减少积分";
    }
    else
    {
        topLabel.text = @"增加积分";
    }
    
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
    
    NSArray *titleArr = @[@"变更说明",@"变更时间",@"剩余积分"];
    NSArray *dataArr = @[_bananaObj.des,[CustomTool changChineseTimeStr:_bananaObj.createTime],_bananaObj.balance];
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


@end
