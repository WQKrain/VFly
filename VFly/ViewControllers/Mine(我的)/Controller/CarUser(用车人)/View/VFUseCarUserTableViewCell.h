//
//  VFUseCarUserTableViewCell.h
//  VFly
//
//  Created by Hcar on 2018/4/25.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFUseCarUseeListModel;
@protocol VFUseCarUserListCellDelegate <NSObject>

@optional
- (void)VFUseCarUserListCellClick:(NSInteger)tag model:(VFUseCarUseeListModel *)model;
@end

@interface VFUseCarUserTableViewCell : UITableViewCell
@property (nonatomic, weak) id<VFUseCarUserListCellDelegate> delegate;
@property (nonatomic , strong)VFUseCarUseeListModel *model;

@end
