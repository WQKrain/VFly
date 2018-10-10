//
//  AppDelegate+configAppVersionUpdate.m
//  VFly
//
//  Created by 毕博洋 on 2018/8/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "AppDelegate+configAppVersionUpdate.h"
#import "HCAlertViewController.h"

@implementation AppDelegate (configAppVersionUpdate)

- (void)checkAppVersion {
    
    [HttpManage getGlobalConfig:^(NSDictionary *dic) {
        
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:GlobalConfig];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        GlobalConfigModel *model = [[GlobalConfigModel alloc]initWithDic:dic];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSInteger value = [CustomTool compareVersion:app_Version to:model.lastVersion];
        
        //当版本号相等或者大于最高版本号
        if (value != -1) {
            
        }else {
            NSString *lowest = dic[@"lowest"];
            //判断当前版本号是否小于最低版本号，小于则强制升级
            NSInteger lowestValue = [CustomTool compareVersion:app_Version to:lowest];
            if (lowestValue != -1) {
                
                if ([dic[@"isUpdate"] isEqualToString:@"0"]) {
                    // 提示升级
                    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:model.des];
                    HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
                    [alertVC addAction:cancelAction];
                    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"立即更新" handler:^(HCAlertAction *action) {
                        // 跳转到商店更新
                        alertVC.needDismissAnimation = NO;
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppUrl]];
//                        [self updateVersion];
                    }];
                    [alertVC addAction:updateAction];
                    [self.window.rootViewController presentViewController:alertVC animated:NO completion:nil];
                }else if([dic[@"isUpdate"] isEqualToString:@"1"]){
                    // 强制升级
                    HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:model.des];
                    HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"立即更新" handler:^(HCAlertAction *action) {
                        // 跳转到商店更新
                        alertVC.needDismissAnimation = NO;
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppUrl]];
//                        [self updateVersion];
                    }];
                    
                    [alertVC addAction:updateAction];
                    [self.window.rootViewController presentViewController:alertVC animated:NO completion:nil];
                }else{
                }
            }else{
                // 强制升级
                HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:model.des];
                HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"立即更新" handler:^(HCAlertAction *action) {
                    // 跳转到商店更新
                    alertVC.needDismissAnimation = NO;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppUrl]];
//                    [self updateVersion];
                }];
                
                [alertVC addAction:updateAction];
                [self.window.rootViewController presentViewController:alertVC animated:NO completion:nil];
            }
        }
    } failedBlock:^{
        
    }];
    
}






@end
