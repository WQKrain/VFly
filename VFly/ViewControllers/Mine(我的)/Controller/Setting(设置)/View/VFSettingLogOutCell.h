//
//  VFSettingLogOutCell.h
//  VFly
//
//  Created by 毕博洋 on 2018/9/19.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface VFSettingLogOutCell : UITableViewCell

@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, copy) void(^logoutHander)(void);

@end


