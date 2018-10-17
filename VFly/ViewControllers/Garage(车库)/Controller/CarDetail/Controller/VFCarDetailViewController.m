//
//  VFCarDetailViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFCarDetailViewController.h"
#import "VFCarDetailModel.h"
#import "LoginViewController.h"
//#import "SDCycleScrollView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "VFCarDetailServiceTableViewCell.h"
#import "HCCarDetailCarParametersCell.h"
#import "VFDetailProcessTableViewCell.h"
#import "UIView+CLSetRect.h"
#import "UIImageView+WebCache.h"
#import "VFConfirmOrderViewController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "VFAdvantageView.h"

#import "CLTableViewCell.h"
#import "CLPlayerView.h"
#import "CLModel.h"
#import "VFCarDetailLongRentCell.h"

#import "STImageVIew.h"
#import "STPhotoBroswer.h"
#import "VFCustomerQualificationModel.h"
#import "VFFromTheDepositTableViewCell.h"


NSString * const SecCustCell = @"VFFromTheDepositTableViewCell";

@interface VFCarDetailViewController ()<UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate,UIActionSheetDelegate,CLTableViewCellDelegate,SDCycleScrollViewDelegate,UIAlertViewDelegate,LoginViewControllerDelegate,VFFromTheDepositTableViewCellDelegate>{
    dispatch_group_t _groupEnter;
}
@property (nonatomic , strong)VFCarDetailModel *carDetailmodel;
@property (nonatomic , strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic , strong)NSArray *sectionArr;
@property (nonatomic , strong)UITableView *tableView;

@property (nonatomic , strong)UIButton *faviteButton;

/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;
/**记录Cell*/
@property (nonatomic, assign) UITableViewCell *cell;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *backTopButton;
@property (nonatomic, strong) anyButton *shareButton;

@property (nonatomic, strong) UILabel *showDepositlabel;
@property (nonatomic, strong) UIImageView *lineImage;

@property (nonatomic, strong) VFCustomerQualificationModel *customerQualificationModel;
@property (nonatomic, assign) CGFloat rowHeight;
@end

@implementation VFCarDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_playerView destroyPlayer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    _rowHeight = 0;
    self.UMPageStatistical = @"carDetails";
    [self createBottomView];

    _sectionArr = @[@"",@"免押金",@"服务保障",@"车辆参数",@"租车流程",@"",@"使用方法",@"车辆详情"];
   [self loadData];
}

- (void)createNavBar:(NSString *)title{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatutesBarH+44)];
    _navView.backgroundColor = [UIColor whiteColor];
    _navView.alpha = 0;
    
    anyButton *backButton = [anyButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, kStatutesBarH, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
    [backButton changeImageFrame:CGRectMake(0, 11, 22, 22)];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backButton];
    
    _shareButton = [anyButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(kScreenW-62, kStatutesBarH, 44, 44);
    [_shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [_shareButton changeImageFrame:CGRectMake(22, 11, 22, 22)];
    [_shareButton addTarget:self action:@selector(shareButtonClcik) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_shareButton];
    _shareButton.hidden = YES;
    
    UILabel *label = [UILabel initWithTitle:title withFont:kTitleBigSize textColor:kTitleBoldColor];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    label.frame = CGRectMake(52, kStatutesBarH, kScreenW-104, 44);
    label.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:label];
    [self.view addSubview:_navView];
    _lineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line_nav"]];
    _lineImage.alpha = 0;
    [_navView addSubview:_lineImage];
    [_lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    _navView.alpha = alpha;
    _lineImage.alpha = alpha;
    if (offset>kScreenW*kPicZoom-10) {
        _shareButton.hidden = NO;
    }else{
        _shareButton.hidden = YES;
    }
    
    if (offset > kScreenH) {
        if (_backTopButton.alpha == 1.0) {
            
        }else{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.5];
            [UIView setAnimationRepeatAutoreverses:NO];
            [UIView setAnimationRepeatCount:1];
            _backTopButton.alpha=1.0;
            [UIView commitAnimations];
        }
    }else{
        if (_backTopButton.alpha == 0.0) {
            
        }else{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.5];
            [UIView setAnimationRepeatAutoreverses:NO];
            [UIView setAnimationRepeatCount:1];
            _backTopButton.alpha=0.0;
            [UIView commitAnimations];
        }
    }
}


- (void)loadData{
    kWeakSelf;
    [JSFProgressHUD showHUDToView:self.view];
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    [VFHttpRequest getCarDetailParameter:self.carId dic:@{@"city_id":cityID} successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            _carDetailmodel = [[VFCarDetailModel alloc]initWithDic:model.data];
            NSDictionary *meta = data[@"meta"];
            _carDetailmodel.isStar = [NSString stringWithFormat:@"%@", meta[@"isStar"]];
            [self createView];
            [self createNavBar:kFormat(@"%@%@", _carDetailmodel.brand,_carDetailmodel.model)];
            _cycleScrollView.imageURLStringsGroup = _carDetailmodel.images;
            [weakSelf.tableView reloadData];
            
            if ([_carDetailmodel.isStar isEqualToString:@"1"]) {
                _faviteButton.selected = YES;
            }else{
                _faviteButton.selected = NO;
            }
            
        }];
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];

    }];
}

#pragma mark -----------创建tableView及其代理方法-------------
- (void)createView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-49-kSafeBottomH) style:UITableViewStyleGrouped];
    AdjustsScrollViewInsetNever(self,self.tableView);
    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    [self.tableView registerClass:[VFFromTheDepositTableViewCell class] forCellReuseIdentifier:NSStringFromClass([VFFromTheDepositTableViewCell class])];
    [self.tableView registerClass:[VFCarDetailServiceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([VFCarDetailServiceTableViewCell class])];
    [self.tableView registerClass:[HCCarDetailCarParametersCell class] forCellReuseIdentifier:NSStringFromClass([HCCarDetailCarParametersCell class])];
    [self.tableView registerClass:[VFDetailProcessTableViewCell class] forCellReuseIdentifier:NSStringFromClass([VFDetailProcessTableViewCell class])];
    [self.tableView registerClass:[CLTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ CLTableViewCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"photoCell"];
     [self.tableView registerClass:[VFCarDetailLongRentCell class] forCellReuseIdentifier:NSStringFromClass([VFCarDetailLongRentCell class])];
    
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backTopButton.frame = CGRectMake(kScreenW-30-kSpaceW(60), kScreenH-49-kSafeBottomH-20-kSpaceW(44), kSpaceW(60), kSpaceW(60));
    [_backTopButton setImage:[UIImage imageNamed:@"icon_back top"] forState:UIControlStateNormal];
    [_backTopButton addTarget:self action:@selector(backTopButtonClcik) forControlEvents:UIControlEventTouchUpInside];
    _backTopButton.alpha = 0;
    [self.view addSubview:_backTopButton];
}

- (void)backTopButtonClcik{
    [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/4.0*3.0) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"icon_red"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"ico_white"];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.imageURLStringsGroup = _carDetailmodel.images;
        _cycleScrollView.autoScroll = NO;
        
        anyButton *backButton = [anyButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, Status_Bar_Height, 80, 60);
        [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        [backButton changeImageFrame:CGRectMake(15, 21, 22, 22)];
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_cycleScrollView addSubview:backButton];
        
        if (_freeDeposit) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/4.0*3.0+30)];
            [bgView addSubview:_cycleScrollView];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenW/4.0*3.0, kScreenW, 30)];
            view.backgroundColor = kNewBgColor;
            [bgView addSubview:view];
            
            VFCustomerQualificationDetailModel *obj = [[VFCustomerQualificationDetailModel alloc]initWithDic:_customerQualificationModel.qualification];
            float deposit = [_carDetailmodel.deposit intValue];
            float money = [obj.available intValue];
            float pay = deposit-money;
            if (pay<0) {
                pay = 0;
            }
            
            NSString *lastPay = [NSString stringWithFormat:@"%f",pay];
            
            _showDepositlabel = [UILabel initWithTitle:kFormat(@"押金%@万    您有%@万可用免押金额度，只需支付%@万",[CustomTool removeFloatAllZero:_carDetailmodel.deposit],[CustomTool removeFloatAllZero:obj.available],[CustomTool removeFloatAllZero:lastPay]) withFont:kTextSize textColor:kdetailColor];
            
            [view addSubview:_showDepositlabel];
            [_showDepositlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(0);
                make.height.mas_offset(30);
                make.center.equalTo(view);
            }];
            
            UIView *leftView = [[UIView alloc]init];
            leftView.backgroundColor = kBlackColor;
            [view addSubview:leftView];
            [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_showDepositlabel.mas_left).offset(-15);
                make.height.width.mas_offset(3);
                make.centerY.equalTo(view);
            }];
            
            UIView *rightView = [[UIView alloc]init];
            rightView.backgroundColor = kBlackColor;
            [view addSubview:rightView];
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_showDepositlabel.mas_right).offset(15);
                make.height.width.mas_offset(3);
                make.centerY.equalTo(view);
            }];
            
            return bgView;
        }
        return _cycleScrollView;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel initWithTitle:_sectionArr[section] withFont:kTitleSize textColor:kTitleBoldColor];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleSize]];
        label.frame =CGRectMake(15, 30, kScreenW-30, 25);
        [view addSubview:label];
        
        if (section == 5) {
            if ([_carDetailmodel.video isEqualToString:@""]) {
                label.frame =CGRectMake(15, 0, kScreenW-30, 0);
            }else{
                label.frame =CGRectMake(15, 30, kScreenW-30, 25);
            }
        }
        
        if (section == 6) {
            if (self.carDetailmodel.detailImages.count == 0) {
                label.frame =CGRectMake(15, 0, kScreenW-30, 0);
            }else{
                label.frame =CGRectMake(15, 30, kScreenW-30, 25);
            }
        }
        return view;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:_carDetailmodel.images currentIndex:index];
    [broser show];
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        NSString *content = _carDetailmodel.carDescription;
        CGFloat titleHeight = [CustomTool getSpaceLabelHeightwithContentString:content];
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 155+titleHeight)];
        if (titleHeight == 0) {
            sectionView.height = 135;
        }
        sectionView.backgroundColor = kWhiteColor;
        //标题
        UILabel *titleLabel = [UILabel initWithTitle:kFormat(@"%@%@", _carDetailmodel.brand,_carDetailmodel.model) withFont:kTitleSize textColor:kTitleBoldColor];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleSize]];
        titleLabel.frame = CGRectMake(15, 20, kScreenW-80, 25);
        [sectionView addSubview:titleLabel];
        
        //标签
        NSArray *tags = _carDetailmodel.tags;
        UILabel *selectLabel;
        
        UIView *tageView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+5, kScreenW, 13)];
        [sectionView addSubview:tageView];
        
        if (tags.count == 0) {
            tageView.height = 0;
        }else{
            for (int i=0; i<tags.count; i++) {
                UILabel *label = [UILabel initWithTitle:tags[i] withFont:kTextSmallSize textColor:kWhiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = kTitleBoldColor;
                [tageView addSubview:label];
                if (i == 0) {
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(15);
                        make.top.mas_equalTo(0);
                        make.height.mas_equalTo(kTextBigSize);
                        [label sizeToFit];
                        make.width.mas_equalTo(label.width+4);
                    }];
                }else{
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(selectLabel.mas_right).offset(5);
                        make.top.mas_equalTo(0);
                        make.height.mas_equalTo(kTextBigSize);
                        [label sizeToFit];
                        make.width.mas_equalTo(label.width+4);
                    }];
                }
                selectLabel = label;
            }
        }
        
        UILabel *moneyLabel = [UILabel initWithTitle:kFormat(@"¥%@/天", _carDetailmodel.price) withFont:kNewTitle textColor:kMainColor];
        [moneyLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kNewTitle]];
        moneyLabel.frame= CGRectMake(15, tageView.bottom+20, 200, 33);
        [moneyLabel sizeToFit];
        moneyLabel.height = 33;
        [sectionView addSubview:moneyLabel];
        NSRange range = [moneyLabel.text rangeOfString:@"¥"];
        [CustomTool setTextColor:moneyLabel FontNumber:[UIFont systemFontOfSize:kTextSize] AndRange:range AndColor:kMainColor];
        
        anyButton *shareButton = [anyButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(kScreenW-62, 26, 62, 48);
        [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        [shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [shareButton setTitleColor:kTitleBoldColor forState:UIControlStateNormal];
        shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [shareButton changeImageFrame:CGRectMake(20, 0, 22, 22)];
        [shareButton changeTitleFrame:CGRectMake(0, 23, 62, kTitleBigSize)];
        [shareButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextSize]];
        [shareButton addTarget:self action:@selector(shareButtonClcik) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:shareButton];
        
        UILabel *bottomLabel = [UILabel initWithTitle:content withFont:kTextSize textColor:kdetailColor];
        bottomLabel.frame =CGRectMake(15, moneyLabel.bottom+15, kScreenW-30, titleHeight);
        bottomLabel.numberOfLines = 0;
        [UILabel changeLineSpaceForLabel:bottomLabel WithSpace:8];
        [sectionView addSubview:bottomLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, sectionView.height -1, kScreenW, 1)];
        lineImageView.image = [UIImage imageNamed:@"line_nav"];
        [sectionView addSubview:lineImageView];

        return sectionView;
    }else if (section == 6){
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 39)];
        /*
        UIView *leftLine = [[UIView alloc]init];
        leftLine.backgroundColor = kHomeLineColor;
        [footView addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo((kScreenW-224)/2);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *label = [UILabel initWithTitle:@"这可是我的底线" withFont:kTextSize textColor:kNewDetailColor];
        [footView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7);
            make.left.equalTo(leftLine.mas_right).offset(10);
            make.height.mas_equalTo(17);
        }];
        
        UIView *rightLine = [[UIView alloc]init];
        rightLine.backgroundColor = kHomeLineColor;
        [footView addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(label.mas_right).offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(1);
        }];
        */
        return footView;
    }
    else{
        return [[UIView alloc]init];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if ([_carDetailmodel.carDescription isEqualToString:@""]) {
            return 135;
        }else{
            CGFloat titleSize = [CustomTool getSpaceLabelHeightwithContentString:_carDetailmodel.carDescription];
            return 155+titleSize;
        }
    }else if (section == 7){
        return 39;
    }
    else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 1:
            return _rowHeight;
            break;
        case 2:
            return 108;
            break;
        case 3:
            return 264;
            break;
        case 4:
            return (kScreenW-30)*254/638+32;
            break;
        case 5:
            return 0;
            break;
        case 6:
            if ([_carDetailmodel.video isEqualToString:@""]) {
                return 0;
            }else{
                return (kScreenW-30)/16.0*9;
            }
            break;
        case 7:
            if (self.carDetailmodel.detailImages.count == 0) {
                return 0;
            }else{
                return ((kScreenW-30)*kPicZoom+10) * self.carDetailmodel.detailImages.count;
            }
            break;
        default:
            break;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_freeDeposit) {
            return kScreenW/4.0*3.0+30;
        }
        return kScreenW/4.0*3.0;
    }else{
        
        if (section == 5) {
            return 0;
        }
        
        if (section == 6) {
            if ([_carDetailmodel.video isEqualToString:@""]) {
                return 0;
            }
        }
        if (section == 7) {
            if (self.carDetailmodel.detailImages.count == 0) {
                return 0;
            }
        }
        return 70;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
        case 6:
            return 1;
            break;
        case 7:
            return 1;
            break;
        default:
            break;
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        VFFromTheDepositTableViewCell *depositCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VFFromTheDepositTableViewCell class])];
        
        depositCell.delegate = self;
        return depositCell;
    }else if (indexPath.section == 2) {
        VFCarDetailServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VFCarDetailServiceTableViewCell class]) forIndexPath:indexPath];
        cell.carDetailServerClickBlock = ^(NSInteger buttonTag) {
            VFAdvantageView *view = [[VFAdvantageView alloc]init];
            NSArray *titleArr = @[@"400辆自有豪车，车型应有尽有",@"押金最低可至0元",@"车辆年限短，车况佳",@"事故无需担忧",@"全国100多个地区送车上门",@"支持异地还车",@"行驶里程高",@"高标准服务体系"];
            NSArray *dataArr = @[@"法拉利、保时捷、兰博基尼、玛莎拉蒂、迈凯伦阿斯顿马丁、宾利、劳斯莱斯量产车全系车型。奔驰、宝马、路虎、特斯拉、野马高端车型。",@"低押金，更多押金减免规则，最低可至0元。",@"车辆事故全程公司解决，损失由保险公司承担。",@"车辆年限短，80%三年内新车。定期车辆检查保养，保证车辆无故障。",@"全国21家门店，全国就近门店送车上门。",@"自驾旅游、商务出行，跨省均可还车。",@"行驶里程最高达600KM/天",@"24小时客服在线，标准化服务体系，提供更多额外服务。"];
            [view show:@"威风优势" sectionTitle:titleArr rowArr:dataArr];
        };
        return cell;
    }else if (indexPath.section == 3){
        HCCarDetailCarParametersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCCarDetailCarParametersCell class]) forIndexPath:indexPath];
        cell.carDetailModel = _carDetailmodel;
        cell.backgroundColor = kWhiteColor;
        return cell;
    }else if (indexPath.section == 4){
        VFDetailProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VFDetailProcessTableViewCell class]) forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 5){
        VFCarDetailLongRentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VFCarDetailLongRentCell class]) forIndexPath:indexPath];
        cell.model = _carDetailmodel;
        cell.hidden = YES;
        return cell;
    }
    else if (indexPath.section == 6){
        CLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ CLTableViewCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        if ([_carDetailmodel.video isEqualToString:@""]) {
            cell.hidden = YES;
        }
        return cell;
    }else if (indexPath.section == 7){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenW-30, (kScreenW-30)*kPicZoom * self.carDetailmodel.detailImages.count + 15)];
        backView.backgroundColor = kWhiteColor;
        [cell addSubview:backView];
        for (NSInteger i = 0; i < self.carDetailmodel.detailImages.count; i++)
        {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.frame = CGRectMake(0, ((kScreenW-30)*kPicZoom+10)*i, kScreenW-30, (kScreenW-30)*kPicZoom);
            [imageV fadeImageWithURL:self.carDetailmodel.detailImages[i]];
            [backView addSubview:imageV];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = imageV.frame;
            button.tag = i;
            [button addTarget:self action:@selector(sectionImageClcik:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:button];
        }
        return cell;
    }
    else{
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
}

- (void)VFFromTheDepositTableViewCell:(CGFloat)height{
    _rowHeight = height;
    [_tableView reloadData];
}

- (void)sectionImageClcik:(UIButton *)sender{
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:_carDetailmodel.detailImages currentIndex:sender. tag];
    [broser show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        VFAdvantageView *view = [[VFAdvantageView alloc]init];
        NSArray *titleArr = @[@"400辆自有豪车，车型应有尽有",@"押金最低可至0元",@"车辆年限短，车况佳",@"事故无需担忧",@"全国100多个地区送车上门",@"支持异地还车",@"行驶里程高",@"高标准服务体系"];
        NSArray *dataArr = @[@"法拉利、保时捷、兰博基尼、玛莎拉蒂、迈凯伦阿斯顿马丁、宾利、劳斯莱斯量产车全系车型。奔驰、宝马、路虎、特斯拉、野马高端车型。",@"低押金，更多押金减免规则，最低可至0元。",@"车辆事故全程公司解决，损失由保险公司承担。",@"车辆年限短，80%三年内新车。定期车辆检查保养，保证车辆无故障。",@"全国21家门店，全国就近门店送车上门。",@"自驾旅游、商务出行，跨省均可还车。",@"行驶里程最高达600KM/天",@"24小时客服在线，标准化服务体系，提供更多额外服务。"];
        [view show:@"威风优势" sectionTitle:titleArr rowArr:dataArr];
    }
}


#pragma mark------------分享----------------
- (void)shareButtonClcik{
    
    if ([WXApi isWXAppInstalled]) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信", @"朋友圈",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }else{
        [CustomTool alertViewShow:@"暂无法使用该功能"];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }else if (buttonIndex == 1){
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_carDetailmodel.shareTitle descr:_carDetailmodel.shareDescription thumImage:nil];
    NSString *url = _carDetailmodel.shareUrl;
    shareObject.webpageUrl = url;
    
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [CustomTool alertViewShow:@"分享失败"];
        }else{
            [CustomTool alertViewShow:@"分享成功"];
        }
    }];
}

#pragma mark--------------视频播放器---------
//在willDisplayCell里面处理数据能优化tableview的滑动流畅性，cell将要出现的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 6) {
        CLTableViewCell * myCell = (CLTableViewCell *)cell;
        CLModel *model = [CLModel new];
        [model setValuesForKeysWithDictionary:@{@"pictureUrl":_carDetailmodel.videoCover,@"videoUrl":_carDetailmodel.video}];
        myCell.model = model;
        //Cell开始出现的时候修正偏移量，让图片可以全部显示
        [myCell cellOffset];
        //第一次加载动画
        [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:myCell.model.pictureUrl] completion:^(BOOL isInCache) {
            if (!isInCache) {
                //主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    CATransform3D rotation;//3D旋转
                    rotation = CATransform3DMakeTranslation(0 ,50 ,20);
                    //逆时针旋转
                    rotation = CATransform3DScale(rotation, 0.8, 0.9, 1);
                    rotation.m34 = 1.0/ -600;
                    myCell.layer.shadowColor = [[UIColor blackColor]CGColor];
                    myCell.layer.shadowOffset = CGSizeMake(10, 10);
                    myCell.alpha = 0;
                    myCell.layer.transform = rotation;
                    [UIView beginAnimations:@"rotation" context:NULL];
                    //旋转时间
                    [UIView setAnimationDuration:0.6];
                    myCell.layer.transform = CATransform3DIdentity;
                    myCell.alpha = 1;
                    myCell.layer.shadowOffset = CGSizeMake(0, 0);
                    [UIView commitAnimations];
                });
            }
        }];
        
    }
}
//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([_cell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
        [_playerView destroyPlayer];
        _cell = nil;
    }
}
#pragma mark - 点击播放代理
- (void)cl_tableViewCellPlayVideoWithCell:(CLTableViewCell *)cell{
    //记录被点击的Cell
    _cell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    //    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, cell.CLwidth, cell.CLheight)];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(15, 0, cell.CLwidth-30, cell.CLheight)];
    _playerView = playerView;
    [cell.contentView addSubview:_playerView];
    //    //重复播放，默认不播放
    //    _playerView.repeatPlay = YES;
    //    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
    //    _playerView.isLandscape = YES;
    //    //设置等比例全屏拉伸，多余部分会被剪切
    //    _playerView.fillMode = ResizeAspectFill;
    //    //设置进度条背景颜色
    //    _playerView.progressBackgroundColor = [UIColor purpleColor];
    //    //设置进度条缓冲颜色
    //    _playerView.progressBufferColor = [UIColor redColor];
    //    //设置进度条播放完成颜色
    //    _playerView.progressPlayFinishColor = [UIColor greenColor];
    //    //全屏是否隐藏状态栏
    //    _playerView.fullStatusBarHidden = NO;
    //    //转子颜色
    //    _playerView.strokeColor = [UIColor redColor];
    //视频地址
    _playerView.url = [NSURL URLWithString:cell.model.videoUrl];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        DLog(@"返回按钮被点击");
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
        _cell = nil;
        DLog(@"播放完成");
    }];
}



#pragma mark-----------------底部按钮及其点击事件------------
- (void)createBottomView{
    UIView *bottomView= [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-49-kSafeBottomH, kScreenW, 49)];
    [self.view addSubview:bottomView];
    
    for (int i =0; i<2; i++) {
        anyButton *button =[anyButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*70, 0, 70, 49);
        [button setBackgroundColor:kBarBgColor];
        [bottomView addSubview:button];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button changeImageFrame:CGRectMake(23, 6, 22, 22)];
        [button changeTitleFrame:CGRectMake(0, 33, 70, kTitleBigSize)];
        button.titleLabel.font = [UIFont systemFontOfSize:kTextSize];
        button.tag = i;
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:{
                [button setImage:[UIImage imageNamed:@"icon_ShouCang"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_ShouCang_on"] forState:UIControlStateSelected];
                [button setTitle:@"收藏" forState:UIControlStateNormal];
                _faviteButton = button;
                
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(69, 17, 1, 25)];
                lineView.backgroundColor = kWhiteColor;
                [button addSubview:lineView];
            }
                break;
            case 1:
                [button setImage:[UIImage imageNamed:@"car_detail_KeFu"] forState:UIControlStateNormal];
                [button setTitle:@"客服" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    UIButton *rightButton = [UIButton newButtonWithTitle:@"立即预订" sel:@selector(bookingButtonClick) target:self cornerRadius:NO];
    rightButton.frame =CGRectMake(139, 0, kScreenW-139, 49);
    [bottomView addSubview:rightButton];
}

- (void)bookingButtonClick{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
        VFConfirmOrderViewController *vc = [[VFConfirmOrderViewController alloc]init];
        vc.model = _carDetailmodel;
        if (_freeDeposit) {
            vc.freeDeposit = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (void)bottomButtonClick:(UIButton *)sender{
    if (sender.tag == 0) {
        kWeakSelf;
        NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        if (tokenStr)
        {
            if (!sender.selected)
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [HttpManage favoriteCollectioCarWithCarId:weakSelf.carId withBlock:^(NSString *status) {
                        if ([status isEqualToString:@"1"])
                        {
                            [ProgressHUD showSuccess:@"已收藏"];
                            sender.selected = !sender.selected;
                        }
                        else
                        {
                            [ProgressHUD showError:@"收藏失败"];
                        }
                        
                    }];
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [HttpManage favoriteCollectioCarWithCarId:weakSelf.carId withBlock:^(NSString *status) {
                        if ([status isEqualToString:@"0"])
                        {
                            [ProgressHUD showSuccess:@"取消收藏"];
                            sender.selected = !sender.selected;
                        }
                        else
                        {
                            [ProgressHUD showError:@"取消失败"];
                        }
                        
                    }];
                });
            }
        }
        else
        {
            HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"请先登录，再收藏"];
            HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
                [alertCtrl dismissViewControllerAnimated:NO completion:nil];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                [weakSelf presentViewController:loginVC animated:YES completion:nil];
            }];
            [alertCtrl addAction:Action];
            [weakSelf presentViewController:alertCtrl animated:NO completion:nil];
        }
    }else{
        kWeakSelf;
        if([HChatClient sharedClient].isLoggedInBefore) {
            HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
            UINavigationController *chatNav=[[UINavigationController alloc]initWithRootViewController:chatVC];
            [weakSelf presentViewController:chatNav animated:YES completion:nil];
        }else{
            //未登录
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kHXUsernameAndPsw];
            if (dic) {
                VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:dic];
                HChatClient *client = [HChatClient sharedClient];
                [client loginWithUsername:model.username password:model.password];
            }else{
                [HttpManage getHxUserSuccessBlock:^(NSDictionary *data) {
                    VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:data];
                    [[NSUserDefaults standardUserDefaults]setObject:@{@"activated":model.activated,@"created":model.created,@"modified":model.modified,@"password":model.password,@"type":model.type,@"username":model.username,@"uuid":model.uuid} forKey:kHXUsernameAndPsw];
                    HChatClient *client = [HChatClient sharedClient];
                    HError *error = [client loginWithUsername:model.username password:model.password];
                    if (!error) { //登录成功
                        HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
                        [weakSelf.navigationController pushViewController:chatVC animated:YES];
                    } else { //登录失败
                        return;
                    }
                } withFailureBlock:^(NSError *error) {
                    
                }];
            }
        }
    }
}

- (void)loginViewControllerCallback{
    [self bookingButtonClick];
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
