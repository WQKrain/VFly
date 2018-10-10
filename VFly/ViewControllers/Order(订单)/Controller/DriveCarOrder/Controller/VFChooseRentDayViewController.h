//
//  VFChooseRentDayViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/16.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class VFCarDetailModel;

//1.首先 用@protocol 声明一个协议
@protocol VFChooseRentDaysDeleaget <NSObject>
@optional
- (void)chooseRentDays:(NSString *)days;
@end

@interface VFChooseRentDayViewController : BaseViewController
@property (nonatomic , strong)VFCarDetailModel *dataModel;
@property (nonatomic , strong)NSString *days;
@property (nonatomic,retain) id <VFChooseRentDaysDeleaget> delegate;
@end
