//
//  VFChooseUseCarAddressView.m
//  VFly
//
//  Created by Hcar on 2018/5/6.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFChooseUseCarAddressView.h"

@interface VFChooseUseCarAddressView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIView *viewBg;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)NSString *title;
@end

@implementation VFChooseUseCarAddressView

- (void)show:(NSString *)title dataArr:(NSArray *)dataArr
{
    _title = title;
    _dataArr = dataArr;
    self.viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self addSubview:_viewBg];
    //背景
    [self creatBackgroundView];
    
    [self createView];
    [self animateIn];
}

- (void)createView{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH*0.618, kScreenW,kScreenH- kScreenH*0.618)];
    whiteView.backgroundColor = kWhiteColor;
    [self addSubview:whiteView];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 54)];
    grayView.backgroundColor = kViewBgColor;
    [whiteView addSubview:grayView];
    
    UILabel *titleLabel = [UILabel initWithTitle:_title withFont:kNewTitle textColor:kTitleBoldColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kNewTitle]];
    titleLabel.frame = CGRectMake(15, 0, 200, 54);
    [whiteView addSubview:titleLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(kScreenW-52, 0, 52, 54);
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dissMissPresentVC) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, kScreenW, whiteView.height-54) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kWhiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [whiteView addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFormat(@"%ld", indexPath.row)];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kFormat(@"%ld", indexPath.row)];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:kBlodFont size:kTitleBigSize];
    cell.textLabel.textColor = kTitleBoldColor;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    cell.detailTextLabel.textColor = kdetailColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(chooseUseCarAddressClick:)]) {
        [self.delegate chooseUseCarAddressClick:_dataArr[indexPath.row]];
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
