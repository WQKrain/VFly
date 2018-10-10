//
//  RentCarViewController.h
//  JSFLuxuryCar
//
//  Created by joyingnet on 16/7/29.
//  Copyright © 2016年 joyingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum : NSUInteger {
    RentCarNavRightPriceButton,
    RentCarNavRightShowTypeButton,
} RentCarNavRightButton;

@interface RentCarViewController : BaseViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL secondVC;

@end
