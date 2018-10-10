//
//  MyDataViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/7/3.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "MyDataViewController.h"
#import "MyMessageViewController.h"
#import "MyPhoneViewController.h"
#import "MyProfileModel.h"
#import "changeInfoViewController.h"
#import "anyButton.h"
#import "LoginModel.h"
#import "tailorImageViewController.h"

@interface MyDataViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)NSArray *imageArr;
@property (nonatomic , strong)LoginModel *loginObj;

@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UIButton *rightbutton;
@property (nonatomic , strong)UIButton *headerButton;

@end

@implementation MyDataViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"我的资料";
    self.UMPageStatistical = @"personalInfo";
    _dataArr = [[NSMutableArray alloc]init];
    
    [self replaceDefaultNavBar:[[UIView alloc]init]];
    [self initView];
    [self loadData];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, kStatutesBarH, 44, 44);
    [button setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    AdjustsScrollViewInsetNever(self, self.tableView);
}

- (void)initView{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView = [self tableHeaderView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (UIView *)tableHeaderView{
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW+82)];
    
    _headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headerButton addTarget:self action:@selector(chooseHeaderPic) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_headerButton];
    
    [_headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreenW);
    }];
    
    _nameLabel = [UILabel initWithFont:kNewBigTitle textColor:kTitleBoldColor];
    [_nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kNewBigTitle]];
    [headerView addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_headerButton.mas_bottom).offset(30);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(42);
    }];
    
    _rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightbutton setImage:[UIImage imageNamed:@"icon_XiuGai"] forState:UIControlStateNormal];
    [_rightbutton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_rightbutton];
    
    [_rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(_headerButton.mas_bottom).offset(31);
    }];
    
    return headerView;
}

- (void)backbuttonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseHeaderPic{
    [self ChooseHeader];
}

- (void)buttonClick{
    changeInfoViewController *vc= [[changeInfoViewController alloc]init];
    vc.type = 6;
    vc.message = _nameLabel.text;
    vc.titleText = @"昵称";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData{
    
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpManage getUserInfoWithToken:tokenStr withSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"_______aaaaaa______%@",dic);

        _loginObj = [[LoginModel alloc]initWithDic:dic];
        [self.headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_loginObj.headImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"加载"]];
        _nameLabel.text = _loginObj.nickname;
        CGSize textSize1 = [_loginObj.nickname sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textSize1.width+5);
        }];
        
        [_rightbutton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right);
        }];

        
        [JSFProgressHUD hiddenHUD:self.view];
    } withFailedBlock:^{
        [ProgressHUD showError:@"加载失败"];
    }];

    kWeakself;
    [HttpManage creditListSuccess:^(NSDictionary *data) {
        NSLog(@"______sssssss_______%@",data);
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        MyProfileModel *model = [[MyProfileModel alloc]initWithDic:data];
        for (NSDictionary *dic in model.creditList) {
            MyProfileListModel *obj = [[MyProfileListModel alloc]initWithDic:dic];
            [tempArr addObject:obj];
        }
        _dataArr = tempArr;
        [weakSelf.tableView reloadData];
    } failedBlock:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:
              @"cell"];
    }
    MyProfileListModel *obj = _dataArr[indexPath.row];
    cell.textLabel.text = obj.info;
    if ([obj.status isEqualToString:@"1"])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.detailTextLabel.text = obj.data[@"mobile"];
            break;
        case 2:
            cell.detailTextLabel.text = obj.data[@"area"];
            break;
        case 3:
            cell.detailTextLabel.text = obj.data[@"record"];
            break;
        case 4:
            cell.detailTextLabel.text = obj.data[@"job"];
            break;
        case 5:
            cell.detailTextLabel.text = obj.data[@"hobby"];
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kTitleBigSize];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyProfileListModel *model = _dataArr[indexPath.row];
    NSArray *lastArr = @[@"",@"mobile",@"area",@"record",@"job",@"hobby"];
    if (indexPath.row == 0) {
        NSString *realName = [[NSUserDefaults standardUserDefaults]objectForKey:RealNameState];
        NSString *driverLicense = [[NSUserDefaults standardUserDefaults]objectForKey:DriverLicenseState];
        if ([realName isEqualToString:@"1"] && [driverLicense isEqualToString:@"1"]) {
            MyMessageViewController *vc= [[MyMessageViewController alloc]init];
            vc.credit = self.credit;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.row == 1)
    {
        MyPhoneViewController *vc = [[MyPhoneViewController  alloc]init];
        NSString *key = lastArr[indexPath.row];
        vc.message = model.data[key];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        changeInfoViewController *vc= [[changeInfoViewController alloc]init];
        vc.type = indexPath.row;
        NSString *key = lastArr[indexPath.row];
        vc.message = model.data[key];
        vc.titleText = model.info;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)ChooseHeader {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [sheet showInView:self.view.window];
}

#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 设置代理
    ipc.delegate = self;
    switch (buttonIndex) {
        case 0: { // 拍照
            AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
            {
                //无权限
                UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未开启相机权限，请到设置-隐私-相机中开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [self.view addSubview:aler];
                [aler show];
            }
            else{
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
                ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:ipc animated:YES completion:nil];
            }
            break;
        }
        case 1: { // 相册
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 显示控制器
            [self presentViewController:ipc animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

- (void)cropImage: (UIImage *)image {
    tailorImageViewController *cropImageViewController = [[tailorImageViewController alloc]init];
    cropImageViewController.pic = image;
    cropImageViewController.delegate = self;
    [self.navigationController pushViewController: cropImageViewController animated: YES];
}


#pragma mark - UIImagePickerControllerDelegate
/**
 *  在选择完图片后调用
 *
 *  @param info   里面包含了图片信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获得图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self cropImage: image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)senderImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    [HttpManage uploadFileImage:data success:^(NSDictionary *data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        NSDictionary *dic = @{@"token":token,@"imgId":model.data[@"id"]};
        [HttpManage setAvatarParameter:dic With:^(NSDictionary *data) {
            [_headerButton sd_setImageWithURL:model.data[@"path"] forState:UIControlStateNormal];
//            [_bgImage sd_setImageWithURL:data[@"path"] placeholderImage:[UIImage imageNamed:@"place_holer_750x500"]];
        } failedBlock:^{
            
        }];
    } failedBlock:^(NSError *error){
    }];
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
