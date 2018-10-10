//
//  VFChooseUseCarUserView.h
//  VFly
//
//  Created by Hcar on 2018/5/4.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFUseCarUseeListModel;
@protocol chooseUseCarUeserViewCellDelegate <NSObject>

- (void)chooseUseCarUeserClick:(VFUseCarUseeListModel *)model;
@end

@interface VFChooseUseCarUserView : UIView

@property (nonatomic, assign) id<chooseUseCarUeserViewCellDelegate> delegate;

- (void)show:(NSString *)title dataArr:(NSArray *)dataArr;
-(void)animateOut;

@end
