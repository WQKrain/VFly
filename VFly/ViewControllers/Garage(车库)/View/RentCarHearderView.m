//
//  RentCarHearderView.m
//  LuxuryCar
//
//  Created by Wang_zY on 2017/3/24.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "RentCarHearderView.h"
#import "VFCarLogoModel.h"



@interface RentCarHearderView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView * contentScrollView;
@property (nonatomic,strong) UIPageControl * pageControl;
@end

@implementation RentCarHearderView 

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 属性初始值
        self.viewSize = CGSizeMake((SCREEN_WIDTH - 14*WIDTH_RATE * 6)/ 5.f, (SCREEN_WIDTH - 14*WIDTH_RATE * 6)/ 5.f);
        self.numberOfSinglePage = NumberOfSinglePage;
        self.viewGap = leftRightGap;
        self.viewMargin = ViewMargin;
        
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    
    // 初始化
    [self initDataAndSubviews];
}

-(void)initDataAndSubviews{
    
    NSInteger pageCount = self.dataArr.count / self.numberOfSinglePage;
    if (self.dataArr.count % self.numberOfSinglePage > 0) {
        pageCount += 1;
    }
    
    UIScrollView * contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _contentScrollView = contentScrollView;
    _contentScrollView.delegate = self;
    contentScrollView.backgroundColor = kWhiteColor;
    contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * pageCount, self.frame.size.height);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < pageCount; i++) {
        [self addBtnsWithPageNum:i];
    }
    [self addSubview:contentScrollView];
    
    // 添加pageControl
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(SCREEN_WIDTH/2, self.height-20.f, 0, 15.f);
    pageControl.pageIndicatorTintColor = kBackgroundColor;
    pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = pageCount;
    _pageControl = pageControl;
    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];
    
}

// 循环添加按钮
-(void)addBtnsWithPageNum:(NSInteger)number{
    
    // 添加按钮
    NSInteger maxCol = 5;
    NSInteger maxRow = 2;
    
    CGFloat btnW = self.viewSize.width;
    CGFloat btnH = self.viewSize.height;
    
    CGFloat leftRightMargin = (SCREEN_WIDTH - (maxCol * btnW + (maxCol-1) * leftRightGap))/2; // 左右内边距;
    CGFloat topBottomMargin = (self.height - 15.f - (maxRow * (btnH +topBottomGap)))/2 ;
    
    
    NSInteger count = self.dataArr.count - (number * self.numberOfSinglePage);
    NSInteger indexCount;
    if (count > 0 && count <= self.numberOfSinglePage) {
        
        indexCount = count;
    }else if(count > self.numberOfSinglePage){
        
        indexCount = self.numberOfSinglePage;
    }else{
        
        return;
    }
    
    for (int i = 0; i<indexCount; i++) {
        
        UIView *bgView = [[UIView alloc]init];

        int col = i % maxCol;
        int row = i / maxCol;
        NSInteger index = i + number * self.numberOfSinglePage;
        VFCarLogoListModel *model = [[VFCarLogoListModel alloc]initWithDic:self.dataArr[index]];
        
        CGFloat x = col * (btnW + leftRightGap) + leftRightMargin + number * self.width;
        CGFloat y = row * (btnH + topBottomGap) + topBottomMargin + topBottomGap;
        bgView.origin = CGPointMake(x, y);
        
        bgView.width = btnW;
        bgView.height = btnH;
        
        UIButton  * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, btnW, btnW-20);
        //设置图片内容（使图片和文字水平居中显示）
        btn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        [btn sd_setImageWithURL:kUrlWithString(model.x3) forState:UIControlStateNormal placeholderImage:kImageNamed(@"加载")];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setTitleColor:kTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:8];
        btn.tag = index;
        [bgView addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, btnW-20, btnW, 20)];
        label.text = model.brand;
        label.userInteractionEnabled = NO;
        label.font = [UIFont systemFontOfSize:kTextSize];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
         bgView.tag = index;
        
        [_contentScrollView addSubview:bgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        
        [bgView addGestureRecognizer:tap];
    }
    
}

// 按钮点击事件
- (void)btnClick:(UIButton *)sender{
    if (self.selectedBlock) {
        self.selectedBlock(sender.tag);
    }
}

-(void)tapView:(UITapGestureRecognizer *)tap{
    if (self.selectedBlock) {
        self.selectedBlock(tap.view.tag);
    }
}

#pragma mark - scroll delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger correntCount = (scrollView.contentOffset.x + self.width/2)/self.width;
    self.pageControl.currentPage = correntCount;
}

@end
