//
//  VFOrderListTableViewCell.m
//  VFly
//
//  Created by Hcar on 2018/4/16.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFOrderListTableViewCell.h"
#import "VFOrderListModel.h"
#import "VFOrderDetailModel.h"
#define cellHeight 402
#define cellNoShadowHeight 387
@interface VFOrderListTableViewCell()
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *evaluationButton;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *backCarButton;
@property (nonatomic, strong) UIView *grayView;

@property (nonatomic , strong)UILabel *orderIDlabel;
@property (nonatomic , strong)UILabel *carName;
@property (nonatomic , strong)UILabel *pricelabel;
@property (nonatomic , strong)UILabel *rentDatelabel;
@property (nonatomic , strong)UILabel *backDatelabel;
@property (nonatomic , strong)UILabel *rentTimelabel;
@property (nonatomic , strong)UILabel *backTimelabel;
@property (nonatomic , strong)UILabel *rentCityLabel;
@property (nonatomic , strong)UILabel *backCityLabel;
@property (nonatomic , strong)UILabel *rentDayLabel;
@property (nonatomic , strong)UIButton *cancleButton;
@property (nonatomic , strong)UIButton *sureButton;
@property (nonatomic , strong)UILabel * orderStatelabel;
@property (nonatomic , strong)UIImageView *dayImage;
@property (nonatomic , strong)UIImageView *bgImageView;
@property (nonatomic , strong)UIImageView *carImage;


@end

@implementation VFOrderListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
    
}

- (void)createView{
    
    _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_background_ZiJia_long"]];
    _bgImageView.frame = CGRectMake(8, 0, kScreenW-16, cellHeight);
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    
    _grayView = [[UIView alloc]initWithFrame:CGRectMake(7, 7, kScreenW-30, cellNoShadowHeight)];
    [_bgImageView addSubview:_grayView];
    
    //    显示订单号
    UILabel *orderlabel = [UILabel initWithTitle:@"订单编号" withFont:kTextSize textColor:kNewDetailColor];
    orderlabel.frame= CGRectMake(10, 0, 50, 33);
    [_grayView addSubview:orderlabel];
    
    //订单号
    _orderIDlabel = [UILabel initWithFont:kTextSize textColor:kNewDetailColor];
    _orderIDlabel.frame =CGRectMake(orderlabel.right, 0, _grayView.height - 110, 33);
    [_grayView addSubview:_orderIDlabel];
    
    //显示订单状态
    _orderStatelabel = [UILabel initWithFont:kTextSize textColor:kMainColor];
    [_orderStatelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextSize]];
    _orderStatelabel.textAlignment = NSTextAlignmentRight;
    _orderStatelabel.frame = CGRectMake(_grayView.width-160, 0, 150, 33);
    [_grayView addSubview:_orderStatelabel];
    
    //订单号下边的线
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, _grayView.width-20, 1)];
    topLineView.backgroundColor = kNewLineColor;
    [_grayView addSubview:topLineView];
    
    //车辆的展示图片
    _carImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, topLineView.bottom+15, 100, 75)];
    _carImage.image = [UIImage imageNamed:@"place_holer_750x500"];
    [_grayView addSubview:_carImage];
    
    //展示车辆品牌
    _carName = [[UILabel alloc]initWithFrame:CGRectMake(_carImage.right+15, topLineView.bottom+20, _grayView.width-100-65, 14)];
    _carName.textColor = kNewTitleColor;
    _carName.font = [UIFont systemFontOfSize:kTextBigSize];
    [_grayView addSubview:_carName];
    
    //价格
    _pricelabel = [UILabel initWithFont:kTextBigSize textColor:kMainColor];
    _pricelabel.frame = CGRectMake(_carImage.right+15, _carName.bottom+10, _grayView.width-65, 14);
    [_grayView addSubview:_pricelabel];
    
    //显示时间的view
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, _carImage.bottom+15, kScreenW-30, 111)];
    timeView.backgroundColor = kViewBgColor;
    [_grayView addSubview:timeView];
    
    //租车时间
    UILabel *rentTime = [UILabel initWithTitle:@"租车时间" withFont:kTextSize textColor:kNewDetailColor];
    rentTime.frame= CGRectMake(10, 17, 60, 17);
    [timeView addSubview:rentTime];
    
    //还车时间
    UILabel *backTime = [UILabel initWithTitle:@"还车时间" withFont:kTextSize textColor:kNewDetailColor];
    backTime.frame = CGRectMake(timeView.width-80, 17, 70, 17);
    backTime.textAlignment = NSTextAlignmentRight;
    [timeView addSubview:backTime];
    
    //租车日期
    _rentDatelabel = [UILabel initWithFont:kTitleBigSize textColor:kTitleBoldColor];
    [_rentDatelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    _rentDatelabel.frame= CGRectMake(10, rentTime.bottom+13, _grayView.width-65, 22);
    [timeView addSubview:_rentDatelabel];
    
    //还车日期
    _backDatelabel = [UILabel initWithFont:kTitleBigSize textColor:kTitleBoldColor];
    _backDatelabel.frame = CGRectMake(_grayView.width-110, _rentDatelabel.top, 100, 22);
    [_backDatelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    _backDatelabel.textAlignment = NSTextAlignmentRight;
    [timeView addSubview:_backDatelabel];
    
    //租车具体时间
    _rentTimelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _rentDatelabel.bottom, 60, 22)];
    _rentTimelabel.textColor = kdetailColor;
    _rentTimelabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [timeView addSubview:_rentTimelabel];
    
    //还车具体时间
    _backTimelabel = [[UILabel alloc]initWithFrame:CGRectMake(_grayView.width-80, _rentTimelabel.top, 70, 22)];
    _backTimelabel.textAlignment = NSTextAlignmentRight;
    _backTimelabel.textColor = kdetailColor;
    _backTimelabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    [timeView addSubview:_backTimelabel];
    
    //显示天数的imageView
    _dayImage = [[UIImageView alloc]init];
    _dayImage.image = [UIImage imageNamed:@"image_day"];
    [timeView addSubview:_dayImage];
    [_dayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(timeView);
        make.width.mas_offset(68);
        make.height.mas_equalTo(48);
    }];
    
    //显示用车天数的label
    _rentDayLabel = [UILabel initWithTitle:@"" withFont:kTextSize textColor:kTextBlueColor];
    _rentDayLabel.textAlignment = NSTextAlignmentCenter;
    [timeView addSubview:_rentDayLabel];
    [_rentDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(timeView);
        make.width.mas_offset(68);
        make.height.mas_equalTo(48);
    }];
    
    //租车城市
    UILabel *rentCity = [[UILabel alloc]initWithFrame:CGRectMake(10, timeView.bottom+17, 60, 17)];
    rentCity.textColor = kNewDetailColor;
    rentCity.text = @"租车城市";
    rentCity.font = [UIFont systemFontOfSize:kTextBigSize];
    [_grayView addSubview:rentCity];
    
    //用户选择租车城市
    _rentCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, rentCity.top, _grayView.width-100, 18)];
    _rentCityLabel.textAlignment = NSTextAlignmentRight;
    [_rentCityLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
    _rentCityLabel.textColor = kNewTitleColor;
    [_grayView addSubview:_rentCityLabel];
    
    //还车城市
    UILabel *backCity = [[UILabel alloc]initWithFrame:CGRectMake(10, rentCity.bottom+10, 60, 18)];
    backCity.textColor = kNewDetailColor;
    backCity.text = @"还车城市";
    backCity.font = [UIFont systemFontOfSize:kTextBigSize];
    [_grayView addSubview:backCity];
    
    //用户选择还车城市
    _backCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, backCity.top, _grayView.width-100, 18)];
    _backCityLabel.textAlignment = NSTextAlignmentRight;
    _backCityLabel.textColor = kNewTitleColor;
    [_backCityLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
    [_grayView addSubview:_backCityLabel];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _backCityLabel.bottom+17, kScreenW, 55)];
    [_grayView addSubview:_bottomView];
    
    //下边的分割线
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, _grayView.width-20, 1)];
    bottomLineView.backgroundColor = kNewLineColor;
    [_bottomView addSubview:bottomLineView];
    
    //右下角左边的按钮
    NSArray *tempArr = @[@"删除",@"支付",@"续租",@"还车",@"评论"];
    for (int i= 0; i<5; i++) {
        UIButton *button;
        if (i==0) {
            button = [UIButton buttonWithTitle:tempArr[i]];
            [button setTitleColor:kMainColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            button = [UIButton newButtonWithTitle:tempArr[i] sel:@selector(buttonClick:) target:self cornerRadius:NO];
        }
        [_bottomView addSubview:button];
        button.tag = i;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.right.mas_equalTo(-40);
            }else{
                make.right.equalTo(_selectButton.mas_left).offset(-10);
            }
            make.top.mas_equalTo(15);
            make.width.mas_equalTo(kSpaceW(67));
            make.height.mas_equalTo(30);
        }];
        _selectButton = button;
        switch (i) {
            case 0:
                _deleteButton = button;
                break;
            case 1:
                _payButton = button;
                break;
            case 2:
                _continueButton = button;
                break;
            case 3:
                _backCarButton = button;
                break;
            case 4:
                _evaluationButton = button;
                break;
            default:
                break;
        }
    }
}

- (void)setDetailModel:(VFOrderDetailModel *)detailModel{
    self.orderIDlabel.text =  detailModel.order_id;
    [self.carImage sd_setImageWithURL:[NSURL URLWithString:detailModel.car_img] placeholderImage:[UIImage imageNamed:@"place_holer_750x500"]];

    self.carName.text = kFormat(@"%@%@", detailModel.brand?detailModel.brand:@"",detailModel.model?detailModel.model:@"");
    
    self.pricelabel.text = kFormat(@"¥%@元", detailModel.re_day_rental ?detailModel.re_day_rental:@"");
    
    self.rentDatelabel.text = [NSString stringWithFormat:@"%@ %@",[CustomTool changDayStr:detailModel.start_date],[CustomTool changWeekStr:detailModel.start_date]];
    self.backDatelabel.text = [NSString stringWithFormat:@"%@ %@",[CustomTool changDayStr:detailModel.end_date],[CustomTool changWeekStr:detailModel.end_date]];
    self.rentTimelabel.text = [CustomTool changHoursStr:detailModel.start_date];
    self.backTimelabel.text = [CustomTool changHoursStr:detailModel.end_date];
    self.rentCityLabel.text = detailModel.get_city;
    self.backCityLabel.text = detailModel.return_city;
    self.rentDayLabel.text = kFormat(@"%@天", detailModel.rental_days);
//    self.orderStatelabel.text = [CustomTool orderState:detailModel.status];
    self.orderStatelabel.text = [NSString stringWithFormat:@"%@",detailModel.status_text];

    self.dayImage.hidden = NO;
    self.rentDayLabel.hidden  = NO;
    
    _bottomView.hidden = YES;
    _bottomView.height = 0;
    _grayView.height = cellNoShadowHeight-55;
    _bgImageView.height = cellHeight-55;
}

- (void)buttonClick:(UIButton *)sender{
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.tag);
    }
}

- (void)setModel:(VFOrderListModel *)model{
    
    _carName.text = kFormat(@"%@%@", model.brand,model.model);
    [_carImage sd_setImageWithURL:[NSURL URLWithString:model.car_img]];
    _pricelabel.text = [NSString stringWithFormat:@"¥%@元/天",model.re_day_rental];
    _orderIDlabel.text = model.order_id;
    _rentCityLabel.text = model.get_city;
    _backCityLabel.text = model.return_city;
    _rentDatelabel.text = [NSString stringWithFormat:@"%@ %@",[CustomTool changDayStr:model.start_date],[CustomTool changWeekStr:model.start_date]];
    _backDatelabel.text = [NSString stringWithFormat:@"%@ %@",[CustomTool changDayStr:model.end_date],[CustomTool changWeekStr:model.end_date]];
    _rentTimelabel.text = [NSString stringWithFormat:@"%@",[CustomTool changHoursStr:model.start_date]];
    _backTimelabel.text = [NSString stringWithFormat:@"%@",[CustomTool changHoursStr:model.end_date]];
    
//    self.orderStatelabel.text = [CustomTool orderState:model.status];
    self.orderStatelabel.text = [NSString stringWithFormat:@"%@",model.status_text];
    _rentDayLabel.text = kFormat(@"%@天", model.rental_days);
    
    
    NSInteger status = [model.status intValue];
    if (status == 101) {
        
        _bottomView.hidden = NO;
        _bottomView.height = 55;
        _grayView.height = cellNoShadowHeight;
        _bgImageView.height = cellHeight;
        
        if ([model.canDel isEqualToString:@"1"]) {
            [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSpaceW(67));
            }];
        }else{
            [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSpaceW(0));
            }];
        }
        [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kSpaceW(67));
            make.right.equalTo(_deleteButton.mas_left).offset(-10);
        }];
        
        [_continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(_payButton.mas_left);
        }];
        [_backCarButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(_continueButton.mas_left);
        }];
        [_evaluationButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(_backCarButton.mas_left);
        }];
    }else if (status == 211){
        [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [_continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(_payButton.mas_left);
        }];
        [_backCarButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(_continueButton.mas_left);
        }];
        [_evaluationButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(_backCarButton.mas_left);
        }];
        
        if ([model.canPay isEqualToString:@"0"]) {
            //不显示支付
            [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            _bottomView.hidden = YES;
            _bottomView.height = 0;
            _grayView.height = cellNoShadowHeight-55;
            _bgImageView.height = cellHeight-55;
        }else{
            //显示支付
            _bottomView.hidden = NO;
            _backCarButton.height = 55;
            _grayView.height = cellNoShadowHeight;
            _bgImageView.height = cellHeight;
            [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-30);
                make.width.mas_equalTo(kSpaceW(67));
            }];
        }
    }
    else if (status == 201){
        
        _bottomView.hidden = YES;
        _bottomView.height = 0;
        _grayView.height = cellNoShadowHeight-55;
        _bgImageView.height = cellHeight-55;
        
    }else if (status == 221){
        
        _bottomView.hidden = NO;
        _bottomView.height = 55;
        _grayView.height = cellNoShadowHeight;
        _bgImageView.height = cellHeight;
        [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        if ([model.canRenew isEqualToString:@"1"]) {
            [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_deleteButton.mas_left);
            }];
            [_continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSpaceW(67));
                make.right.equalTo(_payButton.mas_left).offset(-10);
            }];
        }else{
            [_continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_payButton.mas_left);
            }];
        }
        [_backCarButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kSpaceW(67));
            make.right.equalTo(_continueButton.mas_left).offset(-10);
        }];
        
        [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(_deleteButton.mas_left);
        }];
        
        [_evaluationButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(_backCarButton.mas_left);
        }];
        
    }
//    else if (status == 301){
//        _bottomView.hidden = YES;
//        _bottomView.height = 0;
//        _grayView.height = cellNoShadowHeight-55;
//        _bgImageView.height = cellHeight-55;
//    }
    
    
    else if (status == 311)
    {
        _bottomView.hidden = NO;
        _bottomView.height = 55;
        _grayView.height = cellNoShadowHeight;
        _bgImageView.height = cellHeight;
        if ([model.canEvaluation isEqualToString:@"1"]) {
            [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSpaceW(0));
                make.right.equalTo(_deleteButton.mas_left);
            }];
            
            [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_deleteButton.mas_left);
            }];
            [_continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_payButton.mas_left);
            }];
            [_backCarButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_continueButton.mas_left);
            }];
            [_evaluationButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_backCarButton.mas_left).offset(-10);
                make.width.mas_equalTo(kSpaceW(67));
            }];
        }else{
            //仅显示删除
            [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSpaceW(0));
            }];
            [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_deleteButton.mas_left);
            }];
            [_continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_payButton.mas_left);
            }];
            [_backCarButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_continueButton.mas_left);
            }];
            [_evaluationButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_backCarButton.mas_left);
            }];
            
            _bottomView.hidden = YES;
            _bottomView.height = 0;
            _grayView.height = cellNoShadowHeight-55;
            _bgImageView.height = cellHeight-55;
        }
    }else{
        _bottomView.hidden = YES;
        _bottomView.height = 0;
        _grayView.height = cellNoShadowHeight-55;
        _bgImageView.height = cellHeight-55;
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
