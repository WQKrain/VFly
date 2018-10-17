//
//  HomeGroupedViewController.m
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/15.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "HomeGroupedViewController.h"
#import "CustomScrollView.h"
#import "HomeTableCell.h"
#import "WebViewVC.h"
#import "HomeCellHeaderView.h"
#import "HomeCollectionView.h"
#import "LoginViewController.h"
#import "VFCarDetailViewController.h"
#import "HCBnnerListModel.h"

#import "VIPViewController.h"
#import "PartnerViewController.h"

//获取免押金名额
#import "VFObtainPlacesViewController.h"

#import "RecentActivitiesModel.h"
#import "ActionListViewController.h"

#import "MessageNoticeViewController.h"

#import "TodayPreferentialModel.h"
#import "HotCarModel.h"
#import "GlobalConfigModel.h"
#import "LoginModel.h"
#import "ShowVipViewController.h"
//超值长租数据模型
#import "LongRentModel.h"

#import "VFEvaluationOrderViewController.h"
#import "VFLuxuryCarSuttleViewController.h" //豪车接送

#import "VFPayRemainingMoneyViewController.h"

#import "VFNoticeTableViewCell.h"
#import "VFSearchCarViewController.h"
#import "VFCarApplyViewController.h"

#import "VFChooseProvincesViewController.h"
#import "DriveTravelViewController.h"

#import "VFMessageCountModel.h"
#import "VFChooseCityModel.h"
#import "RentCarViewController.h"
#import "CityModel.h"
#import "HomeSelectCell.h"
#import "SDCycleScrollView.h"

#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HIGHT self.view.bounds.size.height

@interface HomeGroupedViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate, LoginViewControllerDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView; // tableView
@property (nonatomic, strong) NSMutableArray *tableDatasM; // 数据源
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *homeLowPriceData;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSArray *middleArr;
@property (nonatomic, strong) NSMutableArray *homeActivityData;

@property (nonatomic, strong) NSMutableArray *hotCarArr;;
@property (nonatomic, strong) UIButton *areaButton;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, assign) NSInteger timeLag;  // 时间差
@property (nonatomic, assign) BOOL isBegin;       // 是否开始倒计时
@property (nonatomic, strong) CustomScrollView *lunScroll;
@property (nonatomic, strong) NSTimer *countdownTimer;     //还有多久开始限时特惠

@property (nonatomic, assign) NSInteger countdown;//距离开始限时特惠的时间差
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, strong) NSMutableArray *actionArr;
@property (nonatomic, strong) UIView *navBackImageView;
@property (nonatomic, strong) NSString *messageCount;
@property (nonatomic, strong) UIButton *rightNavBtn;

@property (nonatomic, strong) UILabel *specilLabel;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UILabel *messageCountlabel;
@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, strong) UIImageView *lineImage;
@end

@implementation HomeGroupedViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadMessageCount];
    if (_needRefresh) {
        [self loadData];
    }
}
    
- (void)loadMessageCount{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (!token)
    {
        return;
    }
        //request_____用的到
        [VFHttpRequest messageUnreadParameter:nil successBlock:^(NSDictionary *data) {
                NSLog(@"request_____0");
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            if ([model.code intValue] == 1) {
                VFMessageCountListModel *obj = [[VFMessageCountListModel alloc]initWithDic:model.data];
                NSArray<HConversation *> *conversastions = [[HChatClient sharedClient].chatManager loadAllConversations];
            if (conversastions && conversastions.count>0) {
                HConversation *message = conversastions[0];
                if ([obj.wallet intValue]>0 || [obj.order intValue]>0 || message.unreadMessagesCount>0) {
                    _messageCountlabel.hidden = NO;
                }else{
                    _messageCountlabel.hidden = YES;
                }
            }
            else
            {
                if ([obj.wallet intValue]>0 || [obj.order intValue]>0)
                {
                    _messageCountlabel.hidden = NO;
                }
                else
                {
                    _messageCountlabel.hidden = YES;
                }
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)networkChanged:(id)info {
    NSDictionary *dic = (NSDictionary *)info;
    if ([dic[@"netType"] isEqualToString:kNotReachable])
    {
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"目前无网络连接哦"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
    else
    {
        [self loadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needRefresh = NO;
    self.UMPageStatistical = @"mainPage";
    _middleArr = [[NSArray alloc]init];
    _hotCarArr = [[NSMutableArray alloc]init];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [self createTabelHeaderView];
    self.tableView.tableFooterView = [self createFooterView];
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    if (cityID)
    {
        NSDictionary *cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
        VFNotificationCityModel *model = [[VFNotificationCityModel alloc]initWithDic:cityDic];
        self.areaName = model.countyName;
    }
    else
    {
        self.areaName = [NSString stringWithFormat:@"%@",@"拱墅区"];
        NSDictionary *dic = @{@"provinceName":@"浙江省",@"provinceID":@"933",@"cityID":@"934",@"cityName":@"杭州市",@"countyID":@"938",@"countyName":@"拱墅区"};
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:kLocalCity];
        [[NSUserDefaults standardUserDefaults]setObject:@"938" forKey:kLocalCityID];
    }
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.homeLowPriceData = [NSMutableArray array];
    self.homeActivityData = [NSMutableArray array];
    self.tableDatasM = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4"]];
    kWeakself;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create ();
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self openLocation];
        });
    });
    dispatch_group_notify(group, queue, ^{
        [weakSelf loadData];
    });
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf loadData];
        });
    }];
    
    //城市改变时接收通知
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(VFHomeChangeCity:) name:@"changeCity" object:nil];
}

#pragma mark -------------城市改变时更新数据--------------
- (void)VFHomeChangeCity:(NSNotification *)NSNotification{
    NSDictionary *dic = NSNotification.userInfo;
    VFNotificationCityModel *model = [[VFNotificationCityModel alloc]initWithDic:dic];
    [self.areaButton setTitle:model.countyName forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kLocalCity];
    [[ChangeCityTool changeCity] setValue:model.countyID forKey:@"city"];
    
    kWeakSelf;
    NSString *cityId = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    //热门车型
    //request_____有用的到
    [HttpManage getHomeHotCarWithCity:cityId withSuccessBlock:^(NSArray *data) {
        NSLog(@"request_____1");
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in data) {
            HotCarListModel *model = [[HotCarListModel alloc]initWithDic:dic];
            [tempArr addObject:model];
        }
        _hotCarArr = tempArr;
        [weakSelf.tableView reloadData];
    } withFailureBlock:^(NSString *result_msg) {
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableDatasM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3)
    {
        return _middleArr.count;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *tempArr = @[@"",@"热门车型",@"",@"活动资讯"];
    if (section == 3 || section == 1)
    {
        kWeakSelf;
        HomeCellHeaderView *headerV = [[HomeCellHeaderView alloc] initWithType:HomeCellHeaderTypeLabel UpperStr:tempArr[section] UnderStr:@""];
        headerV.showImage.image = [UIImage imageNamed:@"Group-6@2x"];
        
        if (section == 1)
        {
            UILabel *moreLabel = [[UILabel alloc]init];
            moreLabel.font = [UIFont systemFontOfSize:14];
            moreLabel.backgroundColor = [UIColor whiteColor];
            moreLabel.textAlignment = NSTextAlignmentRight;
            moreLabel.textColor = HexColor(0xABABAB);
            moreLabel.text = @"更多";
            [headerV addSubview:moreLabel];
            moreLabel.sd_layout
            .rightSpaceToView(headerV, 20)
            .topSpaceToView(headerV, 34)
            .widthIs(50)
            .heightIs(20);
            
            headerV.moreClickBlock = ^(NSInteger buttonTag){
                DriveTravelViewController *vc = [[DriveTravelViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        
        if (section == 3)
        {
            UILabel *moreLabel = [[UILabel alloc]init];
            moreLabel.font = [UIFont systemFontOfSize:14];
            moreLabel.backgroundColor = [UIColor whiteColor];
            moreLabel.textAlignment = NSTextAlignmentRight;
            moreLabel.textColor = HexColor(0xABABAB);
            moreLabel.text = @"更多";
            [headerV addSubview:moreLabel];
            moreLabel.sd_layout
            .rightSpaceToView(headerV, 20)
            .topSpaceToView(headerV, 34)
            .widthIs(50)
            .heightIs(20);
            
            headerV.moreClickBlock = ^(NSInteger buttonTag){
                //跳转到活动资讯界面
                ActionListViewController *vc = [[ActionListViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        return headerV;
    }
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view  = [[UIView alloc]init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kWeakself;
    static NSString *homeCellReuseID = @"kHomeCellReuseID";
    HomeTableCell *cell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeCellReuseID];
    HomeCollectionView *footerV = [[HomeCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/1.6*kPicZoom + 117)];
    if (0 == indexPath.section)
    {
        HomeSelectCell *selectCell = [tableView dequeueReusableCellWithIdentifier:@"HomeSelectCell"];
        if (selectCell == nil)
        {
            selectCell = [[HomeSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeSelectCell"];
        }
        selectCell.selectionStyle = UITableViewCellSelectionStyleNone;
        selectCell.touchUpBlock = ^(NSInteger a) {
            if (a == 0)
            {
                RentCarViewController *vc = [[RentCarViewController alloc]init];
                vc.secondVC = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (a == 1)
            {
                VFLuxuryCarSuttleViewController *vc = [[VFLuxuryCarSuttleViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else if (a == 2)
            {
                NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
                if (token)
                {
                    [self checkVip];
                }
                else
                {
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    [self presentViewController:loginVC animated:YES completion:nil];
                }
            }
            else if (a == 3)
            {
                NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
                if (token) {
                    VFCarApplyViewController *vc = [[VFCarApplyViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    LoginViewController *vc = [[LoginViewController alloc]init];
                    vc.delegate = self;
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }
        };
        
        return selectCell;
        

    }

    else if (1 == indexPath.section)
    {
        footerV.dataArray = self.hotCarArr;
        footerV.homeCollectionViewSelectedBlock = ^(NSIndexPath *homeIndexPath){
            TodayPreferentialListModel *model = weakSelf.hotCarArr[homeIndexPath.item];
            VFCarDetailViewController *detailView = [VFCarDetailViewController new];
            detailView.carId = model.carId;
            [weakSelf.navigationController pushViewController:detailView animated:YES];

        };
        [cell createHeader:nil Middle:nil Footer:footerV];
    }
    else if (2 == indexPath.section)
    {}
    else
    {
        VFNoticeTableViewCell *actionCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (actionCell == nil)
        {
            actionCell = [[VFNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        actionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        RecentActivitiesListModel *obj = _middleArr[indexPath.row];
        [actionCell.markImage sd_setImageWithURL:[NSURL URLWithString:obj.image]];
        actionCell.titeLabel.text = obj.title;
        actionCell.detailLabel.text = obj.actionDescription;
        NSString *time =[CustomTool changYearStr:obj.time];
        actionCell.timelabel.text = kFormat(@"活动时间:%@",time);
        return actionCell;
    }
    
    return cell;
}

    
- (void)loginViewControllerCallback{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
        VFCarApplyViewController *vc = [[VFCarApplyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3)
    {
        RecentActivitiesListModel *obj = _middleArr[indexPath.row];
        [self homeBananaChooseJump:obj.action url:obj.url];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0)
    {
        //根据偏移量来算出对应的 alpha 值
        CGFloat alpha = offsetY / 100;
        if (alpha <= 0)
        {
            alpha = 0;
        }
        //改变 View 的透明度
        self.lineImage.alpha = alpha;
    }
    else
    {
        self.lineImage.alpha = 0;
    }
}

#pragma mark 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    
}


- (void)checkVip {
    kWeakself;
    [JSFProgressHUD showHUDToView:self.view];
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (tokenStr) {
        //request_____
        [HttpManage getUserInfoWithToken:tokenStr withSuccessBlock:^(NSDictionary *dic) {
            NSLog(@"request_____2");
            [JSFProgressHUD hiddenHUD:self.view];
            LoginModel *model = [[LoginModel alloc]initWithDic:dic];
            if ([model.vipLevel isEqualToString:@"0"]) {
                VIPViewController *vc = [[VIPViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                ShowVipViewController *vc =[[ShowVipViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        } withFailedBlock:^{
            [JSFProgressHUD hiddenHUD:self.view];
            [ProgressHUD showError:@"加载失败"];
        }];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
}

- (void)checkPartner {
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token==nil)
    {
        PartnerViewController *vc = [[PartnerViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [JSFProgressHUD showHUDToView:self.view];
        //request_____
        [HttpManage checkIsSellerSuccess:^(NSDictionary *data) {
            NSLog(@"request_____3");
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
                    PartnerViewController *vc = [[PartnerViewController alloc]init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
            [JSFProgressHUD hiddenHUD:self.view];
        } failedBlock:^{
            [JSFProgressHUD hiddenHUD:self.view];
        }];
    }
}

- (void)actionJump:(UIButton *)sender {
    WebViewVC *vc= [WebViewVC new];
    RecentActivitiesListModel *obj = [[RecentActivitiesListModel alloc]initWithDic:_middleArr[sender.tag]];
    vc.urlStr = obj.url;
    vc.urlTitle = @"活动资讯";
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return kScreenW/750.0 * 180;
    }
    else if (1 == indexPath.section)
    {
        return kScreenW/1.6*kPicZoom + 117;
    }
    else if (3 == indexPath.section)
    {
        return (kScreenW-30)*6/13+141;
    }
    else
    {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 3)
    {
        return 69;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


#pragma mark - Location Delegate

//开始更新地理位置
- (void)openLocation {
    DISPATCH_QUEUE_PRIORITY_BACKGROUND;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    [self.locationManager requestWhenInUseAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}


// 代理方法，监听位置变化
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    kWeakself;
    //位置对象
    CLLocation *location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                       if (! error) {
                           if ([placemarks count] > 0) {
                               CLPlacemark *placemark = [placemarks firstObject];
                               // 获取城市
                               NSString *city = placemark.locality;
                               if (! city) {
                                   // 6
                                   city = placemark.administrativeArea;
                               }
                               [self searchCityProvince:placemark.administrativeArea Data:city area:placemark.subLocality];
                           }
                       } else{
                           NSDictionary *cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
                           VFNotificationCityModel *model = [[VFNotificationCityModel alloc]initWithDic:cityDic];
                           weakSelf.areaName = model.countyName;
                           [weakSelf.areaButton setTitle:self.areaName forState:UIControlStateNormal];
                       }
                       
                       
                   }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
}

- (void)searchCityProvince:(NSString *)province Data:(NSString *)city area:(NSString *)area{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area_mini" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray* dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    //此步骤取出所有的市
    NSString *provinceID = @"0";
    NSString *cityID = @"0";
    NSString *countyID=@"0";
    for (NSDictionary *temoCity in dataArr) {
        CityModel *model = [[CityModel alloc]initWithDic:temoCity];
        if ([model.name isEqualToString:province]) {
            provinceID = model.cityId;
            for (NSDictionary *cityDic in model.child) {
                CityModel *cityObj = [[CityModel alloc]initWithDic:cityDic];
                if ([cityObj.name isEqualToString:city]) {
                    cityID = cityObj.cityId;
                    for (NSDictionary *areaDic in cityObj.child) {
                        CityModel *areaObj = [[CityModel alloc]initWithDic:areaDic];
                        if ([areaObj.name isEqualToString:area]) {
                            countyID = areaObj.cityId;
                        }
                    }
                }
            }
        }
    }
    
    if ([provinceID intValue]>0) {
        NSDictionary *dic = @{@"provinceName":province,@"provinceID":provinceID,@"cityName":city,@"cityID":cityID,@"countyID":countyID,@"countyName":area};
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:kLocalCity];
        [[NSUserDefaults standardUserDefaults]setObject:countyID forKey:kLocalCityID];
        [self.areaButton setTitle:area forState:UIControlStateNormal];
        self.areaName = area;
    }else{
        [self.areaButton setTitle:area forState:UIControlStateNormal];
        self.areaName = area;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error) {
        NSDictionary *cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
        VFNotificationCityModel *model = [[VFNotificationCityModel alloc]initWithDic:cityDic];
        self.areaName = model.countyName;
        [self.areaButton setTitle:self.areaName forState:UIControlStateNormal];
        //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
        [self.locationManager stopUpdatingLocation];
    }else{
        
    }
}

#pragma mark - CityListView Delegate / Data Source

- (void)didClickedWithCityName:(NSString*)cityName
{
    [self.areaButton setTitle:cityName forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:kLocalCity];
    
    [[ChangeCityTool changeCity] setValue:cityName forKey:@"city"];
    
    kWeakself;
    //request_____
    [HttpManage getHomeHotCarWithCity:cityName withSuccessBlock:^(NSArray *data) {
        NSLog(@"request_____4");
        [weakSelf.tableView reloadData];
    } withFailureBlock:^(NSString *result_msg) {
        
    }];
}


#pragma mark - Private Methods

- (void)LimitedtimeOffersIsEndClickAction
{
    HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:@"敬请期待" message:@"活动时间为10:00～22:00"];
    HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
    [alertCtrl addAction:Action];
    [self presentViewController:alertCtrl animated:NO completion:nil];
}

- (void)openLocationService
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 10;
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        NSString *cityID = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
        if (cityID) {
            NSDictionary *cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
            VFNotificationCityModel *model = [[VFNotificationCityModel alloc]initWithDic:cityDic];
            self.areaName = model.countyName;
            [self.areaButton setTitle:self.areaName forState:UIControlStateNormal];
        }else {
            self.areaName = [NSString stringWithFormat:@"%@",@"拱墅区"];
            NSDictionary *dic = @{@"provinceName":@"浙江省",@"provinceID":@"933",@"cityID":@"934",@"cityName":@"杭州市",@"countyID":@"938",@"countyName":@"拱墅区"};
            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:kLocalCity];
            [[NSUserDefaults standardUserDefaults]setObject:@"938" forKey:kLocalCityID];
            self.areaName = @"拱墅区";
            [self.areaButton setTitle:self.areaName forState:UIControlStateNormal];
        }
    }
}


- (void)searchbuttonClick{
    VFSearchCarViewController *vc = [[VFSearchCarViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)callBtnAction
{
    MessageNoticeViewController *vc = [[MessageNoticeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)areaBtnAction
{
    VFChooseProvincesViewController *cityListView = [[VFChooseProvincesViewController alloc]init];
    [self.navigationController pushViewController:cityListView animated:YES];
}

- (UIView *)createFooterView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 39)];
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
    
    return footView;
}


- (UIView *)createTabelHeaderView {
    kWeakSelf;
     _tableHeaderView = [CustomTool createUIViewWithBackColor:kWhiteColor];
    // 获取banner图片
    NSInteger scale = [[[NSUserDefaults standardUserDefaults]objectForKey:Device] integerValue];
    if (scale==0) {
        scale=2;
    }
    
    // 自定义导航
    _navBackImageView = [[UIView alloc] init];
    _navBackImageView.userInteractionEnabled = YES;
    _navBackImageView.backgroundColor = RGBA(17, 17, 17, 0.05);
    kdetailColor;
    [_tableHeaderView addSubview:_navBackImageView];
    _navBackImageView.frame = CGRectMake(15, 0, kScreenW-30, 30);
    
//    _lunScroll = [[CustomScrollView alloc]initWithArr:self.headerArray WithHeight:kScreenW/15.0 * 8];
//    _lunScroll.frame = CGRectMake(0, 0, kScreenW, kScreenW/15.0 * 8);
//    _lunScroll.buttonClickBlock = ^(NSInteger tag){
//        [weakSelf homeBananaChooseJump:weakSelf.actionArr[tag-1] url:weakSelf.urlArr[tag-1]];
//    };
//    [_tableHeaderView addSubview:_lunScroll];
    
    
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/15.0 * 8) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    cycleView.imageURLStringsGroup = self.headerArray;
    cycleView.autoScrollTimeInterval = 3;
    [_tableHeaderView addSubview:cycleView];
    
//    SDCycleScrollView *cycleScrollView = [cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/15.0 * 8) delegate:self placeholderImage:placeholderImage];
//    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
    [cycleView addSubview:self.areaButton];

    self.areaButton.sd_layout
    .leftSpaceToView(cycleView, 20)
    .topSpaceToView(cycleView, 55)
    .minWidthIs(200)
    .heightIs(25);
    [self.areaButton setupAutoSizeWithHorizontalPadding:5 buttonHeight:25];
    

//-------------------消息栏
    _rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightNavBtn setImage:[UIImage imageNamed:@"home_icon_message"] forState:UIControlStateNormal];
    [_rightNavBtn.titleLabel setFont:[UIFont systemFontOfSize:kTextSize]];
    [_rightNavBtn addTarget:self action:@selector(callBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cycleView addSubview:_rightNavBtn];
    _rightNavBtn.sd_layout
    .rightSpaceToView(cycleView, 20)
    .topSpaceToView(cycleView, 50)
    .heightIs(50)
    .widthIs(50);
    
    _messageCountlabel = [[UILabel alloc]init];
    _messageCountlabel.backgroundColor = kMainColor;
    _messageCountlabel.layer.masksToBounds = YES;
    _messageCountlabel.layer.cornerRadius = 4;
    [_rightNavBtn addSubview:_messageCountlabel];
    _messageCountlabel.sd_layout
    .rightSpaceToView(_rightNavBtn, 10)
    .topSpaceToView(_rightNavBtn, 10)
    .heightIs(6)
    .widthIs(6);
    
    _messageCountlabel.hidden = YES;
    
    //-----------------
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"home_icon_search"] forState:UIControlStateNormal];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:kTextSize]];
    [searchButton addTarget:self action:@selector(searchbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [cycleView addSubview:searchButton];
    searchButton.sd_layout
    .rightSpaceToView(cycleView, 70)
    .topSpaceToView(cycleView, 50)
    .heightIs(50)
    .widthIs(50);
    
    
    
    
    
    _tableHeaderView.frame = CGRectMake(0, 0, kScreenW, kScreenW/15.0 * 8);
    
    return _tableHeaderView;
}

- (void)homeBananaChooseJump:(NSString *)action url:(NSString *)url{
    kWeakSelf;
    if ([action isEqualToString:@""]) {
        WebViewVC *webView = [WebViewVC new];
        NSString *str = url;
        webView.urlStr = str;
        webView.urlTitle = @"活动资讯";
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:webView animated:YES];
        });
    }else if ([action isEqualToString:@"vip"]){
        [weakSelf checkVip];
    }else if ([action isEqualToString:@"activity"]){
        WebViewVC *webView = [WebViewVC new];
        NSString *str = url;
        webView.urlStr = str;
        webView.urlTitle =  @"活动资讯";
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:webView animated:YES];
        });
    }
    else if([action isEqualToString:@"toCar"]){
        NSNotification *notification =[NSNotification notificationWithName:@"jumpRent" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if([action isEqualToString:@"toPartner"]){
        [weakSelf checkPartner];
    }
    else
    {
        WebViewVC *webView = [WebViewVC new];
        NSString *str = url;
        webView.urlStr = str;
        webView.urlTitle = @"活动资讯";
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:webView animated:YES];
        });
    }
    
    
}

- (void)loadData {
    kWeakself;
    //近期活动
    //request_____
    [HttpManage getActivityParameter:nil SuccessBlock:^(NSDictionary *data) {
        NSLog(@"request_____5");
        RecentActivitiesModel *model = [[RecentActivitiesModel alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.newsList) {
            RecentActivitiesListModel *model = [[RecentActivitiesListModel alloc]initWithDic:dic];
            [tempArr addObject:model];
        }
        weakSelf.middleArr = tempArr;
        [weakSelf.tableView reloadData];
        [_tableView.mj_header endRefreshing];
    } withFailureBlock:^(NSString *result_msg) {
        weakSelf.needRefresh = YES;
        [_tableView.mj_header endRefreshing];
    }];
    
    NSString *cityId = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCityID];
    //热门车型
    //request_____
    [HttpManage getHomeHotCarWithCity:cityId withSuccessBlock:^(NSArray *data) {
        NSLog(@"request_____6");
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in data) {
            HotCarListModel *model = [[HotCarListModel alloc]initWithDic:dic];
            [tempArr addObject:model];
        }
        _hotCarArr = tempArr;
         [weakSelf.tableView reloadData];
    } withFailureBlock:^(NSString *result_msg) {
        
    }];
    
    // 请求轮播图 待处理
    //request_____
    [HttpManage getBannerSuccess:^(NSArray *data) {
        NSLog(@"request_____7 %@",data);
        NSMutableArray *imageArr = [NSMutableArray array];
        _urlArr = [[NSMutableArray alloc]init];
        _actionArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic  in data) {
            HCBnnerListModel *obj = [[HCBnnerListModel alloc]initWithDic:dic];
            [imageArr addObject:obj.image];
            [_urlArr addObject:obj.url];
            [_actionArr addObject:obj.action];
        }
        if (imageArr.count == 0) {
            NSMutableArray *bannerList = [[NSUserDefaults standardUserDefaults] objectForKey:@"bnnerList"];
            _headerArray = bannerList;
            [self.tableView.tableHeaderView removeFromSuperview];
            self.tableView.tableHeaderView = [self createTabelHeaderView];
        }else{
            _headerArray = imageArr;
            [[NSUserDefaults standardUserDefaults] setObject:_actionArr forKey:@"bnnerList"];
            [self.tableView.tableHeaderView removeFromSuperview];
            self.tableView.tableHeaderView = [self createTabelHeaderView];
        }
    } failedBlock:^{
        [CustomTool alertViewShow:@"请检查网络哦"];
        NSMutableArray *bannerList = [[NSUserDefaults standardUserDefaults] objectForKey:@"bnnerList"];
        _headerArray = bannerList;
        [self.tableView.tableHeaderView removeFromSuperview];
        self.tableView.tableHeaderView = [self createTabelHeaderView];
    }];

}


- (void)theCountdownAction{
    _countdown--;
    if (_countdown == 0) {
        [_countdownTimer invalidate];
        _countdownTimer = nil;

    }
}
#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[VFNoticeTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[HomeSelectCell class] forCellReuseIdentifier:@"HomeSelectCell"];
    }
    return _tableView;
}

- (NSMutableArray *)headerArray {
    if (!_headerArray)
    {
        _headerArray = [NSMutableArray array];
    }
    return _headerArray;
}

- (UIButton *)areaButton {
    if (!_areaButton)
    {
        _areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _areaButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_areaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_areaButton setTitle:self.areaName forState:UIControlStateNormal];
        [_areaButton addTarget:self action:@selector(areaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areaButton;
}



@end
