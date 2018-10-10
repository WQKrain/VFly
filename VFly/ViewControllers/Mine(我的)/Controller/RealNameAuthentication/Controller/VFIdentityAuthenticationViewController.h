//
//  VFIdentityAuthenticationViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/12/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"

@protocol VFIdentityAuthenticationViewDelegate <NSObject>

@optional
//加载更多
- (void)identityAuthenticationVCcomplete;
@end

@interface VFIdentityAuthenticationViewController : BaseViewController
@property (nonatomic, weak) id<VFIdentityAuthenticationViewDelegate> delegate;
@property (nonatomic , strong) NSString *userID;
@property (nonatomic , strong) NSString *card_status;
@end
