//
//  VFCommonProblemDetailController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFCommonProblemDetailController.h"
#import "VFCommonProblemModel.h"
#import "VFCommonProDetailCell.h"

@interface VFCommonProblemDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong)NSMutableArray *dataArr;
@property(nonatomic , strong)NSMutableArray *selectStateArr;
@property(nonatomic , strong)BaseTableView *tabelView;

@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@property (nonatomic, strong) NSString *header;//缓存高度
@end

@implementation VFCommonProblemDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectStateArr = [[NSMutableArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self setNav];
    [self createView];
    [self loadData];
}

- (void)setNav {
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatutesBarH + 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc]init];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.frame = CGRectMake(0, 0, 64, kStatutesBarH + 44);
    [navView addSubview:backButton];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_icon_back_black"]];
    [backButton addSubview:backImageView];
    backImageView.sd_layout
    .leftSpaceToView(backButton, 20)
    .bottomSpaceToView(backButton, 0)
    .heightIs(24)
    .widthIs(24);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH_S / 2 - 50, kStatutesBarH + 20, 100, 24);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@",self.name];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    [HttpManage getQuestionJsonDataSuccessBlock:^(NSDictionary *data) {
        
        VFCommonProblemModel *model = [[VFCommonProblemModel alloc]initWithDic:data];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.data) {
            VFCommonProblmTitleModel *obj = [[VFCommonProblmTitleModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
            if ([_name isEqualToString:obj.name]) {
                NSMutableArray *tempArr = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in obj.children) {
                    VFCommonProblmTitleModel *model = [[VFCommonProblmTitleModel alloc]initWithDic:dic];
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

- (void)createView {
    _tabelView =[[BaseTableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStyleGrouped];
    _tabelView.backgroundColor = [UIColor whiteColor];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.header = _header;
    [_tabelView registerClass:[VFCommonProDetailCell class] forCellReuseIdentifier:@"VFCommonProDetailCell"];
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secionHeader = [[UIView alloc]init];
    VFCommonProblmTitleModel *model = _dataArr[section];
    UILabel *titleLabel = [UILabel initWithTitle:model.name withFont:kTitleBigSize textColor:kdetailColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = HexColor(0x212121);
    titleLabel.numberOfLines = 0;
    [secionHeader addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-34);
        make.right.mas_equalTo(-48);
    }];
    
    return secionHeader;
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
    return 44;
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
- (NSMutableDictionary *)heightAtIndexPath {
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    VFCommonProblmTitleModel *model = _dataArr[section];
    VFCommonProblmListModel *obj = [[VFCommonProblmListModel alloc]initWithDic:model.children[0]];
    return obj.name.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFCommonProDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFCommonProDetailCell"];
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"VFCommonProDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VFCommonProblmTitleModel *model = _dataArr[indexPath.section];
    VFCommonProblmListModel *obj = [[VFCommonProblmListModel alloc]initWithDic:model.children[0]];
    cell.deslabel.text = obj.name[indexPath.row];
    return cell;
}

@end
