//
//  VFOrderDetailPayView.h
//  VFly
//
//  Created by Hcar on 2018/4/18.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFOrderDetailPayModel;
@interface VFOrderDetailPayView : UIView

-(void)show:(VFOrderDetailPayModel *)model;
-(void)animateOut;

@end
