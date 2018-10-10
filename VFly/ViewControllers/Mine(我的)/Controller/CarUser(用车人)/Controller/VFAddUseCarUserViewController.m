//
//  VFAddUseCarUserViewController.m
//  VFly
//
//  Created by Hcar on 2018/4/12.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFAddUseCarUserViewController.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>

@interface VFAddUseCarUserViewController ()

@property (nonatomic , strong)UIView *leftView;
@property (nonatomic , strong)UIView *centerView;


@property (nonatomic , strong)UILabel *headerLeftlabel;
@property (nonatomic , strong)UIScrollView *bigScrollView;
@property (nonatomic , strong)UIButton *driveImageButton;
@property (nonatomic , strong)UIButton *positiveImageButton;
@property (nonatomic , strong)UIButton *reverseImageButton;

@property (nonatomic , strong)UITextField *idCardNameTextField;
@property (nonatomic , strong)UITextField *idCardNumTextField;

@property (nonatomic , strong)UIImage *chooseImage;
@property (nonatomic , strong)UIButton *selectorButton;

@property (nonatomic , strong)UIScrollView *leftSCrollView;
@property (nonatomic , strong)UIScrollView *centerSCrollView;
@property (nonatomic , strong)UIScrollView *rightSCrollView;

@property (nonatomic , strong)UIView *personalInformationView;
@property (nonatomic , strong)UILabel *positiveImageLabel;
@property (nonatomic , strong)UILabel *reverseImageLabel;
@property (nonatomic , strong)UILabel *leftAlertLabel;
@property (nonatomic , strong)UIButton *leftNextbutton;
@property (nonatomic , strong)UIButton *leftCancelButton;
@property (nonatomic , strong)UIImage *positiveImage;
@property (nonatomic , strong)UIImage *reverseImage;
@property (nonatomic , strong)UIImage *driveImage;

@property (nonatomic , strong)NSString *positiveImageID;
@property (nonatomic , strong)NSString *reverseImageID;
@property (nonatomic , strong)NSString *driveImageID;

@property (nonatomic , strong)UILabel *driveImageLabel;
@property (nonatomic , strong)UIView *driveInformationView;
@property (nonatomic , strong)UITextField *driveNameTextField;
@property (nonatomic , strong)UITextField *driveIDCardNumTextField;
@property (nonatomic , strong)UITextField *driveSexTextField;
@property (nonatomic , strong)UITextField *driveAddressTextField;
@property (nonatomic , strong)UITextField *driveCarModelTextField;
@property (nonatomic , strong)UILabel *centerAlertLabel;
@property (nonatomic , strong)UIButton *driveNextbutton;

@property (nonatomic , strong)UIViewController * driveVC;

@end

@implementation VFAddUseCarUserViewController{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AipOcrService shardService] authWithAK:@"IAGAljbyiIPVWzbpeN0Iz3Rh" andSK:@"OiZriq8IXlaAC2hpWL0QVYwFGuRVU5A2"];
    _positiveImageID = @"";
    _reverseImageID = @"";
    _driveImageID = @"";
    [self configCallback];
    if (_isMine) {
        self.navTitleLabel.text = @"实名认证";
    }else{
        self.navTitleLabel.text = @"完善用车人资料";
    }
    [self createView];
    
    UIButton *button = [UIButton newButtonWithTitle:@"确认上传" sel:@selector(applyButtonClick) target:self cornerRadius:YES];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-kSafeBottomH-15);
    }];
}

- (void)applyButtonClick{
    
    if ([_positiveImageID isEqualToString:@""] || [_reverseImageID isEqualToString:@""] || [_driveImageID isEqualToString:@""]) {
        [CustomTool showOptionMessage:@"请先将图片全部上传完成"];
        return;
    }
    
    if ([_idCardNameTextField.text isEqualToString:@""] || [_driveIDCardNumTextField.text isEqualToString:@""] || [_idCardNumTextField.text isEqualToString:@""]) {
        [CustomTool showOptionMessage:@"输入信息不能为空"];
        return;
    }
    kWeakSelf;
    [JSFProgressHUD showHUDToView:self.view];
    
    if (_isMine) {
        NSDictionary *dic = @{@"name":_idCardNameTextField.text,@"card_face":_positiveImageID,@"card_back":_reverseImageID,@"img":_driveImageID,@"card_num":_idCardNumTextField.text,@"driving_num":_driveIDCardNumTextField.text,@"sex":_driveSexTextField.text,@"address":_driveAddressTextField.text,@"allow_car_model":_driveCarModelTextField.text};
        
        [VFHttpRequest userCertificationParameter:dic SuccessBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:weakSelf.view];
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            if ([model.code intValue]==1) {
                HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"提交成功"];
                HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                
                [alertVC addAction:updateAction];
                [self presentViewController:alertVC animated:YES completion:nil];
            }else{
                [ProgressHUD showError:model.message];
            }
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];

        }];
    }else{
        NSDictionary *dic = @{@"name":_idCardNameTextField.text,@"card_face":_positiveImageID,@"card_back":_reverseImageID,@"driving_licence":_driveImageID,@"card_num":_idCardNumTextField.text,@"driving_num":_driveIDCardNumTextField.text};
        [VFHttpRequest addUsePeopleParameter:_userID?_userID:@"" dic:dic successBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:weakSelf.view];
            HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"提交成功"];
            HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertVC addAction:updateAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];

        }];
    }
}

- (void)createView{
    _bigScrollView = [[UIScrollView alloc]init];
    [_bigScrollView addSubview:[self createLeftView]];
    [_bigScrollView addSubview:[self createCenterView]];
    
    _bigScrollView.frame = CGRectMake(0, kNavBarH, kScreenW, kScreenH-kOldNavBarH);
    _bigScrollView.contentSize=CGSizeMake(0, 474);
    [self.view addSubview:_bigScrollView];
}

#pragma mark -----------百度AI识别结果回调-----------
- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    // 这是默认的识别成功的回调
    [JSFProgressHUD hiddenHUD:self.view];
    _successHandler = ^(id result){
        //        NSString *title = @"识别结果";
        //        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *dataDic = result[@"words_result"];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    if (weakSelf.selectorButton.tag == 1001) {
                        if ([CustomTool IsIdentityCard:dataDic[@"公民身份号码"][@"words"]]) {
                            NSString *name = dataDic[@"姓名"][@"words"];
                            if (![name isEqualToString:@""]) {
                                weakSelf.idCardNameTextField.text = dataDic[@"姓名"][@"words"];
                                weakSelf.idCardNumTextField.text = dataDic[@"公民身份号码"][@"words"];
                                weakSelf.positiveImage = weakSelf.chooseImage;
                                [weakSelf.positiveImageButton setImage:weakSelf.positiveImage forState:UIControlStateNormal];
                                [weakSelf leftPicChooseViewLayout];
                                [weakSelf updataPic];
                            }else{
                                [weakSelf createAlertView];
                                return;
                            }
                        }else{
                            [weakSelf createAlertView];
                            return;
                        }
                    }else if (weakSelf.selectorButton.tag == 1002){
                        
                        if (![CustomTool isAllNum:dataDic[@"失效日期"][@"words"]]) {
                            [weakSelf createAlertView];
                            return;
                        }
                        NSString *time = dataDic[@"失效日期"][@"words"];
                        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                        NSString *nowTime  = [CustomTool changTimeStr:timeSp formatter:@"yyyyMMdd"];
                        
                        if ([time integerValue]<[nowTime integerValue]) {
                            [[[UIAlertView alloc] initWithTitle:@"证件已过期" message:@"请重新拍摄或者选择证件图片" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                            return;
                        }
                        
                        [weakSelf leftPicChooseReverseLayout];
                        weakSelf.reverseImage = weakSelf.chooseImage;
                        [weakSelf.reverseImageButton setImage:weakSelf.reverseImage forState:UIControlStateNormal];
                        [weakSelf updataPic];
                    }else if (weakSelf.selectorButton.tag == 1003){
                        if (dataDic[@"至"][@"words"]) {
                            if (![CustomTool isAllNum:dataDic[@"至"][@"words"]]) {
                                
                            }else{
                                NSString *time = dataDic[@"至"][@"words"];
                                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                                NSString *nowTime  = [CustomTool changTimeStr:timeSp formatter:@"yyyyMMdd"];
                                if ([time integerValue]<[nowTime integerValue]) {
                                    [[[UIAlertView alloc] initWithTitle:@"证件已过期" message:@"请重新拍摄或者选择证件图片" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                                    return;
                                }
                            }
                        }else{
                            if (dataDic[@"有效期限"][@"words"]) {
                                
                            }else{
                                [weakSelf createAlertView];
                                return;
                            }
                        }
                        
                        if (![CustomTool isAllNum:dataDic[@"初次领证日期"][@"words"]]) {
                            [weakSelf createAlertView];
                            return;
                        }
                        
                        if (dataDic[@"有效期限"][@"words"]) {
                            NSString *firstDays = dataDic[@"初次领证日期"][@"words"];
                            NSString *tempStr = dataDic[@"有效期限"][@"words"];
                            NSString *year = [firstDays substringToIndex:4];
                            NSString *effectiveDate = [tempStr stringByReplacingOccurrencesOfString:@"年" withString:@""];
                            NSString *lastyear = kFormat(@"%d", [year intValue]+[effectiveDate intValue]);
                            NSString *lastTime = kFormat(@"%@%@", lastyear,[firstDays substringFromIndex:4]);
                            
                            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                            NSString *nowTime  = [CustomTool changTimeStr:timeSp formatter:@"yyyyMMdd"];
                            
                            if ([lastTime integerValue]<[nowTime integerValue]) {
                                [[[UIAlertView alloc] initWithTitle:@"证件已过期" message:@"请重新拍摄或者选择证件图片" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                                return;
                            }
                            
                        }
                        
                        if (![CustomTool IsIdentityCard:dataDic[@"证号"][@"words"]]) {
                            [weakSelf createAlertView];
                            return;
                        }
                        
                        weakSelf.driveCarModelTextField.text = dataDic[@"准驾车型"][@"words"];
                        weakSelf.driveNameTextField.text = dataDic[@"姓名"][@"words"];
                        weakSelf.driveIDCardNumTextField.text = dataDic[@"证号"][@"words"];
                        weakSelf.driveSexTextField.text = dataDic[@"性别"][@"words"];
                        weakSelf.driveAddressTextField.text = dataDic[@"住址"][@"words"];
                        
                        weakSelf.driveImage = weakSelf.chooseImage;
                        [weakSelf driveChooseImageLayout];
                        [weakSelf.driveImageButton setImage:weakSelf.driveImage forState:UIControlStateNormal];
                        [weakSelf updataPic];
                        
                    }
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }];
                }];
            }
        }
    };
    
    _failHandler = ^(NSError *error){
        //        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:@"请重新拍摄或者选择证件图片" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}


- (void)driveChooseImageLayout{
    _driveImageLabel.hidden = NO;
    _driveInformationView.hidden = NO;
    _centerAlertLabel.hidden = NO;
    _centerView.height = 600-103+(kScreenW-55)/2*200/320;
    _bigScrollView.contentSize=CGSizeMake(0, _leftView.height + _centerView.height);
}


- (void)leftPicChooseViewLayout{
    _positiveImageLabel.hidden = NO;
    _personalInformationView.hidden = NO;
    _leftAlertLabel.hidden = NO;
    _positiveImageButton.selected = YES;
    _leftView.height = 366-103+(kScreenW-55)/2*200/320;
    _bigScrollView.contentSize=CGSizeMake(0, _leftView.height + _centerView.height);
    _centerView.top = _leftView.bottom;
}

- (void)leftPicChooseReverseLayout{
    _reverseImageLabel.hidden = NO;
    if (_positiveImageButton.selected) {
        
    }else{
        //更新布局
        _leftView.height = 237;
        _bigScrollView.contentSize=CGSizeMake(0, _leftView.height + _centerView.height);
    }
}

- (void)createAlertView{
    [[[UIAlertView alloc] initWithTitle:@"识别失败" message:@"请重新拍摄或者选择证件图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (void)updataPic{
    [JSFProgressHUD showHUDToView:self.view];
    NSData *imageData = UIImagePNGRepresentation(self.chooseImage);
    
    [VFHttpRequest uploadfile:imageData successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        [EasyTextView showSuccessText:@"上传成功"];
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        VFUpoladImageModel *obj = [[VFUpoladImageModel alloc]initWithDic:model.data];
        switch (self.selectorButton.tag) {
            case 1001:
                if (_isMine) {
                    self.positiveImageID = obj.picId;
                }else{
                    self.positiveImageID = obj.path;
                }
                break;
            case 1002:
                if (_isMine) {
                    self.reverseImageID = obj.picId;
                }else{
                    self.reverseImageID = obj.path;
                }
                break;
            case 1003:
                if (_isMine) {
                    self.driveImageID = obj.picId;
                }else{
                    self.driveImageID = obj.path;
                }
                break;
            default:
                break;
        }
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
        [ProgressHUD showError:@"上传失败"];
    }];

}

- (UIView *)createCenterView{
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, _leftView.bottom, kScreenW, 237)];
    UILabel *titleLabel = [UILabel initWithTitle:@"上传本人驾驶证，仅正面" withFont:kTitleBigSize textColor:kdetailColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    [_centerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(24);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *detailLabel = [UILabel initWithTitle:@"请横向拍摄正页，照片上不要有阴影和反光" withFont:kTextSize textColor:kdetailColor];
    [_centerView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(17);
    }];
    
    _driveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_driveImageButton setImage:[UIImage imageNamed:@"image_DrivingLicense"] forState:UIControlStateNormal];
    _driveImageButton.tag = 1003;
    [_driveImageButton addTarget:self action:@selector(takingPictures:) forControlEvents:UIControlEventTouchUpInside];
    _driveImageButton.adjustsImageWhenHighlighted = NO;
    [_centerView addSubview:_driveImageButton];
    
    [_driveImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(detailLabel.mas_bottom).offset(20);
        make.width.mas_equalTo((kScreenW-55)/2);
        make.height.mas_equalTo((kScreenW-55)/2*200/320);
    }];
    
    _driveImageLabel = [UILabel initWithTitle:@"恭喜您，上传成功" withFont:kTextSize textColor:kdetailColor];
    [_centerView addSubview:_driveImageLabel];
    [_driveImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_driveImageButton.mas_bottom).offset(15);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(17);
    }];
    
    
    _driveInformationView = [[UIView alloc]init];
    _driveInformationView.backgroundColor = kViewBgColor;
    _driveInformationView.layer.masksToBounds = YES;
    _driveInformationView.layer.cornerRadius = 2;
    [_centerView addSubview:_driveInformationView];
    [_driveInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_driveImageLabel.mas_bottom).offset(24);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(324);
    }];
    NSArray *leftArr = @[@"姓名",@"证号",@"性别",@"地址",@"准驾车型"];
    NSArray *placeArr = @[@"请输入姓名",@"请输入证号",@"请输入性别",@"请输入地址",@"请输入准驾车型"];
    for (int i = 0; i<leftArr.count; i++) {
        UILabel *label = [UILabel initWithTitle:leftArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        [_driveInformationView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(65*i);
            make.height.mas_equalTo(64);
            make.width.mas_equalTo(70);
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = [UIFont systemFontOfSize:kTitleBigSize];
        [textField setTextColor:kdetailColor];
        textField.placeholder = placeArr[i];
        textField.tag = 102+i;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_driveInformationView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.right.equalTo(_driveInformationView.mas_right).offset(-15);
            make.height.mas_equalTo(64);
            make.top.mas_equalTo(65*i);
        }];
        
        switch (i) {
            case 0:
                _driveNameTextField = textField;
                break;
            case 1:
                _driveIDCardNumTextField = textField;
                break;
            case 2:
                _driveSexTextField = textField;
                break;
            case 3:
                _driveAddressTextField = textField;
                break;
            case 4:
                _driveCarModelTextField = textField;
                break;
            default:
                break;
        }
        
    }
    _centerAlertLabel = [UILabel initWithTitle:@"*请确保身份信息准确无误" withFont:kTextSize textColor:kMainColor];
    [_centerView addSubview:_centerAlertLabel];
    [_centerAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_driveInformationView.mas_bottom).offset(10);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(17);
    }];
    
    
    _driveImageLabel.hidden = YES;
    _driveInformationView.hidden = YES;
    _centerAlertLabel.hidden = YES;
    return _centerView;
}

- (void)takingPictures:(UIButton *)sender{
    SEL funSel;
    switch (sender.tag) {
        case 1001:
            funSel = NSSelectorFromString(@"idcardOCROnlineFront");
            break;
        case 1002:
            funSel = NSSelectorFromString(@"idcardOCROnlineBack");
            break;
        case 1003:
            funSel = NSSelectorFromString(@"drivingLicenseOCR");
            break;
        default:
            funSel = NSSelectorFromString(@"idcardOCROnlineFront");
            break;
    }
    _selectorButton = sender;
    if (funSel) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:funSel];
#pragma clang diagnostic pop
    }
}

- (UIView *)createLeftView{
    _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 237)];
    UILabel *titleLabel = [UILabel initWithTitle:@"上传本人身份证正反面照片" withFont:kTitleBigSize textColor:kdetailColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    [_leftView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(24);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *detailLabel = [UILabel initWithTitle:@"请尽可能对准边框线，照片上不要有阴影和反光" withFont:kTextSize textColor:kNewDetailColor];
    [_leftView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(17);
    }];
    
    
    _positiveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_positiveImageButton setImage:[UIImage imageNamed:@"image_ID_front"] forState:UIControlStateNormal];
    _positiveImageButton.adjustsImageWhenHighlighted = NO;
    _positiveImageButton.tag = 1001;
    [_positiveImageButton addTarget:self action:@selector(takingPictures:) forControlEvents:UIControlEventTouchUpInside];
    [_leftView addSubview:_positiveImageButton];
    
    [_positiveImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(detailLabel.mas_bottom).offset(15);
        make.width.mas_equalTo((kScreenW-55)/2);
        make.height.mas_equalTo((kScreenW-55)/2*200/320);
    }];
    
    _reverseImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reverseImageButton setImage:[UIImage imageNamed:@"image_ID_back"] forState:UIControlStateNormal];
    _reverseImageButton.tag = 1002;
    [_reverseImageButton addTarget:self action:@selector(takingPictures:) forControlEvents:UIControlEventTouchUpInside];
    _reverseImageButton.adjustsImageWhenHighlighted = NO;
    [_leftView addSubview:_reverseImageButton];
    
    [_reverseImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_positiveImageButton.mas_right).offset(25);
        make.top.equalTo(_positiveImageButton);
        make.width.mas_equalTo((kScreenW-55)/2);
        make.height.mas_equalTo((kScreenW-55)/2*200/320);
    }];
    
    _positiveImageLabel = [UILabel initWithTitle:@"恭喜您，上传成功" withFont:kTextSize textColor:kdetailColor];
    _positiveImageLabel.textAlignment = NSTextAlignmentCenter;
    [_leftView addSubview:_positiveImageLabel];
    [_positiveImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_positiveImageButton.mas_bottom).offset(15);
        make.width.mas_equalTo((kScreenW-55)/2);
        make.height.mas_equalTo(17);
    }];
    
    _reverseImageLabel = [UILabel initWithTitle:@"恭喜您，上传成功" withFont:kTextSize textColor:kdetailColor];
    _reverseImageLabel.textAlignment = NSTextAlignmentCenter;
    [_leftView addSubview:_reverseImageLabel];
    [_reverseImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_reverseImageButton);
        make.top.equalTo(_positiveImageButton.mas_bottom).offset(15);
        make.width.mas_equalTo((kScreenW-55)/2);
        make.height.mas_equalTo(17);
    }];
    
    _personalInformationView = [[UIView alloc]init];
    _personalInformationView.backgroundColor = kViewBgColor;
    _personalInformationView.layer.masksToBounds = YES;
    _personalInformationView.layer.cornerRadius = 2;
    [_leftView addSubview:_personalInformationView];
    [_personalInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_positiveImageLabel.mas_bottom).offset(24);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(129);
    }];
    
    NSArray *leftArr = @[@"姓名",@"身份证号"];
    NSArray *placeArr = @[@"请输入姓名",@"请输入身份证号"];
    for (int i = 0; i<2; i++) {
        UILabel *label = [UILabel initWithTitle:leftArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        [_personalInformationView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(65*i);
            make.height.mas_equalTo(64);
            make.width.mas_equalTo(70);
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = [UIFont systemFontOfSize:kTitleBigSize];
        [textField setTextColor:kdetailColor];
        textField.placeholder = placeArr[i];
        textField.tag = 100+i;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_personalInformationView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.right.equalTo(_personalInformationView.mas_right).offset(-15);
            make.height.mas_equalTo(64);
            make.top.mas_equalTo(65*i);
        }];
        
        switch (i) {
            case 0:
                _idCardNameTextField = textField;
                break;
            case 1:
                _idCardNumTextField = textField;
                break;
            default:
                break;
        }
        
    }
    
    _positiveImageLabel.hidden = YES;
    _reverseImageLabel.hidden = YES;
    _personalInformationView.hidden = YES;
    _leftAlertLabel.hidden = YES;
    
    return _leftView;
}

//限制输入框字符串长度
- (void)textFieldDidChange:(UITextField *)textField{
    NSArray *dataArr = @[@"10",@"18",@"10",@"18",@"1",@"50",@"10"];
    
    NSString * length = dataArr[textField.tag-100];
    if (textField.text.length > [length intValue]) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return;
        }
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:[length intValue]];
        textField.text = [textField.text substringToIndex:range.location];
    }
}

#pragma mark-----------百度AI身份识别-------------------
//身份证正面拍照识别
- (void)idcardOCROnlineFront {
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
                                 andImageHandler:^(UIImage *image) {
                                     _chooseImage = image;
                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:_successHandler
                                                                                  failHandler:_failHandler];
                                 }];
    [self presentViewController:vc animated:YES completion:nil];
    
}
//身份证反面拍照识别
- (void)idcardOCROnlineBack{
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack
                                 andImageHandler:^(UIImage *image) {
                                     _chooseImage = image;
                                     [[AipOcrService shardService] detectIdCardBackFromImage:image
                                                                                 withOptions:nil
                                                                              successHandler:_successHandler
                                                                                 failHandler:_failHandler];
                                 }];
    [self presentViewController:vc animated:YES completion:nil];
}

//驾驶证识别
- (void)drivingLicenseOCR{
    _driveVC = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        _chooseImage = image;
        [JSFProgressHUD showHUDToView:_driveVC.view];
        [[AipOcrService shardService] detectDrivingLicenseFromImage:image
                                                        withOptions:nil
                                                     successHandler:_successHandler
                                                        failHandler:_failHandler];
        
    }];
    [self presentViewController:_driveVC animated:YES completion:nil];
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
