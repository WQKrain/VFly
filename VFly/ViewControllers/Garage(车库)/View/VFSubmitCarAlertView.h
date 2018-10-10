//
//  VFSubmitCarAlertView.h
//  LuxuryCar
//
//  Created by Hcar on 2017/11/15.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VFSubmitCarDidSelectbuttonDelegate <NSObject>
- (void)didSelectbutton:(NSInteger)tag;
@end

@interface VFSubmitCarAlertView : UIView
@property (nonatomic, assign) id<VFSubmitCarDidSelectbuttonDelegate> delegate;
@property (nonatomic ,strong)UITextField *brandTextField;
@property (nonatomic ,strong)UITextField *modelTextField;
- (UIView *)showView;
-(void)animateOut;

@end


