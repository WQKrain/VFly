//
//  VFCarUserListCell.h
//  VFly
//
//  Created by 毕博洋 on 2018/9/21.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VFUseCarUseeListModel;
@protocol VFCarUserListCellDelegate <NSObject>
@optional

- (void)VFCarUserListCellClick:(NSInteger)tag model:(VFUseCarUseeListModel *)model;

@end
@interface VFCarUserListCell : UITableViewCell

@property (nonatomic, weak) id<VFCarUserListCellDelegate> delegate;
@property (nonatomic , strong)VFUseCarUseeListModel *model;

@end


