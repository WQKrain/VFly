//
//  CustomScrollView.h
//  ManShopping
//
//  Created by student on 16/6/19.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomScrollViewButtonClickBlock)(NSInteger tag);

@interface CustomScrollView : UIView

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIPageControl * pageControl;
@property (nonatomic,strong)  UIView * bgview;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat offSetY;
@property (nonatomic, copy) CustomScrollViewButtonClickBlock buttonClickBlock;


- (UIView *)initWithArr:(NSMutableArray *)arr WithHeight:(CGFloat)height;

@end
