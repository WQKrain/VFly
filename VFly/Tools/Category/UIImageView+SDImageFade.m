//
//  UIImageView+SDImageFade.m
//  LuxuryCar
//
//  Created by wang on 16/10/12.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "UIImageView+SDImageFade.h"

@implementation UIImageView (SDImageFade)

- (void)fadeImageWithURL:(NSString *)urlStr
{
    // 图片居中自适应
    // 设置ImageView显示的内容比例
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    // 设置填充模式
    self.contentMode = UIViewContentModeScaleAspectFit;
    // 设置自动布局样式（不随父视图变化而变化）
    self.autoresizingMask = UIViewAutoresizingNone;
    self.clipsToBounds = YES;
    
    [self sd_setImageWithURL:kUrlWithString(urlStr) placeholderImage:kImageOriginal(@"place_holer_750x500") options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        // 针对没缓存过的图片做动画
        if (image)
        {
            CATransition *fadeIn = [CATransition animation];
            fadeIn.duration = .25f;
            fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            fadeIn.subtype = kCATransitionFade;
            [self.layer addAnimation:fadeIn forKey:@"fade"];
        };
    }];
    
};

@end
