//
//  VFIdentityAuthenticationViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/12/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFIdentityAuthenticationViewController.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>

@interface VFIdentityAuthenticationViewController ()<UIAlertViewDelegate>

@property (nonatomic , strong)UIView *leftView;

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

@implementation VFIdentityAuthenticationViewController{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AipOcrService shardService] authWithAK:@"IAGAljbyiIPVWzbpeN0Iz3Rh" andSK:@"OiZriq8IXlaAC2hpWL0QVYwFGuRVU5A2"];
    [self configCallback];
    self.titleStr =@"身份验证";
    [self createView];
    [self createHeaderViewInder:1];
}

- (void)createView{
    _bigScrollView = [[UIScrollView alloc]init];
    _bigScrollView.frame = CGRectMake(0, kOldNavBarH, kScreenW, kScreenH-kOldNavBarH);
    [self.view addSubview:_bigScrollView];
    if ([_card_status intValue] == 1) {
        _bigScrollView.contentOffset=CGPointMake(kScreenW, 0);
    }else{
        _bigScrollView.contentOffset=CGPointMake(0, 0);
    }
    [_bigScrollView setScrollEnabled:NO];
    for (int i=0; i<3; i++) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(kScreenW*i, 0, kScreenW, _bigScrollView.height);
        [_bigScrollView addSubview:view];
        [view addSubview:[self createHeaderViewInder:i]];
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.contentSize=CGSizeMake(0, _bigScrollView.height-68);
        switch (i) {
            case 0:
                [scrollView addSubview:[self createLeftView]];
                _leftSCrollView = scrollView;
                break;
            case 1:
                [scrollView addSubview:[self createCenterView]];
                _centerSCrollView = scrollView;
                break;
            case 2:
                [scrollView addSubview:[self createRightView]];
                _rightSCrollView = scrollView;
                break;
            default:
                break;
        }
        scrollView.contentOffset=CGPointMake(0, 0);
        scrollView.frame = CGRectMake(0, 68, kScreenW, _bigScrollView.height-68);
        _centerSCrollView.contentSize = CGSizeMake(0, 454);
        [view addSubview:scrollView];
    }
}

- (UIView *)createRightView{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, _bigScrollView.height-68)];

    UILabel *alertLabel = [UILabel initWithTitle:@"恭喜您，您已通过验证" withFont:kTitleSize textColor:kdetailColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:alertLabel];
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(22);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(rightView);
    }];
    
    UIImageView *showImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_complete"]];
    [rightView addSubview:showImageView];
    [showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(100);
        make.centerX.mas_equalTo(rightView);
        make.bottom.equalTo(alertLabel.mas_top).offset(-15);
    }];
    
    UIButton *nextbutton = [UIButton newButtonWithTitle:@"确定" sel:@selector(sureButtonClick) target:self cornerRadius:YES];
    [rightView addSubview:nextbutton];
    [nextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-24);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(44);
    }];
    
    return rightView;
}

- (UIView *)createCenterView{
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 444+422)];
    UILabel *titleLabel = [UILabel initWithTitle:@"上传本人驾驶证，仅正面" withFont:kTitleBigSize textColor:kdetailColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleBigSize]];
    [centerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(24);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *detailLabel = [UILabel initWithTitle:@"请横向拍摄正页，照片上不要有阴影和反光" withFont:kTextSize textColor:kdetailColor];
    [centerView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(17);
    }];
    
    _driveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_driveImageButton setImage:[UIImage imageNamed:@"image_driving license"] forState:UIControlStateNormal];
    _driveImageButton.tag = 1003;
    [_driveImageButton addTarget:self action:@selector(takingPictures:) forControlEvents:UIControlEventTouchUpInside];
    _driveImageButton.adjustsImageWhenHighlighted = NO;
    [centerView addSubview:_driveImageButton];
    
    [_driveImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(detailLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo((kScreenW-30)*237/345);
    }];
    
    _driveImageLabel = [UILabel initWithTitle:@"恭喜您，上传成功" withFont:kTextSize textColor:kdetailColor];
    _driveImageLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:_driveImageLabel];
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
    [centerView addSubview:_driveInformationView];
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
    [centerView addSubview:_centerAlertLabel];
    [_centerAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_driveInformationView.mas_bottom).offset(10);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(17);
    }];
    
    
    _driveNextbutton = [UIButton newButtonWithTitle:@"下一步" sel:@selector(secondButtonClick) target:self cornerRadius:YES];
    [centerView addSubview:_driveNextbutton];
    [_driveNextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_driveImageButton.mas_bottom).offset(30);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(44);
    }];
    
    _driveImageLabel.hidden = YES;
    _driveInformationView.hidden = YES;
    _centerAlertLabel.hidden = YES;
    return centerView;
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
    _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 503)];
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
    _leftAlertLabel = [UILabel initWithTitle:@"*请确保身份信息准确无误" withFont:kTextSize textColor:kMainColor];
    [_leftView addSubview:_leftAlertLabel];
    [_leftAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_personalInformationView.mas_bottom).offset(10);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(17);
    }];
    
    _leftNextbutton = [UIButton newButtonWithTitle:@"下一步" sel:@selector(nextButtonClick) target:self cornerRadius:YES];
    [_leftView addSubview:_leftNextbutton];
    [_leftNextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_positiveImageButton.mas_bottom).offset(30);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(44);
    }];
    
    _leftCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftCancelButton setTitle:@"暂不认证" forState:UIControlStateNormal];
    [_leftCancelButton.titleLabel setFont:[UIFont systemFontOfSize:kTextSize]];
    [_leftCancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_leftCancelButton setTitleColor:kNewDetailColor forState:UIControlStateNormal];
    [_leftView addSubview:_leftCancelButton];
    [_leftCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_leftView);
        make.top.equalTo(_leftNextbutton.mas_bottom);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(71);
    }];
    
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

- (void)cancelButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonClick{
    if ([_idCardNameTextField.text isEqualToString:@""] || [_idCardNumTextField.text isEqualToString:@""]) {
        [CustomTool alertViewShow:@"请将信息补充完整"];
        return;
    }
    if (![CustomTool IsIdentityCard:_idCardNumTextField.text]) {
        [CustomTool alertViewShow:@"身份证格式不正确"];
        return;
    }

    if (_positiveImageID && _reverseImageID) {
        [JSFProgressHUD showHUDToView:self.view];
        NSDictionary *dataDic = @{@"card_face":_positiveImageID,@"card_back":_reverseImageID,@"name":_idCardNameTextField.text,@"card_num":_idCardNumTextField.text};
        [VFHttpRequest addUsermanUsermanID:_userID Parameter:dataDic successBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            if ([model.code intValue] == 1) {
                [_bigScrollView setScrollEnabled:YES];
                _bigScrollView.contentOffset = CGPointMake(kScreenW, 0);
                [_bigScrollView setScrollEnabled:NO];
            }else{
                [CustomTool alertViewShow:@"提交失败，如有疑问请联系客服"];
            }
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
            [ProgressHUD showError:@"提交失败"];
        }];
    }else{
        [CustomTool alertViewShow:@"请将信息补充完整"];
    }
}

- (void)secondButtonClick{
    if ([_driveNameTextField.text isEqualToString:@""] || [_driveIDCardNumTextField.text isEqualToString:@""] || [_driveSexTextField.text isEqualToString:@""] || [_driveAddressTextField.text isEqualToString:@""] || [_driveCarModelTextField.text isEqualToString:@""]) {
        [CustomTool alertViewShow:@"请将信息补充完整"];
        return;
    }
    
    if (![CustomTool IsIdentityCard:_driveIDCardNumTextField.text]) {
        [CustomTool alertViewShow:@"证件格式不正确"];
        return;
    }
    
    if (_driveImageID) {
        NSDictionary *dataDic = @{@"name":_driveNameTextField.text,@"driving_num":_driveIDCardNumTextField.text,@"sex":_driveSexTextField.text,@"address":_driveAddressTextField.text,@"allow_car_model":_driveCarModelTextField.text,@"driving_licence":_driveImageID};
        [JSFProgressHUD showHUDToView:self.view];
        [VFHttpRequest addUsermanUsermanID:_userID Parameter:dataDic successBlock:^(NSDictionary *data) {
            [JSFProgressHUD hiddenHUD:self.view];
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            if ([model.code intValue] == 1) {
                [_bigScrollView setScrollEnabled:YES];
                _bigScrollView.contentOffset = CGPointMake(kScreenW*2, 0);
                [_bigScrollView setScrollEnabled:NO];
            }else{
                [CustomTool alertViewShow:model.message];
            }
        } withFailureBlock:^(NSError *error) {
            [JSFProgressHUD hiddenHUD:self.view];
            [ProgressHUD showError:@"提交失败"];
        }];
    }else{
        [CustomTool alertViewShow:@"请将信息补充完整"];
    }
}

- (void)sureButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(identityAuthenticationVCcomplete)]) {
        [self.delegate identityAuthenticationVCcomplete];
    }
}

- (UIView *)createHeaderViewInder:(int)index{
    NSArray *bottomArr = @[@"上传身份证",@"上传驾照",@"验证成功"];
    
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, kScreenW, 68);
    
    for (int i=0; i<3; i++) {
        NSString *steps = kFormat(@"%d", i+1);
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(kScreenW/3*i, 0, kScreenW/3, 68);
        [headerView addSubview:bgView];
        
        UILabel *topLabel = [UILabel initWithTitle:steps withFont:kTitleBigSize textColor:kdetailColor];
        topLabel.backgroundColor = kNewboderColor;
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.layer.masksToBounds = YES;
        topLabel.layer.cornerRadius = 11;
        [bgView addSubview:topLabel];
        
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(22);
        }];
        
        UIView *leftLineView = [[UIView alloc]init];
        leftLineView.backgroundColor = kNewboderColor;
        [bgView addSubview:leftLineView];

        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(9);
            make.right.equalTo(topLabel.mas_left);
            make.height.mas_equalTo(4);
        }];

        UIView *rightLineView = [[UIView alloc]init];
        rightLineView.backgroundColor = kNewboderColor;
        [bgView addSubview:rightLineView];

        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topLabel.mas_right);
            make.top.mas_equalTo(9);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(4);
        }];
        
        if (i==0) {
            leftLineView.hidden = YES;
        }
        
        if (i==2) {
            rightLineView.hidden = YES;
        }
        
        UILabel *bottomLabel = [UILabel initWithTitle:bottomArr[i] withFont:kTextBigSize textColor:kdetailColor];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            make.top.equalTo(topLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(kScreenW/3);
            make.height.mas_equalTo(20);
        }];
        
        if (i == index) {
            topLabel.backgroundColor = kMainColor;
            topLabel.textColor = kWhiteColor;
            [bottomLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTextBigSize]];
        }
        
    }
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = kNewboderColor;
    [headerView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenW-30);
        make.bottom.mas_equalTo(headerView);
        make.height.mas_equalTo(1);
    }];
    return headerView;
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

#pragma mark -----------百度AI识别结果回调-----------
- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    // 这是默认的识别成功的回调
    [JSFProgressHUD hiddenHUD:_driveVC.view];
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

- (void)createAlertView{
    [[[UIAlertView alloc] initWithTitle:@"识别失败" message:@"请重新拍摄或者选择证件图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (void)updataPic{
    [JSFProgressHUD showHUDToView:self.view];
    NSData *imageData = UIImagePNGRepresentation(self.chooseImage);
    [VFHttpRequest uploadfile:imageData successBlock:^(NSDictionary *data) {
        [JSFProgressHUD hiddenHUD:self.view];
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        if ([model.code intValue] == 1) {
            [EasyTextView showSuccessText:@"上传成功"];
            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
            VFUpoladImageModel *obj = [[VFUpoladImageModel alloc]initWithDic:model.data];
            switch (self.selectorButton.tag) {
                case 1001:
                    self.positiveImageID = obj.path;
                    break;
                case 1002:
                    self.reverseImageID = obj.path;
                    break;
                case 1003:
                    self.driveImageID = obj.path;
                    break;
                default:
                    break;
            }
        }else{
            [ProgressHUD showError:@"上传失败"];
        }
        
    } withFailureBlock:^(NSError *error) {
        [JSFProgressHUD hiddenHUD:self.view];
        [ProgressHUD showError:@"上传失败"];
    }];
}


- (void)driveChooseImageLayout{
    _centerSCrollView.contentSize=CGSizeMake(0, 444+422);
    _driveImageLabel.hidden = NO;
    _driveInformationView.hidden = NO;
    _centerAlertLabel.hidden = NO;
    [_driveNextbutton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_driveImageButton.mas_bottom).offset(437);
    }];
     _bigScrollView.contentOffset=CGPointMake(kScreenW, 0);
}


- (void)leftPicChooseViewLayout{
    _leftSCrollView.contentSize=CGSizeMake(0, 503+22);
    _positiveImageLabel.hidden = NO;
    _personalInformationView.hidden = NO;
    _leftAlertLabel.hidden = NO;
    _positiveImageButton.selected = YES;
    [_leftNextbutton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_positiveImageButton.mas_bottom).offset(242);
    }];
    
    [_leftCancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftNextbutton.mas_bottom);
    }];
}

- (void)leftPicChooseReverseLayout{
    _reverseImageLabel.hidden = NO;
    if (_positiveImageButton.selected) {
        
    }else{
        [_leftNextbutton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_positiveImageButton.mas_bottom).offset(56);
        }];
        [_leftCancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_leftNextbutton.mas_bottom);
        }];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
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
