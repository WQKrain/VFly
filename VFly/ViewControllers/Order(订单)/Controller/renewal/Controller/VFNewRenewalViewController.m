//
//  VFNewRenewalViewController.m
//  VFly
//
//  Created by Hcar on 2018/4/18.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFNewRenewalViewController.h"
#import "VFOrderDetailModel.h"
#import "TXTimeChoose.h"
#import "VFRenewMapModel.h"
#import "VFRenewalChosseDaysViewController.h"
#import "VFPayMoneyDetailViewController.h"
#import "VFRenewPayDetailModel.h"
#import "VFChoosePayViewController.h"
#import "VFRenewApplyModel.h"

@interface VFNewRenewalViewController ()<TXTimeDelegate,VFRenewalChooseRentDaysDeleaget>
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) UIView *carDetailView;
@property (nonatomic , strong) UILabel *priceLabel;
@property (nonatomic , strong) UILabel *rentTime;
@property (nonatomic , strong) UILabel *backTime;
@property (nonatomic , strong) UILabel *rentClock;
@property (nonatomic , strong) UILabel *backClock;

@property (nonatomic , strong) UIImageView *carImage;
@property (nonatomic , strong) UILabel *carLabel;


@property (nonatomic , strong) UIView *rentCarTimeView;
@property (nonatomic , strong) UILabel *rentDaylabel;

@property (nonatomic , strong) VFOrderDetailModel *detailObj;
@property (nonatomic , strong) VFRenewPayDetailModel *payModel;


@property (nonatomic, strong) TXTimeChoose *timeV;

@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UILabel *allMoneylabel;
@property (nonatomic, strong) VFRenewMapModel *renewMapModel;
@property (nonatomic, strong) NSString *renewDays;

@end

@implementation VFNewRenewalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"续租";
    if (_canPay) {
        [self loadRentalDetail];
    }else{
        [self loadData];
    }
}

- (void)loadRentalDetail{
    kWeakSelf;
    [JSFProgressHUD showHUDToView:self.view];
    [VFHttpRequest getorderRenewDetailOrderID:_orderID successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        _payModel = [[VFRenewPayDetailModel alloc]initWithDic:model.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf createDetailView];
        });
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
    }];
}

- (void)loadData{
    [JSFProgressHUD showHUDToView:self.view];
    kWeakSelf;
    [VFHttpRequest getOrderDetailParameter:self.orderID SuccessBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        _detailObj = [[VFOrderDetailModel alloc]initWithDic:model.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf createDetailView];
        });
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
    }];
    
}


- (void)createDetailView{
    if (!_canPay) {
        _renewDays = @"3";
        [self createView];
        [self createCarDetailView];
        [self createRentCarTimeView];
        [_carImage sd_setImageWithURL:[NSURL URLWithString:_detailObj.car_img] placeholderImage:[UIImage imageNamed:@"place_holer_750x500"]];
        _carLabel.text = kFormat(@"%@%@",_detailObj.brand, _detailObj.model);
        _priceLabel.text = kFormat(@"¥%@元/天", _detailObj.re_day_rental);
        [self calculateAllmoneyDay:_renewDays];
    }
    
    if (_payModel) {
        _renewDays = _payModel.days;
        [self createView];
        [self createCarDetailView];
        [self createRentCarTimeView];
        VFRenewPayDetailCarModel *modle = [[VFRenewPayDetailCarModel alloc]initWithDic:_payModel.car];
        [_carImage sd_setImageWithURL:[NSURL URLWithString:modle.img] placeholderImage:[UIImage imageNamed:@"place_holer_750x500"]];
        _carLabel.text = kFormat(@"%@%@",modle.brand, modle.model);
        //wqk
        _priceLabel.text = kFormat(@"¥%@元/天", _payModel.re_day_rental);
        _allMoneylabel.text = kFormat(@"预估总金额  ¥%d", [_payModel.re_day_rental intValue]*[_renewDays intValue]);
        NSString *contentStr = @"¥";
        NSRange range = [_allMoneylabel.text rangeOfString:contentStr];
        [CustomTool setTextColor:_allMoneylabel FontNumber:[UIFont systemFontOfSize:kTitleSize] AndRange:range AndColor:kdetailColor];
        [_scrollView setUserInteractionEnabled:NO];
    }
}


- (void)calculateAllmoneyDay:(NSString *)days{
    _rentDaylabel.text = kFormat(@"%@天", _renewDays);
    _renewDays = days;
    int allMoney = [_detailObj.re_day_rental intValue] *[days intValue];
    _allMoneylabel.text = kFormat(@"预估总金额  ¥%d", allMoney);
    NSString *contentStr = @"¥";
    NSRange range = [_allMoneylabel.text rangeOfString:contentStr];
    [CustomTool setTextColor:_allMoneylabel FontNumber:[UIFont systemFontOfSize:kTitleSize] AndRange:range AndColor:kdetailColor];
}

- (void)createView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHeaderH, kScreenW, kScreenH-kHeaderH-50)];
    self.scrollView.contentSize = CGSizeMake(0, 500);
    [self.view addSubview:_scrollView];
    
    UIButton *applybutton = [UIButton newButtonWithTitle:@"续租支付"  sel:@selector(applyButtonClcik) target:self cornerRadius:NO];
    applybutton.frame = CGRectMake(0, kScreenH-49-kSafeBottomH, kScreenW, 49);
    [self.view addSubview:applybutton];
}

- (void)applyButtonClcik{
    if (_canPay) {
        VFChoosePayViewController *vc =[[VFChoosePayViewController alloc]init];
        vc.orderID = _orderID;
        vc.moneyType = _payModel.should_pay_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [JSFProgressHUD showHUDToView:self.view];
        NSDictionary *dic = @{@"days":_renewDays,@"remark":_remarkTextField.text};
        [VFHttpRequest orderRenewApplyParameter:dic orderID:self.orderID SuccessBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            VFBaseMode *obj = [[VFBaseMode alloc]initWithDic:data];
            NSLog(@"==================================================%@",obj.message);
            VFRenewApplyModel *model = [[VFRenewApplyModel alloc]initWithDic:obj.data];
            VFChoosePayViewController *vc =[[VFChoosePayViewController alloc]init];
            vc.orderID = model.order_id;
            vc.moneyType = model.should_pay_id;
            [self.navigationController pushViewController:vc animated:YES];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];

        }];
    }
}


- (void)createCarDetailView{
    _carDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 135)];
    [_scrollView addSubview:_carDetailView];
    
    _carImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 30, 100, 75)];
    [_carDetailView addSubview:_carImage];
    
    _carLabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kdetailColor];
    _carLabel.frame = CGRectMake(_carImage.right + 15, 30, 200, kTextBigSize);
    [_carDetailView addSubview:_carLabel];
    
    _priceLabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kNewSelectColor];
    _priceLabel.frame = CGRectMake(_carImage.right + 15, _carLabel.bottom+15, 200, kTextBigSize);
    [_carDetailView addSubview:_priceLabel];
}

- (void)createRentCarTimeView{
    _rentCarTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, _carDetailView.bottom, kScreenW, 149+84)];
    [_scrollView addSubview:_rentCarTimeView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 69)];
    [_rentCarTimeView addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"image_day"];
    [topView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(48);
    }];
    
    _rentDaylabel = [UILabel initWithTitle:_renewDays withFont:kTextSize textColor:kdetailColor];
    _rentDaylabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_rentDaylabel];
    [_rentDaylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *timeTitle = [UILabel initWithTitle:@"取车时间" withFont:kTextSize textColor:kdetailColor];
    timeTitle.frame = CGRectMake(15, 0, 100, kTextSize);
    [_rentCarTimeView addSubview:timeTitle];
    
    UILabel *rightTimeTitle = [UILabel initWithTitle:@"还车时间" withFont:kTextSize textColor:kdetailColor];
    rightTimeTitle.frame = CGRectMake(kScreenW-115, 0, 100, kTextSize);
    rightTimeTitle.textAlignment = NSTextAlignmentRight;
    [_rentCarTimeView addSubview:rightTimeTitle];
    
    
    //    NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
    //    late1  = late1 + 1800;
    //    NSTimeInterval late2= late1+86400;
    //    NSDateFormatter *dated=[[NSDateFormatter alloc] init];
    //    [dated setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    //    NSString *leftStr = [dated stringFromDate:[NSDate dateWithTimeIntervalSince1970:late1]];
    //    NSString *rightStr = [dated stringFromDate:[NSDate dateWithTimeIntervalSince1970:late2]];
    //
    //    NSString *leftTime = [leftStr substringToIndex:11];
    //    NSString *rightTime = [rightStr substringToIndex:11];
    //
    //    NSString *leftClock = [leftStr substringFromIndex:leftStr.length- 5];
    //    NSString *rightClock = [rightStr substringFromIndex:rightStr.length- 5];
    
    
    //获取还车时间
    NSTimeInterval late1;
    if (_detailObj) {
        late1 = [_detailObj.end_date doubleValue];
    }else{
        late1 = [_payModel.start_date doubleValue];
    }
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSMinuteCalendarUnit fromDate:[NSDate dateWithTimeIntervalSince1970:late1]];
    NSTimeInterval late2;
    if (_detailObj) {
        late2 = late1+86400*3;
    }else{
        late2 = [_payModel.end_date doubleValue];
    }
    
    NSDateFormatter *dated=[[NSDateFormatter alloc] init];
    [dated setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSString *leftStr = [dated stringFromDate:[NSDate dateWithTimeIntervalSince1970:late1]];
    NSString *rightStr = [dated stringFromDate:[NSDate dateWithTimeIntervalSince1970:late2]];
    
    NSString *leftTime = [leftStr substringToIndex:11];
    NSString *rightTime = [rightStr substringToIndex:11];
    
    NSString *leftClock = [leftStr substringFromIndex:leftStr.length- 5];
    NSString *rightClock = [rightStr substringFromIndex:rightStr.length- 5];
    
    
    
    _rentTime = [UILabel initWithTitle:leftTime withFont:kTextBigSize textColor:kdetailColor];
    _rentTime.frame = CGRectMake(15, timeTitle.bottom+10, 150, kTextBigSize);
    [_rentCarTimeView addSubview:_rentTime];
    
    _backTime = [UILabel initWithTitle:rightTime withFont:kTextBigSize textColor:kdetailColor];
    _backTime.frame = CGRectMake(kScreenW-165, rightTimeTitle.bottom+10, 150, kTextBigSize);
    _backTime.textAlignment = NSTextAlignmentRight;
    [_rentCarTimeView addSubview:_backTime];
    
    _rentClock = [UILabel initWithTitle:leftClock withFont:kTextBigSize textColor:kdetailColor];
    _rentClock.frame = CGRectMake(15, _rentTime.bottom+15, 150, kTextBigSize);
    [_rentCarTimeView addSubview:_rentClock];
    
    _backClock = [UILabel initWithTitle:rightClock withFont:kTextBigSize textColor:kdetailColor];
    _backClock.frame = CGRectMake(kScreenW-165, _backTime.bottom+15, 150, kTextBigSize);
    _backClock.textAlignment = NSTextAlignmentRight;
    [_rentCarTimeView addSubview:_backClock];
    
    UIButton *backTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backTimeButton.frame = CGRectMake(kScreenW-(kScreenW-68)/2, 0, (kScreenW-68)/2, 69);
    backTimeButton.tag = 1001;
    [backTimeButton addTarget:self action:@selector(chooseTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_rentCarTimeView addSubview:backTimeButton];
    
    UIButton *chooseDaysButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseDaysButton.frame = CGRectMake((kScreenW-68)/2, 0, 68, 69);
    chooseDaysButton.tag = 1002;
    [chooseDaysButton addTarget:self action:@selector(chooseTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_rentCarTimeView addSubview:chooseDaysButton];
    
    UILabel *remarkLabel = [UILabel initWithTitle:@"其他备注" withFont:kTitleBigSize textColor:kdetailColor];
    remarkLabel.frame = CGRectMake(15, _backClock.bottom+30, 80, kTitleBigSize);
    [_rentCarTimeView addSubview:remarkLabel];
    
    _remarkTextField = [[UITextField alloc]initWithFrame:CGRectMake(95, _backClock.bottom, kScreenW-110, 76)];
    _remarkTextField.placeholder = @"请输入其他要求";
    _remarkTextField.font = [UIFont systemFontOfSize:kTitleBigSize];
    _remarkTextField.textAlignment = NSTextAlignmentRight;
    [_rentCarTimeView addSubview:_remarkTextField];
    
    UIView *linView = [[UIView alloc]initWithFrame:CGRectMake(15, 148, kScreenW-30, 1)];
    linView.backgroundColor = klineColor;
    [_rentCarTimeView addSubview:linView];
    
    _allMoneylabel = [UILabel initWithTitle:@"合计" withFont:kNewTitle textColor:kdetailColor];
    _allMoneylabel.frame = CGRectMake(15, linView.bottom+30, kScreenW-30, kNewTitle);
    [_rentCarTimeView addSubview:_allMoneylabel];
    
    UILabel *monryDetail = [UILabel initWithTitle:@"点击查看付款明细" withFont:kTextSize textColor:kTextBlueColor];
    monryDetail.frame = CGRectMake(15, _allMoneylabel.bottom+10, kScreenW-30, kTextSize);
    [_rentCarTimeView addSubview:monryDetail];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, linView.bottom, kScreenW, 106);
    [button addTarget:self action:@selector(payMoneyDetail) forControlEvents:UIControlEventTouchUpInside];
    [_rentCarTimeView addSubview:button];
    
}

- (void)payMoneyDetail{
    int day = [_renewDays intValue];
    int allMoney = [_renewMapModel.dayRental intValue] *day;
    float vipZK = allMoney *[_renewMapModel.vipZk floatValue];
    
    float vipZKmoney = allMoney *(1- [_renewMapModel.vipZk floatValue]);
    
    float longRentZKMoney = 0;
    float rentMoney = 0;
    for (NSDictionary *dic in _renewMapModel.level) {
        VFRenewMapLevelModel *model = [[VFRenewMapLevelModel alloc]initWithDic:dic];
        if (day >=[model.minDay intValue] && day <=[model.maxDay intValue]) {
            longRentZKMoney = vipZK *(1- [model.zk floatValue]);
            rentMoney = vipZK *[model.zk floatValue];
        }
    }
    
    VFPayMoneyDetailViewController *vc = [[VFPayMoneyDetailViewController alloc]init];
    vc.type = @"3";
    vc.allRentMoney = kFormat(@"%d", allMoney);
    vc.rentMoney = kFormat(@"%.2f", rentMoney);
    vc.vipZK = kFormat(@"%.2f", vipZKmoney);
    vc.longRentZK = kFormat(@"%.2f", longRentZKMoney);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseTimeBtn:(UIButton *)sender{
    if (sender.tag == 1001) {
        self.timeV = nil;
        [self.view addSubview:self.timeV];
        NSString *endStr = [NSString stringWithFormat:@"%@ %@",_backTime.text,_backClock.text];
        [self.timeV setNowTime:endStr];
    }else{
        //wqk
        VFRenewalChosseDaysViewController *vc =[[VFRenewalChosseDaysViewController alloc]init];
        vc.delegate = self;
        vc.dataModel = _renewMapModel;
        vc.rentDays = _renewDays;
        vc.detailObj = _detailObj;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark ----------------选择天数回来的代理方法----------------
- (void)chooseRentDays:(NSString *)days{
    
    NSString *startStr = [NSString stringWithFormat:@"%@ %@",_rentTime.text,_rentClock.text];
    NSDateFormatter *dateM=[[NSDateFormatter alloc] init];
    [dateM setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate *data=[dateM dateFromString:startStr];
    NSTimeInterval late=[data timeIntervalSince1970];
    
    NSTimeInterval backLate = late +[days intValue]*86400;
    NSString *time = [CustomTool changTimeStr:kFormat(@"%fd", backLate) formatter:@"yyyy年MM月dd日 HH:mm"];
    _backTime.text = [time substringToIndex:11];
    _backClock.text =_rentClock.text;
    
    self.renewDays = days;
    [self calculateAllmoneyDay:days];
}

//懒加载
- (TXTimeChoose *)timeV{
    
    if (!_timeV) {
        self.timeV = [[TXTimeChoose alloc]initWithFrame:self.view.bounds type:UIDatePickerModeDateAndTime tag:1001];
        self.timeV.delegate = self;
    }
    return _timeV;
}

#pragma mark--------TXTimeDelegate-------------
//当时间改变时触发
- (void)changeTime:(NSDate *)date
{
    
}

//确定时间
- (void)determine:(NSDate *)date
{
    NSString *getStr = [self.timeV stringFromDate:date];
    NSDateFormatter *dateM=[[NSDateFormatter alloc] init];
    [dateM setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSTimeInterval late1;
    NSTimeInterval late2;
    
    NSDate *d1=[dateM dateFromString:getStr];
    late1=[d1 timeIntervalSince1970];
    NSString *startTime = [CustomTool toDateChangTimeStr:[NSString stringWithFormat:@"%@ %@",_rentTime.text,_rentClock.text] formatter:@"yyyy年MM月dd日 HH:mm"];
    late2= startTime.doubleValue ;
    if (late1-late2>=86400) {
        _backTime.text = [getStr substringToIndex:11];
        _backClock.text = _rentClock.text;
        long days = (late1-late2)/86400;
        _rentDaylabel.text = kFormat(@"%ld天", days);
        [self calculateAllmoneyDay:kFormat(@"%ld", days)];
    }
}

#pragma mark------时间差转换成字符串-----
- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    //    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    //    dateString1=[timeArray1 objectAtIndex:0];
    //
    //    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    //    dateString2=[timeArray2 objectAtIndex:0];
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSDate *d1=[date dateFromString:dateString1];
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    NSDate *d2=[date dateFromString:dateString2];
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *day=@"";
    NSString *house=@"";
    NSString *min=@"";
    //    分
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    min=[NSString stringWithFormat:@"%@", min];
    //    小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600%24];
    house=[NSString stringWithFormat:@"%@", house];
    //    天
    day = [NSString stringWithFormat:@"%d", (int)cha/3600/24];
    day =[NSString stringWithFormat:@"%@", day];
    
    if ([min integerValue]<0||[house integerValue]<0||[day integerValue]<0) {
        
        HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:@"提示" message:@"结束时间不能小于开始时间！"];
        HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:nil];
        [alertCtrl addAction:Action];
        [self presentViewController:alertCtrl animated:NO completion:nil];
        
        return timeString;
        
    }
    
    if ([day isEqualToString:@"0"]) {
        
        timeString=[NSString stringWithFormat:@"%@小时%@分钟",house,min];
        if ([house isEqualToString:@"0"]) {
            timeString=[NSString stringWithFormat:@"%@分钟",min];
        }
    }else{
        timeString=[NSString stringWithFormat:@"%@天%@小时%@分钟",day,house,min];
        if ([house isEqualToString:@"0"]) {
            timeString=[NSString stringWithFormat:@"%@天%@分钟",day,min];
            if ([min isEqualToString:@"0"]) {
                timeString=[NSString stringWithFormat:@"%@天",day];
            }
        }else if ([min isEqualToString:@"0"]) {
            timeString=[NSString stringWithFormat:@"%@天%@小时",day,house];
        }
    }
    //判断天数
    if ([day integerValue] == 0) {
        timeString = @"1";
    } else
    {
        //判断小时数是否超过12小时
        if (([house integerValue]/4) >= 1) {
            day = [NSString stringWithFormat:@"%ld",[day integerValue]+1];
        }
        timeString = day;
    }
    return timeString;
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
