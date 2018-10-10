//
//  PartnerViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/12/1.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "PartnerViewController.h"
#import "GlobalConfigModel.h"
#import "LoginViewController.h"
#import "WebViewVC.h"

@interface PartnerViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation PartnerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"威风合伙人";
    self.UMPageStatistical = @"vflyPartnerApply";
    [self setupUI];
}

- (void)setupUI {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavgationBarH+kStatutesBarH, kScreenW, kScreenH-kNavgationBarH-kStatutesBarH-40-kSafeBottomH)];
    [self.view addSubview:_scrollView];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [_scrollView addSubview:_bgView];
//    AdjustsScrollViewInsetNever
    AdjustsScrollViewInsetNever(self, _scrollView);
    
    UIImage *image = [UIImage imageNamed:@"image_companian"];
    UIImageView *bottomImageView = [[UIImageView alloc]initWithImage:image];
    bottomImageView.frame = CGRectMake(0, 0, kScreenW, kScreenW*6498.0/1125.0);
    [_bgView addSubview:bottomImageView];
    
    _bgView.frame = CGRectMake(0, 0, kScreenW, bottomImageView.height);
    _scrollView.contentSize = _bgView.size;
    
    UIButton *button = [UIButton buttonWithTitle:@"立即加入" sel:@selector(btnClick) target:self];
    button.frame = CGRectMake(20, kScreenH-50-kSafeBottomH, kScreenW-40, 40);
    [self.view addSubview:button];
}

- (void)btnClick{
    kWeakSelf;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
        [JSFProgressHUD showHUDToView:self.view];
        [HttpManage checkIsSellerSuccess:^(NSDictionary *data) {
            NSInteger state = [data[@"status"] integerValue];
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:GlobalConfig];
            GlobalConfigModel *model = [[GlobalConfigModel alloc]initWithDic:dic];
            bUrlList *url = [[bUrlList alloc]initWithDic:model.burl];
            switch (state) {
                case 1:{
                    WebViewVC *vc = [[WebViewVC alloc]init];
                    vc.urlStr = [NSString stringWithFormat:@"%@",url.main];
                    vc.isForB = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:{
                    WebViewVC *vc = [[WebViewVC alloc]init];
                    vc.urlStr = url.wait;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 3:{
                    WebViewVC *vc = [[WebViewVC alloc]init];
                    vc.urlStr = url.regist;
                    vc.needToken = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    
                default:
                    break;
            }
            [JSFProgressHUD hiddenHUD:self.view];
        } failedBlock:^{
            [JSFProgressHUD hiddenHUD:self.view];
        }];
    }else{
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
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
