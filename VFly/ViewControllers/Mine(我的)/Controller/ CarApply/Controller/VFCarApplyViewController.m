//
//  VFCarApplyViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/11/17.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFCarApplyViewController.h"
#import "VFCarApplyTableViewCell.h"

@interface VFCarApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic , strong)NSArray *sectionheaderArr;
@property (nonatomic , strong)NSArray *sectionBodyArr;
@property (nonatomic , strong)NSMutableArray *stateOneArr;
@property (nonatomic , strong)NSMutableArray *stateTwoArr;
@property (nonatomic , strong)NSMutableArray *stateThreeArr;
@property (nonatomic , strong)NSMutableArray *textFieldArr;
@property (nonatomic , strong)BaseTableView *tabeleView;

@property (nonatomic , strong)NSString *name;
@property (nonatomic , strong)NSString *mobile;
@property (nonatomic , strong)NSString *carNum;
@property (nonatomic , strong)NSString *carName;
@property (nonatomic , strong)NSString *carModel;
@property (nonatomic , strong)NSString *carYear;
@property (nonatomic , strong)NSString *carPrice;
@property (nonatomic , strong)NSString *noteText;
@property (nonatomic , strong)NSString *header;
@end

@implementation VFCarApplyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _name = @"";
    _mobile = @"";
    _carNum = @"";
    _carName = @"";
    _carModel = @"";
    _carYear = @"";
    _carPrice = @"";
    _noteText = @"";
    _header = @"车辆托管申请";
    self.UMPageStatistical = @"carManager";
    _sectionheaderArr = @[@"托管人信息",@"车辆托管信息",@"其他信息"];
    _sectionBodyArr = @[@[@"姓名",@"手机号"],@[@"车牌号",@"车辆品牌",@"车辆型款",@"车辆年份"],@[@"裸车价",@"备注"]];
    _stateOneArr = [NSMutableArray arrayWithObjects:@"NO",@"NO", nil];
    _stateTwoArr = [NSMutableArray arrayWithObjects:@"NO",@"NO",@"NO",@"NO", nil];
    _stateThreeArr = [NSMutableArray arrayWithObjects:@"NO",@"NO", nil];
    [self createView];
    self.navTitleLabel.text = _header;
    [self setKeyScrollView:self.tabeleView scrolOffsetY:kNavBarH options:HYHidenControlOptionLeft | HYHidenControlOptionTitle];
}

- (void)createView {
    _tabeleView = [[BaseTableView alloc]init];
    _tabeleView.delegate = self;
    _tabeleView.dataSource = self;
    [self.view addSubview:_tabeleView];
    _tabeleView.header = _header;
    _tabeleView.tableFooterView = [self createTableFootView];
    [_tabeleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH);
    }];
    [_tabeleView registerClass:[VFCarApplyTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (UIView *)createTableFootView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 104)];
    UIButton *button = [UIButton newButtonWithTitle:@"提交申请"  sel:@selector(applyButtonClick) target:self cornerRadius:YES];
    button.frame = CGRectMake(15, 40, kScreenW-30, 40);
    [view addSubview:button];
    return view;
}

- (void)relodData{
    [self.tabeleView reloadData];
    _stateOneArr = [NSMutableArray arrayWithObjects:@"NO",@"NO", nil];
    _stateTwoArr = [NSMutableArray arrayWithObjects:@"NO",@"NO",@"NO",@"NO", nil];
    _stateThreeArr = [NSMutableArray arrayWithObjects:@"NO",@"NO", nil];
}

- (void)applyButtonClick{
    
    if ([_name isEqualToString:@""] || [_mobile isEqualToString:@""] || [_carNum isEqualToString:@""] || [_carName isEqualToString:@""] || [_carModel isEqualToString:@""] || [_carYear isEqualToString:@""] || [_carPrice isEqualToString:@""]) {
        [CustomTool showOptionMessage:@"请检查输入"];
        return;
    }
    
    if (![CustomTool IsPhoneNumber:_mobile]) {
        [CustomTool showOptionMessage:@"请检查手机号"];
        return;
    }
    
    if (![CustomTool checkCarID:_carNum]) {
        [CustomTool showOptionMessage:@"请检查车牌号"];
        return;
    }
    
    
    NSTimeInterval late1=[[NSDate date] timeIntervalSince1970];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:late1];

    NSDateFormatter *dated=[[NSDateFormatter alloc] init];
    [dated setDateFormat:@"yyyy年MM月dd日"];
    NSString *str = [dated stringFromDate:currentDate];
    NSString *year1 = [str stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *tempMonrh = [year1 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *lastDate = [tempMonrh stringByReplacingOccurrencesOfString:@"日" withString:@""];
    
    NSDictionary *dic = @{@"name":_name,@"mobile":_mobile,@"plateNumber":_carNum,@"brand":_carName,@"model":_carModel,@"year":_carYear,@"netPrice":_carPrice,@"startTime":lastDate};
    kWeakself;
    [VFHttpRequest trustShipParameter:dic successBlock:^(NSDictionary *data) {
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        if ([model.code isEqualToString:@"1"]) {
            HCAlertViewController *alertCtrl = [HCAlertViewController alertControllerWithTitle:nil message:@"申请已提交，我们将尽快与您联系"];
            HCAlertAction *Action = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alertCtrl addAction:Action];
            [self presentViewController:alertCtrl animated:NO completion:nil];
        }else{
            [EasyTextView showErrorText:@"请求失败"];
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _sectionBodyArr[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionheaderArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if ([_stateOneArr[indexPath.row] isEqualToString:@"NO"]) {
                return 64;
            }else{
                return 87;
            }
            break;
        case 1:
            if ([_stateTwoArr[indexPath.row] isEqualToString:@"NO"]) {
                return 64;
            }else{
                return 87;
            }
            break;
        case 2:
            if ([_stateThreeArr[indexPath.row] isEqualToString:@"NO"]) {
                return 64;
            }else{
                return 87;
            }
            break;
        default:
            return 44;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 28)];
    view.backgroundColor = kNewBgColor;
    UILabel *label = [UILabel initWithFont:kTextSize textColor:kTextBlueColor];
    label.frame = CGRectMake(15, 0, kScreenW-30, 28);
    label.text = _sectionheaderArr[section];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFCarApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFormat(@"%ld%ld", indexPath.section,indexPath.row)];
    if (cell == nil) {
       cell = [[VFCarApplyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kFormat(@"%ld%ld", indexPath.section,indexPath.row)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *tempArr = _sectionBodyArr[indexPath.section];
    cell.titlelabel.text = tempArr[indexPath.row];

    cell.inputField.placeholder = kFormat(@"请输入%@", tempArr[indexPath.row]);
    cell.alertlabel.text = kFormat(@"%@输入有误", tempArr[indexPath.row]);
    cell.inputField.tag = indexPath.section*100+indexPath.row;
    [cell.inputField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    cell.inputField.delegate = self;
    switch (indexPath.section) {
        case 0:
            cell.state = _stateOneArr[indexPath.row];
            break;
        case 1:
            cell.state = _stateTwoArr[indexPath.row];
            break;
        case 2:
            cell.state = _stateThreeArr[indexPath.row];
            break;
        default:
            break;
    }
    
    if (cell.inputField.tag == 1 || cell.inputField.tag == 103 || cell.inputField.tag == 200) {
        cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
    }
    

    [_textFieldArr addObject:cell.inputField];
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        switch (textField.tag) {
            case 0:
                [_stateOneArr replaceObjectAtIndex:0 withObject:@"YES"];
                break;
            case 1:
                [_stateOneArr replaceObjectAtIndex:1 withObject:@"YES"];
                break;
            case 100:
                [_stateTwoArr replaceObjectAtIndex:0 withObject:@"YES"];
                break;
            case 101:
                [_stateTwoArr replaceObjectAtIndex:1 withObject:@"YES"];
                break;
            case 102:
                [_stateTwoArr replaceObjectAtIndex:2 withObject:@"YES"];
                break;
            case 103:
                [_stateTwoArr replaceObjectAtIndex:3 withObject:@"YES"];
                break;
            case 200:
                [_stateThreeArr replaceObjectAtIndex:1 withObject:@"YES"];
                break;
            case 201:
                break;
            default:
                break;
        }
    }else{
        
        
        switch (textField.tag) {
            case 0:
                [_stateOneArr replaceObjectAtIndex:0 withObject:@"NO"];
                break;
            case 1:{
                BOOL phone = [CustomTool IsPhoneNumber:textField.text];
                if (!phone) {
                    [_stateOneArr replaceObjectAtIndex:1 withObject:@"YES"];
                }else{
                    [_stateOneArr replaceObjectAtIndex:1 withObject:@"NO"];
                }
            }
                break;
            case 100:{
                BOOL carID = [CustomTool checkCarID:textField.text];
                if (!carID) {
                    [_stateTwoArr replaceObjectAtIndex:0 withObject:@"YES"];
                }else{
                    [_stateTwoArr replaceObjectAtIndex:0 withObject:@"NO"];
                }
            }
                break;
            case 101:
                [_stateTwoArr replaceObjectAtIndex:1 withObject:@"NO"];
                break;
            case 102:
                [_stateTwoArr replaceObjectAtIndex:2 withObject:@"NO"];
                break;
            case 103:
                [_stateTwoArr replaceObjectAtIndex:3 withObject:@"NO"];
                break;
            case 200:
                [_stateThreeArr replaceObjectAtIndex:1 withObject:@"NO"];
                break;
            case 201:
                break;
            default:
                break;
        }
    }
     [_tabeleView reloadData];
}

//输入框限定字符长度
- (void)textFieldDidChange:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _name = textField.text;
            break;
        case 1:
            _mobile = textField.text;
            break;
        case 100:
            _carNum = textField.text;
            break;
        case 101:
            _carName = textField.text;
            break;
        case 102:
            _carModel = textField.text;
            break;
        case 103:
            _carYear = textField.text;
            break;
        case 200:
            _carPrice = textField.text;
            break;
        case 201:
            _noteText = textField.text;
            break;
        default:
            break;
    }
    
    if (textField.tag == 1) {
        if (textField.text.length > 11) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:11];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }else{
        if (textField.text.length > 15) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:15];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    
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
