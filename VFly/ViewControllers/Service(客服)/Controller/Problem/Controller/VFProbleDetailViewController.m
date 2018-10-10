//
//  VFProbleDetailViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/12.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFProbleDetailViewController.h"
#import "VFProblmModel.h"
#import "VFProblemTableViewCell.h"
@interface VFProbleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong)NSMutableArray *dataArr;
@property(nonatomic , strong)NSMutableArray *selectStateArr;
@property(nonatomic , strong)BaseTableView *tabelView;

@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@property (nonatomic, strong) NSString *header;//缓存高度
@end

@implementation VFProbleDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = _name;
    _selectStateArr = [[NSMutableArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
    [self createView];
    [self loadData];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tabelView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)loadData{
    [HttpManage getQuestionJsonDataSuccessBlock:^(NSDictionary *data) {
        
        NSLog(@"__________%@",data);
        
        VFProblmModel *model = [[VFProblmModel alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.data) {
            VFProblmTitleModel *obj = [[VFProblmTitleModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
            if ([_name isEqualToString:obj.name]) {
                NSMutableArray *tempArr = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in obj.children) {
                    VFProblmTitleModel *model = [[VFProblmTitleModel alloc]initWithDic:dic];
                    [tempArr addObject:model];
                }
                _dataArr = tempArr;
                for (int i=0;i<_dataArr.count;i++) {
                    [_selectStateArr addObject:@"NO"];
                }
                [_tabelView reloadData];
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)createView{
    _tabelView =[[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStyleGrouped];
    _tabelView.backgroundColor = [UIColor whiteColor];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.header = _header;
    [_tabelView registerClass:[VFProblemTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secionHeader = [[UIView alloc]init];
    VFProblmTitleModel *model = _dataArr[section];
    UILabel *titleLabel = [UILabel initWithTitle:model.name withFont:kTitleBigSize textColor:kdetailColor];
    titleLabel.numberOfLines = 0;
    [secionHeader addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(24);
        make.bottom.mas_equalTo(-24);
        make.right.mas_equalTo(-48);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"前进"];
    [secionHeader addSubview:imageView];
    imageView.tag = 100;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(15);
        make.centerY.equalTo(secionHeader);
        make.width.height.mas_equalTo(16);
    }];
    
    NSString *startStr=_selectStateArr[section];
    if ([startStr isEqualToString:@"YES"]) {
        imageView.transform=CGAffineTransformMakeRotation(M_PI/2);
    }else{
        imageView.transform=CGAffineTransformMakeRotation(0);
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000+section;
    [button addTarget:self action:@selector(sectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [secionHeader addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(secionHeader);
    }];
    
    return secionHeader;
}

- (void)sectionButtonClick:(UIButton *)sender{
    NSString *startStr=_selectStateArr[sender.tag-1000];
    if ([startStr isEqualToString:@"NO"]) {
        for (int i=0;i<_selectStateArr.count;i++) {
            if ([_selectStateArr[i] isEqualToString:@"YES"])
            {
                [_selectStateArr replaceObjectAtIndex:i withObject:@"NO"];
            }
        }
        [_selectStateArr replaceObjectAtIndex:sender.tag-1000 withObject:@"YES"];
    }else{
        [_selectStateArr replaceObjectAtIndex:sender.tag-1000 withObject:@"NO"];
    }
    [_tabelView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

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
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
    VFProblmTitleModel *model = _dataArr[section];
    VFProblmListModel *obj = [[VFProblmListModel alloc]initWithDic:model.children[0]];
    
    NSString *stateStr=_selectStateArr[section];
//    if ([stateStr isEqualToString:@"YES"]) {
//        return obj.name.count;
//    }
//    else{
//        return 0;
//    }
    return obj.name.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VFProblmTitleModel *model = _dataArr[indexPath.section];
    VFProblmListModel *obj = [[VFProblmListModel alloc]initWithDic:model.children[0]];
    cell.deslabel.text = obj.name[indexPath.row];
    return cell;
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
