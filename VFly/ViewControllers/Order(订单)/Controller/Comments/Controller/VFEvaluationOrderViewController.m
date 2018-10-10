//
//  VFEvaluationOrderViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/9/20.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFEvaluationOrderViewController.h"
#import "XHStarRateView.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"

#define TextViewDefaultText @"请对威风出行的服务作出评价和意见，您的建议是我们努力的方向！"
@interface VFEvaluationOrderViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,XHStarRateViewDelegate,UITextViewDelegate> {

    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *evaluationOrderText;
@property (nonatomic, strong) NSMutableArray *uploadImageIdArr;
@property (nonatomic, strong) NSMutableArray *unUploadImageArr;
@property (nonatomic, strong) NSString *compositeScore;
@property (nonatomic, strong) NSMutableArray *chooseScoreArr;
@property (nonatomic, strong) NSArray *starShowText;
@property (nonatomic, strong) UILabel *topStarLabel;
@property (nonatomic, strong) UILabel *appearanceLabel;
@property (nonatomic, strong) UILabel *theCarLabel;
@property (nonatomic, strong) UILabel *serviceLabel;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;


@end

@implementation VFEvaluationOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"comment";
    self.titleStr = @"综合评价";
    _compositeScore = @"5";
    _evaluationOrderText = @"";
    _chooseScoreArr = [NSMutableArray arrayWithObjects:@"5",@"5",@"5",@"5", nil];
    _starShowText = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
    _uploadImageIdArr = [[NSMutableArray alloc]init];
    _unUploadImageArr = [[NSMutableArray alloc]init];
    [self createView];
}

- (void)createView {
    //星星评分
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHeaderH, kScreenW, kScreenH -kHeaderH-kSafeBottomH-44)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0, 640);
    
    NSArray *titleArr = @[@"客服服务体验",@"车管服务体验",@"送车服务体验",@"还车服务态度"];

    for (int i =0; i<4; i++)
    {
        UILabel *leftLabel = [UILabel initWithTitle:titleArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        leftLabel.frame = CGRectMake(15, 19+i*34, 100, 34);
        [_scrollView addSubview:leftLabel];
        
        XHStarRateView *starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(leftLabel.right, leftLabel.top + 6, 170, 22)];
        starView.isAnimation = YES;
        starView.rateStyle = WholeStar;
        starView.tag = i;
        starView.delegate = self;
        [_scrollView addSubview:starView];
        
        UILabel *rightLabel = [UILabel initWithTitle:@"非常好" withFont:kTextBigSize textColor:kdetailColor];
        rightLabel.frame = CGRectMake((kScreenW - 165)/2 + 210,  19+i*34, 70, 34);
        [_scrollView addSubview:rightLabel];
        
        switch (i)
        {
            case 0:
                _appearanceLabel = rightLabel;
                break;
            case 1:
                _theCarLabel = rightLabel;
                break;
            case 2:
                _serviceLabel = rightLabel;
                break;
            case 3:
                _topStarLabel = rightLabel;
            default:
                break;
        }
    }
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 19+4*34+30, kScreenW-20, 61)];
    _textView.text = TextViewDefaultText;
    _textView.textColor = [UIColor lightGrayColor];
    _textView.delegate = self;
    _textView.layer.borderColor = UIColor.grayColor.CGColor;
    _textView.layer.borderWidth = 1;
    _textView.font = [UIFont systemFontOfSize:kTitleBigSize];
    [_scrollView addSubview:_textView];
    
    [self configCollectionView];
    
    UIButton *button = [UIButton newButtonWithTitle:@"确定"  sel:@selector(sureButtonClick) target:self cornerRadius:NO];
    button.frame = CGRectMake(0, kScreenH-49, kScreenW, 49);
    [self.view addSubview:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   [self.view endEditing:YES];
}

#pragma mark --------TextViewDelegate------
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:TextViewDefaultText])
    {
        textView.text = @"";
        _evaluationOrderText = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:TextViewDefaultText])
    {
        _evaluationOrderText = @"";
    }
    else if ([textView.text isEqualToString:@""])
    {
    }
    else
    {
        _evaluationOrderText = textView.text;
    }
}


- (void)sureButtonClick {
    [JSFProgressHUD showHUDToView:self.view];
    if (_isNew)
    {
        if (_selectedPhotos.count != 0)
        {
            for (UIImage *image in _selectedPhotos) {
                NSData *data = UIImageJPEGRepresentation(image, 0.5);
                [VFHttpRequest uploadfile:data successBlock:^(NSDictionary *data) {
                    VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                    VFUpoladImageModel *obj = [[VFUpoladImageModel alloc]initWithDic:model.data];
                    [_uploadImageIdArr addObject: obj.picId];
            
                    if (_uploadImageIdArr.count == _selectedPhotos.count)
                    {
                        if (_unUploadImageArr.count == 0)
                        {
                            NSString *dataArrStr = @"";
                            for (int i=0;i<_uploadImageIdArr.count;i++) {
                                if (i == _uploadImageIdArr.count-1)
                                {
                                    dataArrStr  = kFormat(@"%@%@",dataArrStr, _uploadImageIdArr[i]);
                                }
                                else if(i==0)
                                {
                                    dataArrStr  = kFormat(@"%@,", _uploadImageIdArr[i]);
                                }
                                else
                                {
                                    dataArrStr  = kFormat(@"%@%@,",dataArrStr, _uploadImageIdArr[i]);
                                }
                            }
                            
                            NSDictionary *dic = @{@"order_id":_orderID,
                                                  @"customer_service":_chooseScoreArr[0],
                                                  @"car_manager_service":_chooseScoreArr[1],
                                                  @"sent_car_service":_chooseScoreArr[2],
                                                  @"return_car_service":_chooseScoreArr[3],
                                                  @"evaluation_content":_evaluationOrderText,
                                                  @"image_ids":dataArrStr};
                            [JSFProgressHUD hiddenHUD:self.view];
                            
                            [VFHttpRequest orderEvaluationParameter:dic
                                                       SuccessBlock:^(NSDictionary *data) {
                                [JSFProgressHUD hiddenHUD:self.view];
                                [self.navigationController popViewControllerAnimated:YES];
                                                       } withFailureBlock:^(NSError *error) {
                                                           [JSFProgressHUD hiddenHUD:self.view];
                                                       }];
                        }
                        else
                        {
                            [JSFProgressHUD hiddenHUD:self.view];
                            HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:kFormat(@"%ld成功，%ld失败",_uploadImageIdArr.count,_unUploadImageArr.count)];
                            HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
                            [alertVC addAction:cancelAction];
                            HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"继续上传" handler:^(HCAlertAction *action) {
                                _selectedPhotos = _unUploadImageArr;
                            }];
                            [alertVC addAction:updateAction];
                            [self presentViewController:alertVC animated:NO completion:nil];
                        }
                    }
                    
                } withFailureBlock:^(NSError *error) {
                    [_unUploadImageArr addObject:image];
                }];
            }
        }
        else
        {
            NSDictionary *dic = @{@"order_id":_orderID,
                                  @"customer_service":_chooseScoreArr[0],
                                  @"car_manager_service":_chooseScoreArr[1],
                                  @"sent_car_service":_chooseScoreArr[2],
                                  @"return_car_service":_chooseScoreArr[3],
                                  @"evaluation_content":_evaluationOrderText};
            [JSFProgressHUD hiddenHUD:self.view];

            [VFHttpRequest orderEvaluationParameter:dic SuccessBlock:^(NSDictionary *data) {
                VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                [JSFProgressHUD hiddenHUD:self.view];
                if ([model.code intValue] == 1)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [ProgressHUD showError:model.message];
                }
            } withFailureBlock:^(NSError *error) {
                [JSFProgressHUD hiddenHUD:self.view];
            }];
        }
    }
    else
    {
        for (UIImage *image in _selectedPhotos) {
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            [HttpManage uploadFileImage:data success:^(NSDictionary *data) {
                HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                if ([model.info isEqualToString:@"ok"])
                {
                    VFUpoladImageModel *obj = [[VFUpoladImageModel alloc]initWithDic:model.data];
                    [_uploadImageIdArr addObject: obj.picId];
                }
                else
                {
                    [_unUploadImageArr addObject:image];
                }
                
                if (_uploadImageIdArr.count == _selectedPhotos.count) {
                    if (_unUploadImageArr.count == 0) {
                        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
                        NSString *dataArrStr = @"";
                        for (int i=0;i<_uploadImageIdArr.count;i++) {
                            if (i == _uploadImageIdArr.count-1)
                            {
                                dataArrStr  = kFormat(@"%@%@",dataArrStr, _uploadImageIdArr[i]);
                            }
                            else if(i==0)
                            {
                                dataArrStr  = kFormat(@"%@,", _uploadImageIdArr[i]);
                            }
                            else
                            {
                                dataArrStr  = kFormat(@"%@%@,",dataArrStr, _uploadImageIdArr[i]);
                            }
                        }
                        
                        NSDictionary *dic = @{@"order_id":_orderID,
                                              @"composite_score":_chooseScoreArr[0],
                                              @"appearance_score":_chooseScoreArr[1],
                                              @"clean_score":_chooseScoreArr[2],
                                              @"attitude_score":_chooseScoreArr[3],
                                              @"evaluation_content":_evaluationOrderText};
                        [VFHttpRequest orderEvaluationParameter:dic SuccessBlock:^(NSDictionary *data) {
                            VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
                            [JSFProgressHUD hiddenHUD:self.view];
                            if ([model.code intValue] == 1)
                            {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else
                            {
                                [ProgressHUD showError:model.message];
                            }
                        } withFailureBlock:^(NSError *error) {
                            [JSFProgressHUD hiddenHUD:self.view];

                        }];
                        
                    }
                    else
                    {
                        [JSFProgressHUD hiddenHUD:self.view];
                        HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:kFormat(@"%ld成功，%%ld失败",_uploadImageIdArr.count,_unUploadImageArr.count)];
                        HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
                        [alertVC addAction:cancelAction];
                        HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"继续上传" handler:^(HCAlertAction *action) {
                            _selectedPhotos = _unUploadImageArr;
                        }];
                        [alertVC addAction:updateAction];
                        [self presentViewController:alertVC animated:NO completion:nil];
                    }
                }
            } failedBlock:^{
                [_unUploadImageArr addObject:@""];
            }];
        }
        
    }
}

#pragma mark --------------选择星之后的方法回调-------
-(void)starRateView:(XHStarRateView *)starRateView
       currentScore:(CGFloat)currentScore {
    NSString *temp = kFormat(@"%f", currentScore);
    
    int score = [temp intValue];
    NSString *noPointScore = kFormat(@"%d", score);
    switch (starRateView.tag) {
        case 0:
            _appearanceLabel.text = _starShowText[score-1];
            break;
        case 1:
            _theCarLabel.text = _starShowText[score-1];
            break;
        case 2:
            _serviceLabel.text = _starShowText[score-1];
            break;
        case 3:{
            _topStarLabel.text = _starShowText[score-1];
        }
            break;
        default:
            break;
    }

}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width-30 - 2 * _margin - 4) / 5 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 300, kScreenW-30, 200) collectionViewLayout:layout];
    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kWhiteColor;
    _collectionView.bounces = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_scrollView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count <9)
    {
        return _selectedPhotos.count + 1;
    }
    else
    {
        return _selectedPhotos.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count)
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_cameraTalk"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.text = @"123";
    }
    else
    {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.gifLable.hidden = YES;
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _selectedPhotos.count)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        [sheet showInView:self.view];
    }
    else
    {
        // preview photos or video / 预览照片或者视频
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = 9;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.circleCropRadius = 100;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later)
    {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    }
    else if ([[TZImageManager manager] authorizationStatus] == 2)
    { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    }
    else if ([[TZImageManager manager] authorizationStatus] == 0)
    { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    }
    else
    { // 调用相机
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        // 设置代理
        ipc.delegate = self;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 显示控制器
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error)
            {
                [tzImagePickerVc hideProgressHUD];
            }
            else
            {
                [[TZImageManager manager] getCameraRollAlbum:NO
                                           allowPickingImage:YES
                                                  completion:^(TZAlbumModel *model) {
                                                      
                                                      
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result
                                                     allowPickingVideo:NO
                                                     allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate)
                        {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    
    [self.selectedAssets addObject:asset];
    [self.selectedPhotos addObject:image];
    
    [_collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]])
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    { // take photo / 去拍照
        [self takePhoto];
    }
    else if (buttonIndex == 1)
    {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    { // 去设置界面，开启相机访问权限
        if (iOS8Later)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        else
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView reloadData];
}

- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets)
    {
        _selectedAssets = [NSMutableArray new];
    }
    return _selectedAssets;
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos)
    {
        _selectedPhotos = [NSMutableArray new];
    }
    return _selectedPhotos;
}


#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets)
    {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        }
        else if ([asset isKindOfClass:[ALAsset class]])
        {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
    }
}




- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma clang diagnostic pop





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
