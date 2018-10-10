//
//  VFOrderDetailPayView.m
//  VFly
//
//  Created by Hcar on 2018/4/18.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFOrderDetailPayView.h"
#import "VFOrderPayDetailTableViewCell.h"
#import "VFOrderDetailModel.h"

@interface VFOrderDetailPayView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIView *viewBg;
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)VFOrderDetailPayModel *dataModel;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@end

@implementation VFOrderDetailPayView

-(void)show:(VFOrderDetailPayModel *)model
{
    self.viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self addSubview:_viewBg];
    _dataModel = model;
    //背景
    [self creatBackgroundView];
    [self createView];
}

- (void)createView{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-309-kSafeBottomH, kScreenW, 309+kSafeBottomH)];
    whiteView.backgroundColor = kWhiteColor;
    [self addSubview:whiteView];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 54)];
    grayView.backgroundColor = kViewBgColor;
    [whiteView addSubview:grayView];
    
    UILabel *titleLabel = [UILabel initWithTitle:kFormat(@"支付记录·%@", _dataModel.item) withFont:kTitleBigSize textColor:kdetailColor];
    titleLabel.frame = CGRectMake(15, 0, 200, 54);
    [whiteView addSubview:titleLabel];
    NSRange labelRange = [titleLabel.text rangeOfString:@"支付记录"];
    [CustomTool setTextColor:titleLabel FontNumber:[UIFont fontWithName:kBlodFont size:kNewTitle] AndRange:labelRange AndColor:kTitleBoldColor];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(kScreenW-52, 0, 52, 54);
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dissMissPresentVC) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeButton];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 244, kScreenW-30, 1)];
    lineView.backgroundColor = klineColor;
    [whiteView addSubview:lineView];

    
    UILabel *bottomLabel = [UILabel initWithTitle:@"已付清" withFont:kTitleBigSize textColor:kTitleBoldColor];
    [bottomLabel setFont:[UIFont fontWithName:kBlodFont size:kTitleBigSize]];
    [whiteView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(lineView.bottom);
        make.height.mas_offset(64);
    }];
    
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 69, kScreenW, 160) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kWhiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [whiteView addSubview:_tableView];
    [self.tableView registerClass:[VFOrderPayDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataModel.lists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFOrderDetailPayListModel *model = [[VFOrderDetailPayListModel alloc]initWithDic:_dataModel.lists[indexPath.row]];
    VFOrderPayDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.model = model;
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self animateOut];
}


-(void)animateIn
{
    self.viewBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBg.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

-(void)animateOut
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.viewBg.alpha = 0.2;
        self.alpha = 0.2;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)creatBackgroundView
{
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.opaque = NO;
    //这里自定义的View 达到的效果和UIAlterView一样是在Window上添加，UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
    
}

-(void)dissMissPresentVC
{
    [self animateOut];
}

@end
