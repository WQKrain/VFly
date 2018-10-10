//
//  VIPViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VIPViewController.h"
#import "CustomApplyAlertView.h"
#import "VipModel.h"
#import "VipOrderModel.h"
#import "LoginViewController.h"

#import "VipInfoModel.h"
#import "VFChoosePayViewController.h"
#import "VFOldChoosePayViewController.h"
#import "LoginModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface VIPViewController ()<UIScrollViewDelegate>

/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray *dataArr;


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) NSInteger scrollPage;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *rightlabel;

@property (nonatomic, strong) NSArray *showMoney;
@property (nonatomic, strong) NSArray *vipArr;
@property (nonatomic, strong) VipInfoModel *vipModel;
@property (nonatomic, strong) UIButton *updateButton;

@end

@implementation VIPViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    kWeakSelf;
    self.UMPageStatistical = @"member";
    _vipArr = @[@"威风",@"威风铂金",@"威风黑金"];
    _showMoney = @[@"5w/年",@"30w/年",@"80w/年"];
    _dataArr = [[NSMutableArray alloc]init];
    _scrollPage = 0;
    [JSFProgressHUD showHUDToView:self.view];
    [HttpManage vipLevelListSuccess:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        VipModel *model = [[VipModel alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.vipList) {
            VipListModel *obj = [[VipListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        
        [HttpManage getVipInfoSuccess:^(NSDictionary *data) {
            _vipModel = [[VipInfoModel alloc]initWithDic:data];
            [weakSelf createView];
        } failedBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
        }];
    } failedBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
        [ProgressHUD showError:@"加载失败"];
    }];
}


- (void)createView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH, kScreenW, 50)];
    [self.view addSubview:topView];
    NSArray *cardArr = @[@"威风卡",@"铂金卡",@"黑金卡"];
    for (int i= 0; i<3; i++) {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        topButton.frame = CGRectMake(i*(kScreenW/3), 0, kScreenW/3, 50);
        [topButton setTitle:cardArr[i] forState:UIControlStateNormal];
        topButton.titleLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
        [topButton setTitleColor:kdetailColor forState:UIControlStateNormal];
        topButton.tag = i;
        [topButton addTarget:self action:@selector(chooseVip:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:topButton];
    }
    
    _markView = [[UIView alloc]initWithFrame:CGRectMake(11, 48, kScreenW/3-22, 2)];
    _markView.backgroundColor = kMainColor;
    [topView addSubview:_markView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+kStatutesBarH+50, kScreenW, kScreenH-154-kStatutesBarH-kSafeBottomH)];
    [self.view addSubview:_scrollView];
    //✨✨不能划的原因是因为没有设置此属性
    _scrollView.contentSize=CGSizeMake(kScreenW*3, 0);
    _scrollView.delegate = self;
    //✨✨设置scrollview的偏移量
    _scrollView.contentOffset=CGPointMake(0, 0);
    _scrollView.pagingEnabled=YES;//整张滑动
    _scrollView.bounces=NO;//是否反弹
    //隐藏/显示 水平和垂直方向的滚动条
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
//    NSArray *topImageArr= @[[UIImage imageNamed:@"image_weifengCard"],[UIImage imageNamed:@"image_bojinCard"],[UIImage imageNamed:@"image_heijinCard"]];
//    NSArray * bottomImageArr = @[[UIImage imageNamed:@"image_VipRight_WeiFengCard"],[UIImage imageNamed:@"image_VipRight_BoJinCard"],[UIImage imageNamed:@"image_VipRight_HeiJinCard"]];
    for (int i=0; i<_dataArr.count; i++) {
        VipListModel *obj = _dataArr[i];
        UIImageView *bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW*i, _scrollView.height-kScreenW/750*728, kScreenW, kScreenW/750*728)];
        [bottomView sd_setImageWithURL:[NSURL URLWithString:obj.imageGood] placeholderImage:nil];
//        NSString *str1 = [obj.image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        [bottomView sd_setImageWithURL:[NSURL URLWithString:str1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            bottomView.image = image;
//        }];
        
        [_scrollView addSubview:bottomView];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, _scrollView.height- kScreenW/750*728)];
        [_scrollView addSubview:topView];
        
        float picHeight = topView.height/4*3;
        
        UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenW-picHeight*458.0/235)/2,(topView.height-picHeight)/2, picHeight*458.0/235, picHeight)];
        [topImage sd_setImageWithURL:[NSURL URLWithString:obj.imageMain] placeholderImage:nil];
        [topView addSubview:topImage];
    }
    
    //最下边固定视图
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-49-kSafeBottomH, kScreenW, 49)];
    barView.backgroundColor = kBarBgColor;
    [self.view addSubview:barView];
    _topLabel = [UILabel initWithTitle:kFormat(@"预存%@ 成为%@会员",_showMoney[0] ,_vipArr[0]) withFont:kTitleBigSize textColor:kWhiteColor];
    _topLabel.frame = CGRectMake(15, 10, kScreenW-147, kTitleBigSize);
    [barView addSubview:_topLabel];
    _updateButton = [UIButton newButtonWithTitle:@"成为会员" sel:@selector(connettionBtnClick:) target:self cornerRadius:NO];
    _updateButton.frame = CGRectMake(kScreenW-132, 0, 132, 49);
    [barView addSubview:_updateButton];
    
    if ([_vipModel.vipLevel intValue] !=0) {
        _topLabel.text = @"您已是尊贵的威风会员";
//        _updateButton.backgroundColor = kBarBgColor;
//        [_updateButton setEnabled:NO];
        [_updateButton setTitle:@"升级会员" forState:UIControlStateNormal];
        _updateButton.hidden = YES;
    }
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _topLabel.bottom+7, kScreenW-147, kTextSmallSize)];
    bottomLabel.text = @"此预存金额可用于租金、押金和违章保证金";
    bottomLabel.textColor = kWhiteColor;
    bottomLabel.font = [UIFont systemFontOfSize:kTextSmallSize];
    [barView addSubview:bottomLabel];
//    _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
//    _topLabel.text = [NSString stringWithFormat:@"预存%@",_showMoney[0]];
//    [_topLabel sizeToFit];
//    [barView addSubview:_topLabel];
//    
//    NSRange range = [_topLabel.text rangeOfString:_showMoney[0]];
//    [CustomTool setTextColor:_topLabel FontNumber:[UIFont systemFontOfSize:kTitleBigSize] AndRange:range AndColor:kMainColor];
//    _rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(_topLabel.right, 13, 30, 20)];
//    _rightlabel.text = [NSString stringWithFormat:@"成为%@会员",_vipArr[0]];
//    _rightlabel.font = [UIFont systemFontOfSize:kTextBigSize];
//    _rightlabel.textColor = kdetailColor;
//    [_rightlabel sizeToFit];
//    NSRange latRange = [_rightlabel.text rangeOfString:_vipArr[0]];
//    [CustomTool setTextColor:_rightlabel FontNumber:[UIFont systemFontOfSize:kTextBigSize] AndRange:latRange AndColor:kMainColor];
//    [barView addSubview:_rightlabel];
    
}


- (void)connettionBtnClick:(UIButton *)sender{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
        kWeakself;
        if (_dataArr.count == 0) {
            return;
        }
        [JSFProgressHUD showHUDToView:self.view];
        NSString *money;
        if (_scrollPage == 0) {
            money = [NSString stringWithFormat:@"%d",(50000- [_vipModel.vipMoney intValue])];
        }else if (_scrollPage == 1){
            money = [NSString stringWithFormat:@"%d",(300000- [_vipModel.vipMoney intValue])];
        }else{
            money = [NSString stringWithFormat:@"%d",(800000- [_vipModel.vipMoney intValue])];
        }
        NSDictionary *dic = @{@"token":token,@"money":money};
        [HttpManage vipOrderParameter:dic success:^(NSDictionary *dic) {
            [JSFProgressHUD hiddenHUD:self.view];
            HCBaseMode *model = [[HCBaseMode alloc]initWithDic:dic];
            if ([model.info isEqualToString:@"ok"]) {
                NSDictionary *data = model.data;
                VipOrderModel *model = [[VipOrderModel alloc]initWithDic:data];
                VFOldChoosePayViewController *vc = [[VFOldChoosePayViewController alloc]init];
                vc.orderID = model.orderId;
                vc.moneyType = @"8";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:model.info];
                HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
                [alertCtrl addAction:Action];
                [self presentViewController:alertCtrl animated:NO completion:nil];
            }
        } failedBlock:^{
            [JSFProgressHUD hiddenHUD:self.view];
            [ProgressHUD showError:@"请求失败"];
        }];
        
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }

    
//    if (token) {
//        kWeakself;
//        if (_dataArr.count == 0) {
//            return;
//        }
//        VipListModel *obj = _dataArr[_scrollPage];
//        NSDictionary *dic = @{@"token":token,@"vipId":obj.vipId};
//        [HttpManage vipApplyParameter:dic success:^(NSString *info) {
//            if ([info isEqualToString:@"ok"]) {
//                CustomApplyAlertView *view = [[CustomApplyAlertView alloc]initWithTitle:@"申请提交成功" pic:[UIImage imageNamed:@"icon_state_sucess"] message:@"客服会在15分钟之内与您联系"];
//                view.resultIndex = ^(NSInteger index) {
//                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//                };
//                [view showXLAlertView];
//            }else {
//                [CustomTool alertViewShow:info];
//            }
//        } failedBlock:^{
//            
//        }];
//        [self.centerView removeFromSuperview];
//        [self.alertView removeFromSuperview];
//    }else{
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        [self presentViewController:loginVC animated:YES completion:nil];
//    }
}

- (void)chooseVip:(UIButton *)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _scrollView.contentOffset = CGPointMake(kScreenW*sender.tag, 0);
    _markView.frame = CGRectMake(11+ sender.tag *(kScreenW/3), 48, kScreenW/3-22, 2);
    [UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/kScreenW;
    _scrollPage = page;
    _markView.frame = CGRectMake(11+scrollView.contentOffset.x/kScreenW *(kScreenW/3), 48, kScreenW/3-22, 2);
    _topLabel.text = [NSString stringWithFormat:@"预存%@ 成为%@会员",_showMoney[page],_vipArr[page]];
    
    switch ([_vipModel.vipLevel intValue]) {

        case 0:
            _topLabel.text = kFormat(@"预存%@ 成为%@会员",_showMoney[_scrollPage] ,_vipArr[_scrollPage]);
            break;
        case 1:
            if (_scrollPage == 0) {
                _topLabel.text = @"您已是尊贵的威风会员";
                _updateButton.hidden = YES;
            }else{
                _topLabel.text = kFormat(@"预存%@ 成为%@会员",_showMoney[_scrollPage] ,_vipArr[_scrollPage]);
                _updateButton.hidden = NO;
            }
            break;
        case 2:
            if (_scrollPage == 0) {
                _topLabel.text = @"您已是尊贵的威风会员";
                _updateButton.hidden = YES;
            }else if (_scrollPage == 1){
                _topLabel.text = @"您已是尊贵的铂金会员";
                _updateButton.hidden = YES;
            }
           else{
                _topLabel.text = kFormat(@"预存%@ 成为%@会员",_showMoney[_scrollPage] ,_vipArr[_scrollPage]);
                _updateButton.hidden = NO;
            }
            break;
        case 3:
            _topLabel.text = kFormat(@"您已是尊贵的%@", _vipArr[_scrollPage]);
            _updateButton.hidden = YES;
            break;
        default:
            break;
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
