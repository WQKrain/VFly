//
//  AppDelegate+configRegisterThird.m
//  VFly
//
//  Created by 毕博洋 on 2018/8/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "AppDelegate+configRegisterThird.h"
#import "BeeCloud.h"

@implementation AppDelegate (configRegisterThird)

//设置BeeCloud
- (void)setUpBeeCloud
{
    //初始化BeeCloud
#ifdef DEBUG
    [BeeCloud initWithAppID:@"b5ba1e40-9a7b-4b1a-82a9-e643dd8b92f4" andAppSecret:@"3c911456-a0cc-4c5a-a6db-e1197d975eb6" sandbox:YES];
#else
    [BeeCloud initWithAppID:@"b5ba1e40-9a7b-4b1a-82a9-e643dd8b92f4" andAppSecret:@"e36dda6a-135d-4610-b319-58b7c5ad7cc9"];
#endif
    //    初始化微信支付
    [BeeCloud initWeChatPay:@"wxbdaf37871c897e9d"];
}





@end
