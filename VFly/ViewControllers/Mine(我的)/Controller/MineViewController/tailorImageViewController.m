//
//  tailorImageViewController.m
//  LuxuryCar
//
//  Created by Hcar on 2017/6/7.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "tailorImageViewController.h"
#import "TKImageView.h"

@interface tailorImageViewController ()
@property (nonatomic, strong) IBOutlet TKImageView *tkImageView;

@end

@implementation tailorImageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTKImageView];
    [self setNavBar];
}

- (void)setNavBar{
    self.title = @"个人资料";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
//    rightItem.tintColor = [UIColor whiteColor];
}

- (void)saveAction:(UIBarButtonItem *)sender {
    if ([_delegate respondsToSelector:@selector(senderImage:)]) {
        [_delegate senderImage:[_tkImageView currentCroppedImage]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTKImageView {
    _tkImageView = [[TKImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64)];
    [self.view addSubview:_tkImageView];
    _tkImageView.toCropImage = self.pic;
//    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
//    _tkImageView.showCrossLines = YES;
//    _tkImageView.cornerBorderInImage = NO;
//    _tkImageView.cropAreaCornerWidth = 44;
//    _tkImageView.cropAreaCornerHeight = 44;
//    _tkImageView.minSpace = 30;
//    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
//    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
//    _tkImageView.cropAreaCornerLineWidth = 6;
//    _tkImageView.cropAreaBorderLineWidth = 4;
//    _tkImageView.cropAreaMidLineWidth = 20;
//    _tkImageView.cropAreaMidLineHeight = 6;
//    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
//    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
//    _tkImageView.cropAreaCrossLineWidth = 4;
    _tkImageView.initialScaleFactor = .8f;
    _tkImageView.cropAspectRatio = 1.0;
    
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
