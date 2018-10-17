//
//  VFRenewalChosseDaysViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/16.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
#import "VFOrderDetailModel.h"
@class VFRenewMapModel;
//1.首先 用@protocol 声明一个协议
@protocol VFRenewalChooseRentDaysDeleaget <NSObject>
@optional
- (void)chooseRentDays:(NSString *)days;
@end

@interface VFRenewalChosseDaysViewController : BaseViewController
@property (nonatomic , strong)VFRenewMapModel *dataModel;
@property (nonatomic , strong) VFOrderDetailModel *detailObj;
@property (nonatomic , strong)NSString *rentDays;
@property (nonatomic,retain) id <VFRenewalChooseRentDaysDeleaget> delegate;

@end
