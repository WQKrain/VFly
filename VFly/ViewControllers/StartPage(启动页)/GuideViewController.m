//
//  GuideViewController.m
//  WXMovie
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import "GuideViewController.h"
#import "MainTabBarController.h"
#import "Header.h"

@interface GuideViewController ()<UIScrollViewDelegate>

{
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) UIPageControl *pageC;

@end

@implementation GuideViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"guidePage"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [MobClick endLogPageView:@"guidePage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建滚动视图
    [self _createScrollView];
    
}

#pragma mark - Delegate / Data Source

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageC.currentPage = scrollView.contentOffset.x / kScreenW;
}

#pragma mark - Private Methods

- (void)_createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //设置内容尺寸
    _scrollView.contentSize = CGSizeMake(kScreenW*3, kScreenH);
    //分页
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:self.pageC];
    [self.pageC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(50);
        make.bottom.equalTo(self.view).offset(-23);
        make.height.mas_equalTo(12);
    }];
    
    for (int i = 0; i < 3; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW * i, 0, kScreenW, kScreenH)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        NSString *imageName = [NSString stringWithFormat:@"%d.png",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        [_scrollView addSubview:imageView];

        if (i == 2) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"开启威风2.0新时代" forState:UIControlStateNormal];
            button.layer.borderWidth = 2.0f;
            button.layer.borderColor = kWhiteColor.CGColor;
            button.titleLabel.font = [UIFont systemFontOfSize:(SpaceH(30))];;
            [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(imageView).offset(-SpaceH(80));
                make.centerX.equalTo(imageView);
                make.width.mas_equalTo(@(SpaceW(340)));
                make.height.mas_equalTo(@(SpaceH(80)));
            }];
        }else{
            UILabel *alertlabel = [UILabel initWithTitle:@"威风出行2.0全新上线" withFont:kTextSize textColor:kWhiteColor];
            alertlabel.textAlignment = NSTextAlignmentCenter;
            [imageView addSubview:alertlabel];
            [alertlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(imageView).offset(-23);
                make.centerX.equalTo(imageView);
                make.width.mas_equalTo(238);
                make.height.mas_equalTo(12);
            }];
            
            UIImageView *rightImage = [[UIImageView alloc]init];
            rightImage.image = [UIImage imageNamed:@"icon_next"];
            rightImage.contentMode = UIViewContentModeScaleAspectFill;
            [imageView addSubview:rightImage];
            
            [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(imageView).offset(-15);
                make.right.equalTo(self.view).offset(-28);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
        }
    }
}

#pragma mark - clickAction

- (void)clickAction:(UIButton *)butt
{
    MainTabBarController *mainTabC = [MainTabBarController new];
    mainTabC.view.alpha = 0.0;

    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabC;
    [UIView animateWithDuration:.5 animations:^{
        mainTabC.view.alpha = 1.0;
    }];
}


#pragma mark - Getters/Setters

- (UIPageControl *)pageC
{
    if (!_pageC) {
        _pageC = [[UIPageControl alloc] init];
        _pageC.numberOfPages = 3;
        _pageC.currentPage = 0;
        [_pageC setValue:[UIImage imageNamed:@"icon_1"] forKeyPath:@"pageImage"];
        [_pageC setValue:[UIImage imageNamed:@"icon_2"] forKeyPath:@"currentPageImage"];
    }
    return _pageC;
}

@end
