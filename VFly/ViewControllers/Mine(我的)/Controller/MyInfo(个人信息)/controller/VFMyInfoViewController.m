//
//  VFMyInfoViewController.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFMyInfoViewController.h"
#import "VFMyInfoHeaderImageViewCell.h"
#import "VFMyInfoDefault1Cell.h"
#import "VFMyInfoDefault2Cell.h"
#import "VFUserInfoModel.h"
#import "tailorImageViewController.h"
#import "VFChangeNameController.h"//修改昵称
#import "VFChangeHobbyViewController.h"//兴趣爱好
#import "VFChangeMyInfoController.h"

@interface VFMyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VFUserInfoModel *userInfoModel;
@property (nonatomic , strong)NSDictionary *chooseCity;

@end

@implementation VFMyInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    
    [self setNav];
    [self setupTableView];
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
    titleLabel.text = @"个人资料";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
    
}

- (void)back:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    [JSFProgressHUD showHUDToView:self.view];
    [VFHttpRequest getUserInfoSuccessBlock:^(NSDictionary *data) {
        NSLog(@">>>>>>>>%@",data);
        [JSFProgressHUD hiddenHUD:self.view];

        [self.tableView.mj_header endRefreshing];
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        _userInfoModel = [[VFUserInfoModel alloc]initWithDic:model.data];
        
        [self.tableView reloadData];
        
    } withFailureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [JSFProgressHUD hiddenHUD:self.view];

    }];
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, kNavBarH, kScreenW, kScreenH - kNavBarH);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[VFMyInfoHeaderImageViewCell class] forCellReuseIdentifier:@"VFMyInfoHeaderImageViewCell"];
    [self.tableView registerClass:[VFMyInfoDefault1Cell class] forCellReuseIdentifier:@"VFMyInfoDefault1Cell"];
    [self.tableView registerClass:[VFMyInfoDefault2Cell class] forCellReuseIdentifier:@"VFMyInfoDefault2Cell"];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0)
    {//头像
        VFMyInfoHeaderImageViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoHeaderImageViewCell"];
        if (headerCell == nil)
        {
            headerCell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoHeaderImageViewCell"];
        }
        headerCell.leftLabel.text = @"头像";
        [headerCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.headimg]];
        return headerCell;
    }
    else if (indexPath.row == 1)
    {//昵称
        VFMyInfoDefault1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault1Cell"];
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault1Cell"];
        }
        cell.leftLabel.text = @"昵称";
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_userInfoModel.nickname];
        return cell;
        
    }
    else if (indexPath.row == 2)
    {//身份信息
        VFMyInfoDefault1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault1Cell"];
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault1Cell"];
        }
        cell.leftLabel.text = @"身份信息";
        NSLog(@">>>>>>>>>>>>%@",_userInfoModel.is_certificate);
        if (_userInfoModel.is_certificate)
        {
            cell.titleLabel.text = [NSString stringWithFormat:@" "];
        }
        else
        {
            cell.titleLabel.text = [NSString stringWithFormat:@"未认证"];
        }
        
        return cell;
        
    }
    else if (indexPath.row == 3)
    {//手机号
        VFMyInfoDefault1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault1Cell"];
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault1Cell"];
        }
        cell.leftLabel.text = @"手机号";
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_userInfoModel.phone];
        return cell;
    }
    else if (indexPath.row == 4)
    {//地区
        VFMyInfoDefault2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault2Cell"];
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault2Cell"];
        }
        cell.leftLabel.text = @"地区";
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_userInfoModel.cus_area];
        return cell;
    }
    else if (indexPath.row == 5)
    {//学历
        VFMyInfoDefault2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault2Cell"];
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault2Cell"];
        }
        cell.leftLabel.text = @"学历";
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_userInfoModel.cus_record];
        return cell;
    }
    else if (indexPath.row == 6)
    {//职业
        VFMyInfoDefault2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault2Cell"];
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault2Cell"];
        }
        cell.leftLabel.text = @"职业";
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_userInfoModel.cus_job];
        return cell;
    }
    else if (indexPath.row == 7)
    {//兴趣爱好
        VFMyInfoDefault1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault1Cell"];
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VFMyInfoDefault1Cell"];
        }
        cell.leftLabel.text = @"兴趣爱好";
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_userInfoModel.cus_hobby];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍照", @"相册", nil];
        [sheet showInView:self.view.window];
    }
    else if (indexPath.row == 1)
    {
        VFChangeNameController *changeVC = [[VFChangeNameController alloc]init];
        changeVC.nickName = _userInfoModel.nickname;
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    else if (indexPath.row == 2)
    {//身份信息
    }
    else if (indexPath.row == 3)
    {//手机号
//        VFChangeMyInfoController *vc = [[VFChangeMyInfoController alloc]init];
//        
//        
//        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 4)
    {//地区
        VFChangeMyInfoController *vc = [[VFChangeMyInfoController alloc]init];
        vc.message = @"修改地区";
        vc.type = 2;
        vc.titleText = @"修改地区";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 5)
    {//学历
        VFChangeMyInfoController *vc = [[VFChangeMyInfoController alloc]init];
        vc.message = @"修改学历";
        vc.type = 3;
        vc.titleText = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 6)
    {//职业
        VFChangeMyInfoController *vc = [[VFChangeMyInfoController alloc]init];
        vc.message = @"修改职业";
        vc.type = 4;
        vc.titleText = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 7)
    {//兴趣爱好
        VFChangeMyInfoController *vc = [[VFChangeMyInfoController alloc]init];
        vc.message = @"修改兴趣爱好";
        vc.type = 5;
        vc.titleText = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}

#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

- (void)senderImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    [HttpManage uploadFileImage:data success:^(NSDictionary *data) {
        NSLog(@">>>>>>%@",data);

        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
        NSDictionary *dic = @{@"token":token,
                              @"imgId":model.data[@"id"]};
        [HttpManage setAvatarParameter:dic With:^(NSDictionary *data) {
            NSLog(@">>>>>>%@",data);
            [self loadData];
            
        } failedBlock:^{
            
        }];
    } failedBlock:^(NSError *error){
        
    }];
}















@end
