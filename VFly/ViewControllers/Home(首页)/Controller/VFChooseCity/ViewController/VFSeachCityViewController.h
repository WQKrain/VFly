//
//  VFSeachCityViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/21.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SelectedItem)(NSString *item);
@interface VFSeachCityViewController : BaseViewController
@property (strong, nonatomic) SelectedItem block;
- (void)didSelectedItem:(SelectedItem)block;
@end
