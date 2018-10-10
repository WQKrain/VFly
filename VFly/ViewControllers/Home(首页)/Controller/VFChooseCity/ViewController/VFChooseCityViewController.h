//
//  VFChooseCityViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/29.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SelectedItem)(NSString *item);
@interface VFChooseCityViewController : BaseViewController
@property (strong, nonatomic) SelectedItem block;
@property (strong, nonatomic) NSString * cityID;
@property (strong, nonatomic) NSString * shortname;
@property (strong, nonatomic) NSString * pid;
- (void)didSelectedItem:(SelectedItem)block;
@end
