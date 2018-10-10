//
//  VFChooseCountyViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"

@protocol VFChooseCityViewDelegate <NSObject>

- (void)ChooseCityDidClickedWithCityName:(NSString*)cityName countyName:(NSString *)county cityID:(NSString *)cityID;

@end


@interface VFChooseCountyViewController : BaseViewController
@property (nonatomic , strong)NSString *cityID;
@property (nonatomic , strong)NSString *cityName;
@property (nonatomic , strong)NSString *pid;
@property (strong, nonatomic) id<VFChooseCityViewDelegate> delegate;
@end
