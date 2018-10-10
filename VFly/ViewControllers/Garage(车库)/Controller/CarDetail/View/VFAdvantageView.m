//
//  VFAdvantageView.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFAdvantageView.h"
//#import "VFProblemTableViewCell.h"
#import "VFShowAdvantageTableViewCell.h"
@interface VFAdvantageView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIView *viewBg;
@property (nonatomic , strong)BaseTableView *tableView;
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)NSArray *titleArr;
@property (nonatomic , strong)NSString *title;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@end

@implementation VFAdvantageView

- (void)show:(NSString *)title sectionTitle:(NSArray *)sectionArr rowArr:(NSArray *)rowArr
{
    _title = title;
    _titleArr = sectionArr;
    _dataArr = rowArr;
    self.viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self addSubview:_viewBg];
    //背景
    [self creatBackgroundView];
    
    [self createView];
}

- (void)createView{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-kScreenH*0.618, kScreenW, kScreenH*0.618)];
    whiteView.backgroundColor = kWhiteColor;
    [self addSubview:whiteView];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 54)];
    grayView.backgroundColor = kViewBgColor;
    [whiteView addSubview:grayView];
    
    UILabel *titleLabel = [UILabel initWithTitle:@"威风优势" withFont:kNewTitle textColor:kTitleBoldColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kNewTitle]];
    titleLabel.frame = CGRectMake(15, 0, 200, 54);
    [whiteView addSubview:titleLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(kScreenW-52, 0, 52, 54);
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dissMissPresentVC) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeButton];
    
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 54, kScreenW, whiteView.height-54) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kWhiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [whiteView addSubview:_tableView];
    [self.tableView registerClass:[VFShowAdvantageTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secionHeader = [[UIView alloc]init];
    UILabel *label = [UILabel initWithTitle:_titleArr[section] withFont:kTitleBigSize textColor:kdetailColor];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    label.frame = CGRectMake(15, 15, kScreenW-30, 20);
    [secionHeader addSubview:label];
    return secionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 64;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFShowAdvantageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.showlabel.text = _dataArr[indexPath.section];
//    cell.deslabel.text= _dataArr[indexPath.section];
    return cell;
}



- (void)btnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(myBankCardListAddBankClick)]) {
        [self.delegate myBankCardListAddBankClick];
        [self animateOut];
    }
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
