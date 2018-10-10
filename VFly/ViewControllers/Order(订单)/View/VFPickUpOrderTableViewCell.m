//
//  VFPickUpOrderTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2018/3/12.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import "VFPickUpOrderTableViewCell.h"
#import "MyOrderModel.h"
//306 291
#define cellHeight 300
#define cellNoShadowHeight 285
@interface VFPickUpOrderTableViewCell()
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *evaluationButton;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *backCarButton;
@property (nonatomic, strong) UIView *grayView;



@property (nonatomic , strong)UILabel *orderIDlabel;
@property (nonatomic , strong)UIImageView *carImage;
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

@end

@implementation VFPickUpOrderTableViewCell

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
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, _carImage.bottom+15, kScreenW-30, 90)];
    timeView.backgroundColor = kViewBgColor;
    [_grayView addSubview:timeView];
    
    //显示接送时间的label
    UILabel *timeLabel = [UILabel initWithTitle:@"接送时间" withFont:kTextSize textColor:kNewDetailColor];
    [timeView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(21);
        make.height.mas_equalTo(17);
    }];

    _rentTimelabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kTitleBoldColor];
    [_rentTimelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
    [timeView addSubview:_rentTimelabel];
    [_rentTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];

//    //显示接送地点的label
    UILabel *addressLabel = [UILabel initWithTitle:@"接送地点" withFont:kTextSize textColor:kNewDetailColor];
    [timeView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(timeLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(17);
    }];

    _rentCityLabel = [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kTitleBoldColor];
    [_rentCityLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
    [timeView addSubview:_rentCityLabel];
    [_rentCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right).offset(15);
        make.top.equalTo(_rentTimelabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, timeView.bottom, kScreenW, 55)];
    [_grayView addSubview:_bottomView];
    
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
        button.tag = i;
        [_bottomView addSubview:button];
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

- (void)buttonClick:(UIButton *)sender{
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.tag);
    }
}

- (void)setModel:(MyOrderListModel *)model{
    NSInteger status = [model.status intValue];
    if (status == 1) {
        
        _bottomView.hidden = NO;
        _bottomView.height = 55;
        _grayView.height = cellNoShadowHeight;
        _bgImageView.height = cellHeight;
        
        if ([model.canDel floatValue] == 1) {
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
    }else if (status == 3){
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
    else if (status == 2 || status == 4 || status == 5 || status == 6 || status == 7){
        
        _bottomView.hidden = YES;
        _bottomView.height = 0;
        _grayView.height = cellNoShadowHeight-55;
        _bgImageView.height = cellHeight-55;
        
    }else if (status == 8){
        
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
        
    }else if (status == 9 || status == 10 || status == 11 || status == 12 || status == 15){
        if ([model.isEvaluation isEqualToString:@"0"]) {
            _bottomView.hidden = NO;
            _bottomView.height = 55;
            _grayView.height = cellNoShadowHeight;
            _bgImageView.height = cellHeight;
            [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.right.equalTo(_deleteButton.mas_left);
            }];
            [_continueButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_payButton.mas_left);
                make.width.mas_equalTo(0);
            }];
            [_backCarButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_continueButton.mas_left);
                make.width.mas_equalTo(0);
            }];
            [_evaluationButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_backCarButton.mas_left);
                make.width.mas_equalTo(kSpaceW(67));
            }];
            
        }else{
            _bottomView.hidden = YES;
            _bottomView.height = 0;
            _grayView.height = cellNoShadowHeight-55;
            _bgImageView.height = cellHeight-55;
        }
    }else if (status == 13 || status == 14){
        _bottomView.hidden = NO;
        _bottomView.height = 55;
        _grayView.height = cellNoShadowHeight;
        _bgImageView.height = cellHeight;
        if ([model.isEvaluation isEqualToString:@"0"]) {
            [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSpaceW(67));
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
                make.width.mas_equalTo(kSpaceW(67));
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
        }
    }else if (status == 16){
        
        _bottomView.hidden = NO;
        _bottomView.height = 55;
        _grayView.height = cellNoShadowHeight;
        _bgImageView.height = cellHeight;
        
        if ([model.isEvaluation isEqualToString:@"0"]) {
            //仅显示支付
            [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_deleteButton.mas_left).offset(-10);
                make.width.mas_equalTo(kSpaceW(67));
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
            //仅显示支付
            [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [_payButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_deleteButton.mas_left).offset(-10);
                make.width.mas_equalTo(kSpaceW(67));
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
        }
    }else{
        _bottomView.hidden = YES;
        _bottomView.height = 0;
        _grayView.height = cellNoShadowHeight-55;
        _bgImageView.height = cellHeight-55;
    }
    
    [_carImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"place_holer_750x500"]];
    _carName.text = kFormat(@"%@%@", model.brand,model.carModel);
    
    if ([model.type isEqualToString:@"2"]) {
        _pricelabel.text = [NSString stringWithFormat:@"¥%@元",model.dayRental];
    }else{
        _pricelabel.text = [NSString stringWithFormat:@"¥%@元/天",model.dayRental];
    }
    _orderIDlabel.text = model.orderId;
    _backCityLabel.text = model.returnCarCity;
    
    _rentTimelabel.text = [NSString stringWithFormat:@"%@ %@ %@",[CustomTool changTimeStr:model.useStartTime formatter:@"MM/dd"],[CustomTool changWeekStr:model.useStartTime],[CustomTool changHoursStr:model.useStartTime]];
    
    _rentCityLabel.text = model.getCarCity;
    
    _orderStatelabel.text = model.statusText;
    
    if ([model.days intValue]<[model.days floatValue]) {
        _rentDayLabel.text = kFormat(@"%@天", model.days);
    }else{
        _rentDayLabel.text = kFormat(@"%d天", [model.days intValue]);
    }
    if ([model.type isEqualToString:@"2"]) {
        _dayImage.hidden = YES;
        _rentDayLabel.hidden  = YES;
    }else{
        _dayImage.hidden = NO;
        _rentDayLabel.hidden = NO;
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
