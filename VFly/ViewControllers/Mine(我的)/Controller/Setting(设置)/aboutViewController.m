//
//  aboutViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/17.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "aboutViewController.h"
#import "WebViewVC.h"

@interface aboutViewController ()
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)NSArray *urlArr;

@end

@implementation aboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.UMPageStatistical = @"aboutUs";
    self.view.backgroundColor = kWhiteColor;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _dataArr = @[@"版本号",@"商务合作",@"官方网址",@"新浪微博",@"公众号"];
    _urlArr = @[app_Version,@"business@v-fly.club",@"www.weifengchuxing.com",@"威风出行",@"威风出行"];
    
    [self createView];
}

- (void)createView{
    UIImageView *logoImage = [[UIImageView alloc]init];
    logoImage.image = [UIImage imageNamed:@"setting_image_logo"];
    [self.view addSubview:logoImage];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(124);
        make.width.mas_equalTo(100);
         make.height.mas_equalTo(124);
    }];
    
    for (int i= 0; i<5; i++) {
        UIView *bgView =[[UIView alloc]init];
        bgView.frame = CGRectMake(15, 248+ 41+i*40, kScreenW-30, 44);
        [self.view addSubview:bgView];
        
        if (i==0 || i==2 || i== 4) {
            bgView.backgroundColor = kNewBgColor;
        }
        
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.font = [UIFont systemFontOfSize:kTextBigSize];
        leftLabel.frame = CGRectMake(kSpaceW(46), 0, 70, 44);
        leftLabel.text =_dataArr[i];
        [bgView addSubview:leftLabel];

        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightButton.frame = CGRectMake(leftLabel.right + 5,0, 128, 44);
        [rightButton setTitle:_urlArr[i] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:kTextBigSize];
        [rightButton setTitleColor:kdetailColor forState:UIControlStateNormal];
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        rightButton.tag = i;
        [rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(leftLabel.right + 5);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
    }
}

- (void)btnClick:(UIButton *)sender{
    if (sender.tag == 3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/5134449408/home?topnav=1&wvr=6"]];
    }
//    else {
//        WebViewVC *vc= [WebViewVC new];
//        [self.navigationController pushViewController:vc WithAnimationType:nil];
//    }
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
