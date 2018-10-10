//
//  VFFromTheDepositViewController.m
//  VFly
//
//  Created by Hcar on 2018/4/25.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFFromTheDepositViewController.h"
#import "VFFreeCreditModel.h"
#import "WebViewVC.h"
#import "VFAdvantageView.h"

@interface VFFromTheDepositViewController ()
@property (nonatomic , strong)UIView *bgView;
@property (nonatomic , strong)UIView *haveMessageView;
@property (nonatomic , strong)VFFreeCreditModel *freeCreditModel;
@property (nonatomic , strong)UILabel *pointLabel;

@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UILabel *idLabel;
@property (nonatomic , strong)UILabel *driveLabel;

@end

@implementation VFFromTheDepositViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)loadData{
    [VFHttpRequest userCrediSuccessBlock:^(NSDictionary *data) {
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
       _freeCreditModel = [[VFFreeCreditModel alloc]initWithDic:model.data];
        _pointLabel.text = kFormat(@"%@%%", _freeCreditModel.score);
        NSRange range = [_pointLabel.text rangeOfString:_freeCreditModel.score];
        [CustomTool setTextColor:_pointLabel FontNumber:[UIFont fontWithName:@"Helvetica-Bold" size:64] AndRange:range AndColor:kWhiteColor];
        _nameLabel.text = _freeCreditModel.name;
        _idLabel.text = _freeCreditModel.card_num;
        _driveLabel.text = _freeCreditModel.mobile;
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)createView{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSpaceW(311)+kNavBarH)];
    _bgView.backgroundColor = HexColor(0x1C1F2B);
    [self.view addSubview:_bgView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, kStatutesBarH, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 0);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:backButton];
    
    UIButton *pointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pointBtn.frame = CGRectMake(kScreenW-60, kStatutesBarH, 44, 44);
    [pointBtn setImage:[UIImage imageNamed:@"XinYong_image_problem"] forState:UIControlStateNormal];
    [pointBtn addTarget:self action:@selector(problemDetailbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:pointBtn];
    
    UIView *bottomView = [[UIView alloc]init];
    [_bgView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_XinYong"]];
    [bottomView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.width.height.mas_equalTo(kSpaceW(198));
    }];
    
    _pointLabel = [UILabel initWithTitle:@"" withFont:kTextSize textColor:kWhiteColor];
    _pointLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_pointLabel];
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
        make.height.mas_equalTo(70);
    }];
    
    UILabel *bottpmLabel = [UILabel initWithTitle:@"当前完善度" withFont:kTextSize textColor:kWhiteColor];
    bottpmLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:bottpmLabel];
    [bottpmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pointLabel.mas_bottom).offset(15);
        make.centerX.equalTo(_pointLabel);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *noMessageLabel = [self noMessageLabel];
    [self.view addSubview:noMessageLabel];
    [noMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(41);
        make.right.mas_equalTo(-41);
        make.top.equalTo(_bgView.mas_bottom).offset(kSpaceH(94));
    }];
    
    [self createUseerInfoView];
    
    UIButton *bottomButton = [UIButton newButtonWithTitle:@"新增资料" sel:@selector(addMessage) target:self cornerRadius:NO];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15-kSafeBottomH);
        make.height.mas_equalTo(kSpaceH(40));
    }];
}

- (void)addMessage{
    WebViewVC *vc = [[WebViewVC alloc]init];
//    vc.urlStr = @"https://wechat.weifengchuxing.com/forApp/noDeposit/noDeposit.html?token=";
    vc.urlStr = kFormat(@"https://wechat.weifengchuxing.com/forApp/noDeposit_v2/noDeposit.html?useman_id=%@24&token=4e586a8acc3d6f6916559648c1c4ee40",_usemanID);
    vc.needToken = YES;
    vc.noNav = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createUseerInfoView{
    if (!_haveMessageView) {
        _haveMessageView = [[UIView alloc]init];
        [self.view addSubview:_haveMessageView];
        [_haveMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(_bgView.mas_bottom);
            make.height.mas_equalTo(kSpaceH(237));
        }];
        
        UILabel *titleLabel = [UILabel initWithTitle:@"实名认证基本信息" withFont:kSpaceH(kTitleSize) textColor:kTitleBoldColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_haveMessageView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kSpaceH(30));
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(kScreenW-30);
        }];
        
        UIView *messageView = [[UIView alloc]init];
        messageView.backgroundColor = kViewBgColor;
        [_haveMessageView addSubview:messageView];
        [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(titleLabel.mas_bottom).offset(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(kSpaceH(132));
        }];
        
        NSArray *dataArr = @[@"姓名",@"身份证号",@"注册手机号"];
        for (int i=0; i<3; i++) {
            UILabel *leftLabel = [UILabel initWithTitle:dataArr[i] withFont:kSpaceH(kTextBigSize) textColor:kdetailColor];
            [messageView addSubview:leftLabel];
            
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(messageView).offset(10);
                make.top.mas_equalTo(kSpaceH(44)*i);
                make.height.mas_equalTo(kSpaceH(44));
            }];
            
            UILabel *rightlabel = [UILabel initWithTitle:@"" withFont:kSpaceH(kTextBigSize) textColor:kdetailColor];
            rightlabel.textAlignment = NSTextAlignmentRight;
            [messageView addSubview:rightlabel];
            [rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(messageView).offset(-10);
                make.top.mas_equalTo(kSpaceH(44)*i);
                make.height.mas_equalTo(kSpaceH(44));
            }];
            
            if (i<2) {
                UIView *lineView = [[UIView alloc]init];
                lineView.backgroundColor = klineColor;
                [messageView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(messageView).offset(10);
                    make.right.equalTo(messageView).offset(-10);
                    make.top.mas_equalTo(kSpaceH(44)*(i+1));
                    make.height.mas_equalTo(kSpaceH(1));
                }];
            }
            
            switch (i) {
                case 0:
                    _nameLabel = rightlabel;
                    break;
                case 1:
                    _idLabel = rightlabel;
                    break;
                case 2:
                    _driveLabel = rightlabel;
                    break;
                default:
                    break;
            }
        }
    }
}


- (UILabel *)noMessageLabel{
    NSString *mobile = [[NSUserDefaults standardUserDefaults]objectForKey:kmobile];
    UILabel *label = [UILabel initWithTitle:kFormat(@"您需要填写注册手机号%@所有者相关资料", mobile) withFont:kTitleSize textColor:kTitleBoldColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label setFont:[UIFont fontWithName:kBlodFont size:kTitleSize]];
    return label;
}

- (void)problemDetailbtnClick{
    VFAdvantageView *view = [[VFAdvantageView alloc]init];
    NSArray *titleArr = @[@"信用将给您带来什么？",@"什么是资料完善度？",@"必须填写本人信息吗？"];
    NSArray *dataArr = @[@"我们平台推出了免押金租车服务，但您需要上传资料，获取信用才能享受此服务",@"没到100%说明可增加资料提升信用，到了100%也仍可更改更高质量资料，这决定了您可以更大概率享受免押金服务",@"是的，且一旦上传无法更改，但可以新增"];
    [view show:@"信用说明" sectionTitle:titleArr rowArr:dataArr];
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
