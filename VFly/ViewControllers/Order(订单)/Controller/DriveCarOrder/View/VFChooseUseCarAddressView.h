//
//  VFChooseUseCarAddressView.h
//  VFly
//
//  Created by Hcar on 2018/5/6.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chooseUseCarAddressViewCellDelegate <NSObject>

- (void)chooseUseCarAddressClick:(NSString *)str;
@end

@interface VFChooseUseCarAddressView : UIView
@property (nonatomic, assign) id<chooseUseCarAddressViewCellDelegate> delegate;

- (void)show:(NSString *)title dataArr:(NSArray *)dataArr;
-(void)animateOut;

@end
