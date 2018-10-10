//
//  VFFromTheDepositTableViewCell.h
//  VFly
//
//  Created by Hcar on 2018/5/16.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VFFromTheDepositTableViewCellDelegate <NSObject>
- (void)VFFromTheDepositTableViewCell:(CGFloat)height;
@end

@interface VFFromTheDepositTableViewCell : UITableViewCell
@property (nonatomic, assign) id<VFFromTheDepositTableViewCellDelegate> delegate;
@end
