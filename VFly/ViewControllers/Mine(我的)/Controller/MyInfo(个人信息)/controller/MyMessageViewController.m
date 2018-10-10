//
//  MyMessageViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/20.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MyMessageViewController.h"
//#import "MyMessageMosel.h"
//#import "VFRealNameAuthenticationModel.h"

@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSDictionary *dataDic;
@property (nonatomic , strong)NSArray *dataArr;
@property (nonatomic , strong)NSArray *detailArr;
@property (nonatomic , strong)NSArray *imageArr;

@property (nonatomic , strong)UITextField *nameText;
@property (nonatomic , strong)UITextField *cardText;

@end

@implementation MyMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    _dataDic = [[NSDictionary alloc]init];
    self.navSandow = YES;
    self.centerBlodTitle = @"身份信息不能更改";
    _dataArr = @[@"姓名",@"身份证号"];
    _imageArr = @[[UIImage imageNamed:@"icon_user"],[UIImage imageNamed:@"icon_id"]];
    
//    [self loadData];
    [self realNameAuthentication];
}

- (void)realNameAuthentication{

}

- (void)createTableView{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarH+10+61);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}


- (void)loadData{
    
    if ([self.credit isEqualToString:@"1"]) {
        [HttpManage getCardInfoSuccess:^(NSDictionary *data) {
//            MyMessageMosel *model = [[MyMessageMosel alloc]initWithDic:data];
//            _detailArr = @[model.name,model.card,model.mobile,model.cardsex,model.cardarea];

        } failedBlock:^{

        }];

    }else {
        self.view.backgroundColor = kBackgroundColor;
        self.centerBlodTitle = @"输入身份信息";
        for (int i = 0; i<2; i++) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavBarH+10+61+41*i, kScreenW, 40)];
            bgView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bgView];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
            image.image = _imageArr[i];
            [bgView addSubview:image];
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(35, 0, kScreenW-35, 40)];
            textField.placeholder = _dataArr[i];
            textField.font = [UIFont systemFontOfSize:kTextSize];
            [bgView addSubview:textField];

            if (i == 0) {
                _nameText = textField;
            }else {
                _cardText = textField;
            }

            UIButton *button = [UIButton buttonWithTitle:@"提交信息" sel:@selector(buttonClick) target:self];
            button.frame = CGRectMake(10, kNavBarH+10+61+82+30, kScreenW-20, 40);
            [self.view addSubview:button];
        }
    }

}

- (void)buttonClick{
    if ([_nameText.text isEqualToString:@""]|| [_cardText.text isEqualToString:@""]) {
        [CustomTool alertViewShow:@"请检查输入哦"];
        return;
    }
    kWeakself;
    [HttpManage updataCreditName:_nameText.text withCardID:_cardText.text withSuccessfulBlock:^(NSString *str) {
        if ([str isEqualToString:@"ok"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [CustomTool alertViewShow:str];
        }
    } withFailureBlock:^(NSString *failedData) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
              @"cell"];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.detailTextLabel.text = _detailArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
