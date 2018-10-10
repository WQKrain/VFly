//
//  VFOrderDetailQRCodeView.h
//  LuxuryCar
//
//  Created by Hcar on 2018/1/15.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VFOrderDetailQRCodeView : UIView

- (instancetype)initWithOrderID:(NSString *)orderID isNew:(BOOL)isNew;

- (void)showXLAlertView;

@end
