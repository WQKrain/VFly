//
//  CustomScrollView.m
//  ManShopping
//
//  Created by student on 16/6/19.
//  Copyright © 2016年 student. All rights reserved.
//

#import "CustomScrollView.h"
#import "UIButton+WebCache.h"

@interface CustomScrollView ()<UIScrollViewDelegate>{
    CGFloat scrollH;
    NSTimer * timer;
    NSInteger page;
    NSInteger a;
    NSMutableArray * dataArr;
}

@end

@implementation CustomScrollView

- (UIView *)initWithArr:(NSMutableArray *)arr WithHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        page=1121;
        dataArr = [NSMutableArray arrayWithArray:arr];
        scrollH = height;
        [self addSubview:self.bgview];
        [self setNeedsLayout];
        timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAnimation) userInfo:nil repeats:YES];
        [timer fire];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgview.frame = CGRectMake(0, 0, Width(self), Height(self));
    self.scrollView.frame = self.bgview.frame;
    self.pageControl.frame = CGRectMake(kScreenW/2-40, self.bgview.frame.size.height-20, 80, 20);
}

#pragma mark - UIScrolleViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.scrollView.contentOffset.x/kScreenW-1;
    a=self.pageControl.currentPage ;
    if (self.scrollView.contentOffset.x >= kScreenW*(dataArr.count+1)) {
        self.scrollView.contentOffset = CGPointMake(kScreenW, 0);
        self.pageControl.currentPage = 0;
    }

    if (self.scrollView.contentOffset.x <= 0) {
        self.scrollView.contentOffset = CGPointMake(kScreenW*dataArr.count, 0);
        self.pageControl.currentPage = dataArr.count;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = 1120 + self.scrollView.contentOffset.x/kScreenW;
    if (page!=currentPage) {
        self.imageView = [self.scrollView viewWithTag:page];
        self.imageView.frame = CGRectMake((page-1120)*kScreenW, 0, kScreenW, scrollH);
    }
    self.imageView = [self.scrollView viewWithTag:currentPage];
    self.imageView.frame = CGRectMake(self.scrollView.contentOffset.x, 0, kScreenW, scrollH);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    page=currentPage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [timer invalidate];
    timer = nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(6, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timerAnimation) userInfo:nil repeats:YES];
        [timer fire];
    });
}

- (void)timerAnimation
{
    if (a==dataArr.count)
    {
        [UIView animateWithDuration:1 animations:^{
            self.scrollView.contentOffset = CGPointMake(kScreenW*(a+1), 0);
        }];
        self.scrollView.contentOffset = CGPointMake(kScreenW, 0);
        a=0;
    }
    
    [UIView animateWithDuration:1 animations:^{
        self.scrollView.contentOffset = CGPointMake(kScreenW*(a+1), 0);
        if (dataArr.count != 0) {
            self.pageControl.currentPage = a%dataArr.count;
        }
    }];
    
    a++;
}

- (void)goToHomePage:(UIButton *)button
{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button.tag);
    }
}

#pragma mark - Getters


- (UIView *)bgview
{
    if (!_bgview) {
        _bgview = [[UIView alloc]init];
        [_bgview addSubview:self.scrollView];
        [_bgview addSubview:self.pageControl];
    }
    return _bgview;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kScreenW*(dataArr.count+2), self.bgview.frame.size.height);
        
        for (int i = 0; i<(dataArr.count+2); i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(kScreenW*i, 0, kScreenW, scrollH);
            imageView.tag = 1120+i;
            if (dataArr.count != 0) {
                if (i<1) {
                    [imageView fadeImageWithURL:dataArr[dataArr.count-1]];
                }else if(i>0&&i<dataArr.count+1){
                    [imageView fadeImageWithURL:dataArr[i-1]];
                    
                }else if(i==dataArr.count+1){
                    [imageView fadeImageWithURL:dataArr[0]];
                }
                [_scrollView addSubview:imageView];
            }
//             banner点击事件
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(kScreenW*i, 0, kScreenW, scrollH);
//            btn.tag = 1234+i;
            btn.tag = i;
            [btn addTarget:self action:@selector(goToHomePage:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
        }
        
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO; //关闭滚动到顶部的属性
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(kScreenW, 0);
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = dataArr.count;
    }
    return _pageControl;
}

@end
