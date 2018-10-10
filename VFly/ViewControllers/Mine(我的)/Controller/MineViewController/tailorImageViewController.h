//
//  tailorImageViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/6/7.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tailorImageViewController : UIViewController
@property (nonatomic , strong)UIImage *pic;
@property (nonatomic , assign)id delegate;
@end

@protocol tailorImageDelegate <NSObject>

- (void)senderImage:(UIImage *)image;

@end
