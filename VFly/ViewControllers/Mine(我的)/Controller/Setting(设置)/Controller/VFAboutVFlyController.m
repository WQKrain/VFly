//
//  VFAboutVFlyController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFAboutVFlyController.h"

@interface VFAboutVFlyController ()

@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)NSArray *urlArr;



@end

@implementation VFAboutVFlyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _dataArr = @[@"版本号",@"商务合作",@"官方网址",@"新浪微博",@"公众号"];
    _urlArr = @[app_Version,@"business@v-fly.club",@"www.weifengchuxing.com",@"威风出行",@"威风出行"];
    
    [self setNav];
    [self createView];
    
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
    titleLabel.text = @"关于威风出行";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    if (sender.tag == 3)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/5134449408/home?topnav=1&wvr=6"]];
    }

}







@end
