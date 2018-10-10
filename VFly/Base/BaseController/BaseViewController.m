//
//  BaseViewController.m
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import "BaseViewController.h"
#import "VFNavigationBar.h"

@interface BaseViewController ()
@end

@implementation BaseViewController{
    
    NSInteger _hidenControlOptions;
    CGFloat _scrolOffsetY;
    UIScrollView * _keyScrollView;
    CGFloat _alpha;
    UIImage * _navBarBackgroundImage;
    UILabel * _centerBlodLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = kWhiteColor;
    self.navigationController.navigationBar.hidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self initNavigationBar];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //注册网络改变通知
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkConnectionState:) name:kNetworkConnectionState object:nil];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _navBarBackgroundImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    });
//    设置背景图片
    [self.navigationController.navigationBar setBackgroundImage:_navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
//    清除边框，设置一张空的图片
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    [self setNavSubViewsAlpha];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    self.navTitleLabel.alpha = 1;
}


- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)networkConnectionState:(NSNotification *)notification {
    if ([self respondsToSelector:@selector(networkChanged:)])
    {
        [self networkChanged:notification.object];
    }
}


#pragma mark - private methods

- (void)initNavigationBar {
    if (!_navigationBar)
    {
        _navigationBar = [[VFNavigationBar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarH)];
    }
    [self.view addSubview:_navigationBar];
    if (self.navigationController)
    {
        if (self.navigationController.viewControllers[0] == self)
        {
            self.leftButton.hidden = YES;
            self.backImage.hidden = YES;
        }
        else
        {
            self.leftButton.hidden = NO;
        }
    }
    // 默认左侧返回按钮
    __weak typeof(self) weakSelf = self;
    // 给左侧按钮添加默认事件
    _navigationBar.leftBtnClickHandler = ^() {
        
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf defaultLeftBtnClick];
    };
    
    _navigationBar.rightBtnClickHandler = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf defaultRightBtnClick];
    };
}


- (void)defaultLeftBtnClick {
    NSAssert(self.navigationController, @"self.navigationController == nil");
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)defaultRightBtnClick{
    
}


#pragma mark - getter/setter

- (void)setNavSandow:(BOOL)navSandow {
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shadow"]];
    imageView.frame = CGRectMake(0, kNavBarH, kScreenW, 10);
    [self.view addSubview:imageView];
}

- (void)setNavBottomImageHidden:(BOOL)navBottomImageHidden {
    _navigationBar.navlineImage.hidden = YES;
}

- (void)setCenterBlodTitle:(NSString *)centerBlodTitle {
    if (!_centerBlodLabel)
    {
        _centerBlodLabel = [UILabel initWithTitle:centerBlodTitle withFont:kTitleSize textColor:kTitleBoldColor];
        _centerBlodLabel.textAlignment = NSTextAlignmentCenter;
        [_centerBlodLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleSize]];
        _centerBlodLabel.frame = CGRectMake(15, kNavBarH+30, kScreenW-30, 25);
        [self.view addSubview:_centerBlodLabel];
    }
    else
    {
        _centerBlodLabel.text = centerBlodTitle;
    }
}

- (void)setTitleStr:(NSString *)titleStr {
    
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, kNavBarH, kScreenW, kNavTitleH);
    UILabel *label = [UILabel initWithNavTitle:titleStr];
    label.frame = CGRectMake(15, 0, kScreenW-30, kNavTitleH);
    label.font = [UIFont systemFontOfSize:kNewBigTitle];
    [headerView addSubview:label];
    [self.view addSubview:headerView];
}

- (UILabel *)navTitleLabel {
    [_navigationBar.titleLabel sizeToFit];
    return _navigationBar.titleLabel;
}

- (UIButton *)leftButton {
    NSAssert(_navigationBar, @"_navigationBar == nil");
    if (_navigationBar) {
        return _navigationBar.leftBtn;
    }
    return nil;
}

- (UIImageView *)navlineImage {
    if (_navigationBar) {
        return _navigationBar.navlineImage;
    }
    return nil;
}

- (UIImageView *)navRightImage {
    if (_navigationBar) {
        return _navigationBar.navRightImage;
    }
    return nil;
}

- (UIButton *)rightButton {
    NSAssert(_navigationBar, @"_navigationBar == nil");
    if (_navigationBar) {
        return _navigationBar.rightBtn;
    }
    return nil;
}

- (UIImageView *)backImage {
    NSAssert(_navigationBar, @"_navigationBar == nil");
    if (_navigationBar) {
        return _navigationBar.backImage;
    }
    return nil;
}

- (UILabel *)navRightLabel {
    return _navigationBar.rightLabel;
}

#pragma mark - public methods
- (void)replaceDefaultNavBar:(UIView *)nav {
    NSAssert(nav, @"nav == nil");
    if (nav) {
        [_navigationBar removeFromSuperview];
        _navigationBar = nil;
        [self.view addSubview:nav];
    }
}

#pragma mark - 创建导航栏
- (void)createNaviBar {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 100, 25)];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //设置为标题
}

- (void)setTitle:(NSString *)title {
    // _title 是一个 @package 修饰的属性 所以不能直接修改
    // 所以需要使用父类中的setTitle方法来修改_title
    
    [super setTitle:title];
    _titleLabel.text = title;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNetworkConnectionState object:nil];
    [_keyScrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [JSFProgressHUD hiddenHUD:self.view];
}


- (void)setKeyScrollView:(UIScrollView * )keyScrollView
            scrolOffsetY:(CGFloat)scrolOffsetY
                 options:(HYHidenControlOptions)options {
    
    _keyScrollView = keyScrollView;
    _hidenControlOptions = options;
    _scrolOffsetY = scrolOffsetY;
    
    [_keyScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    CGPoint point = _keyScrollView.contentOffset;
    _alpha =  point.y/_scrolOffsetY;
    _alpha = (_alpha <= 0)?0:_alpha;
    _alpha = (_alpha >= 1)?1:_alpha;
    
    [self setNavSubViewsAlpha];
}



- (void)setNavSubViewsAlpha {
    
    self.navTitleLabel.alpha = _hidenControlOptions >> 1 & 1 ?_alpha:1;
    self.navlineImage.alpha = _hidenControlOptions >> 1 & 1 ?_alpha:1;
    
}



@end
