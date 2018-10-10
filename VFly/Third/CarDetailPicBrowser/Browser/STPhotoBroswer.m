//
//  ；
//  STPhotoBroeser
//
//  Created by StriEver on 16/3/16.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "STPhotoBroswer.h"
#import "STImageVIew.h"
#define MAIN_BOUNDS   [UIScreen mainScreen].bounds
#define Screen_Width  [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
//图片距离左右 间距
#define SpaceWidth    10
@interface STPhotoBroswer ()<STImageViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * numberLabel;
@end
@implementation STPhotoBroswer
- (instancetype)initWithImageArray:(NSArray *)imageArray currentIndex:(NSInteger)index{
    if (self == [super init]) {
        self.imageArray = imageArray;
        self.index = index;
        [self setUpView];
    }
    return self;
}
//--getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        //这里
        _scrollView.contentSize = CGSizeMake((Screen_Width + 2*SpaceWidth) * self.imageArray.count, Screen_Height);
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        [self numberLabel];
    }
    return _scrollView;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Screen_Width, 40)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor greenColor];
        _numberLabel.text = [NSString stringWithFormat:@"%zi/%zi",self.index +1,self.imageArray.count];
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}
- (void)setUpView{
//    int index = 0;
//    for (NSString * image in self.imageArray) {
//        STImageVIew * imageView = [[STImageVIew alloc]init];
//        imageView.delegate = self;
////        imageView.image = image;
//        [imageView sd_setImageWithURL:[NSURL URLWithString:image]];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.tag = index;
//        [self.scrollView addSubview:imageView];
//        index ++;
//    }
    for (int i = 0; i<self.imageArray.count; i++) {
//        NSString * image1 = self.imageArray[i];
//        NSLog(@"=====================================%@",image1);
        NSRange startRange = [self.imageArray[i] rangeOfString:@"thumbnail/"];
        NSRange endRange = [self.imageArray[i] rangeOfString:@"%3E"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [self.imageArray[i] substringWithRange:range];
        
        NSString *image = [self.imageArray[i] stringByReplacingOccurrencesOfString:result withString:@"1440x1080"];
        
        STImageVIew * imageView = [[STImageVIew alloc]initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, kScreenH)];
        imageView.delegate = self;
        //        imageView.image = image;
//        [imageView sd_setImageWithURL:[NSURL URLWithString:image]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:image]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.tag = _index;
        imageView.tag = i+100;
        [self.scrollView addSubview:imageView];
        
        UILongPressGestureRecognizer *longPressGR =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleLongPress:)];
        [longPressGR setMinimumPressDuration:0.4];
        [imageView addGestureRecognizer:longPressGR];
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"保存到相册"
                                                   otherButtonTitles:nil];
        action.actionSheetStyle = UIActionSheetStyleDefault;
        action.tag = 123456;
        
        [action showInView:self];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 123456 && buttonIndex == 0)
    {
        UIImageView *imageView = [self.scrollView viewWithTag:self.index+100];
        if (imageView.image)
        {
            UIImageWriteToSavedPhotosAlbum(imageView.image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
        }
        else
        {
            [ProgressHUD showError:@"保存失败"];
        }
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        [ProgressHUD showError:@"保存失败"];
    }
    else
    {
        [ProgressHUD showSuccess:@"保存成功"];
    }
}


#pragma mark ---UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/Screen_Width;
    self.index = index;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:@"STImageVIew"]) {
            STImageVIew * imageView = (STImageVIew *) obj;
            [imageView resetView];
        }
                }];
    self.numberLabel.text = [NSString stringWithFormat:@"%zi/%zi",self.index+1,self.imageArray.count];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //主要为了设置每个图片的间距，并且使 图片铺满整个屏幕，实际上就是scrollview每一页的宽度是 屏幕宽度+2*Space  居中。图片左边从每一页的 Space开始，达到间距且居中效果。
    _scrollView.bounds = CGRectMake(0, 0, Screen_Width + 2 * SpaceWidth,Screen_Height);
    _scrollView.center = self.center;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(SpaceWidth + (Screen_Width+20) * idx, 0,Screen_Width,Screen_Height);
    }];
    _scrollView.contentOffset = CGPointMake((Screen_Width + 2*SpaceWidth) *_index, 0);
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
//    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Width *kPicZoom);
    [window addSubview:self];
//    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformIdentity;
//        self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    }];
}
- (void)dismiss{
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.5 animations:^{
//        self.transform = CGAffineTransformMakeScale(0.0000000001, 0.00000001);
//        self.center = CGPointMake(self.centerX, kScreenW*kPicZoom/2);
    }completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}
#pragma mark ---STImageViewDelegate
- (void)stImageVIewSingleClick:(STImageVIew *)imageView{
    [self dismiss];
}
@end
