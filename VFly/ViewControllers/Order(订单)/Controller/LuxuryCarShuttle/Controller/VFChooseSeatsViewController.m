//
//  VFChooseSeatsViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFChooseSeatsViewController.h"
#import "VFSuttleConfirmOrderViewController.h"

@interface VFChooseSeatsViewController ()
@property (nonatomic , strong)UIButton *selectButton;
@property (nonatomic , strong)NSArray *dataArr;

@end

@implementation VFChooseSeatsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"车辆座位数";
    _dataArr = @[@"2座",@"4座",@"5座",@"7座"];
    [self createView];
}

- (void)createView{
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton buttonWithTitle:_dataArr[i] sel:@selector(buttonClick:) target:self];
        [self.view addSubview:button];
        button.tag =i;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(kScreenW-210);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(kOldNavBarH+i*68);
        }];
        
        if (i==0) {
            _selectButton = button;
        }else{
            [button setBackgroundColor:kNewBgColor];
            [button setTitleColor:kdetailColor forState:UIControlStateNormal];
        }
    }
    
    UILabel *showLabel = [UILabel initWithTitle:@"*温馨提示:司机要占一个座位,注意计算自己所需座位数与剩余座位数匹配" withFont:kTextSize textColor:kNewDetailColor];
    showLabel.numberOfLines = 0;
    [self.view addSubview:showLabel];
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(408+kStatutesBarH);
        make.height.mas_equalTo(34);
    }];
    
    UIButton *bottomButton = [UIButton newButtonWithTitle:@"下一步"  sel:@selector(nextButtonClick) target:self cornerRadius:NO];
    [self.view addSubview:bottomButton];
    
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kSafeBottomH);
        make.height.mas_equalTo(44);
    }];
}

- (void)nextButtonClick{
    
    if (_isChange) {
        if ([_delegate respondsToSelector:@selector(carSeatButtonClick:)]) {
            [self.delegate carSeatButtonClick:_dataArr[_selectButton.tag]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        VFSuttleConfirmOrderViewController *vc =[[VFSuttleConfirmOrderViewController alloc]init];
        vc.seats = _dataArr[_selectButton.tag];
        vc.suttleCar = self.carModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)buttonClick:(UIButton *)sender{
    [_selectButton setTitleColor:kdetailColor forState:UIControlStateNormal];
    [_selectButton setBackgroundColor:kNewBgColor];
    
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [sender setBackgroundColor:kMainColor];
    _selectButton = sender;
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
