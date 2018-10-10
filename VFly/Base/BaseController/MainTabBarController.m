//
//  MainTabBarController.m
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import "MainTabBarController.h"
#import "RentCarViewController.h"
#import "LoginViewController.h"
#import "MineViewController.h"
#import "HomeGroupedViewController.h"
//#import "VFServiceViewController.h"
#import "VFCustomerServiceController.h"
#import "BaseNavigationController.h"

#import "CustomCallAlertView.h"
#import "AppDelegate.h"
#import "WebViewVC.h"

@implementation VFBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //  设置状态栏颜色
        if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleDefault) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }
    [super pushViewController:viewController animated:animated];
}

@end


@interface MainTabBarController ()<alertActionDelegate,HChatDelegate>
{
    UIImageView *imageView;
    NSArray *_selectImages;
    NSMutableArray *_normalArr; //存放TabBar常态图标
    NSMutableArray *_selectedArr; //存放TabBar选中图标
    NSArray *_selectImageArr;
    NSArray * _imageArr;
    UIAlertController *_alertController;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[HChatClient sharedClient].chat addDelegate:self delegateQueue:nil];
    self.tabBar.backgroundColor = kHomeBgColor;
     _imageArr = @[[UIImage imageNamed:@"icon_home"],[UIImage imageNamed:@"icon_car"],[UIImage imageNamed:@"icon_KeFu"],[UIImage imageNamed:@"icon_me"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"loginIn" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpRent) name:@"jumpRent" object:nil];
    
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(jumpService) name:@"jumpService" object:nil];
    
    RentCarViewController *rentCarVC = [[RentCarViewController alloc] init];
    HomeGroupedViewController *memberVC = [[HomeGroupedViewController alloc] init];
    VFCustomerServiceController *customerVC = [[VFCustomerServiceController alloc]init];
    MineViewController *mineVC = [[MineViewController alloc] init];
//    VFServiceViewController *vc = [[VFServiceViewController alloc]init];
    
    NSArray *viewCs = @[memberVC,rentCarVC,customerVC,mineVC];
    
    NSMutableArray *navis = [NSMutableArray array];
    for (UIViewController *viewC in viewCs) {
        BaseNavigationController *navigationC = [[BaseNavigationController alloc] initWithRootViewController:viewC];
        [navis addObject:navigationC];
    }
    self.viewControllers = navis;
    
    [self createTabBar];
    
}


- (void)tapGRAction:(UITapGestureRecognizer *)tap{
    [_alertController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginIn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpRent" object:nil];
}

- (void)logout {
    anyButton *selectBtn = [self.tabBar viewWithTag:100];
    [self tabBtnAction:selectBtn];
    LoginViewController *loginVC = [LoginViewController new];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)login {
    anyButton *selectBtn = [self.tabBar viewWithTag:100];
    [self tabBtnAction:selectBtn];
}

- (void)jumpRent{
    anyButton *selectBtn = [self.tabBar viewWithTag:101];
    [self tabBtnAction:selectBtn];
}

#pragma mark - Private Methods

- (void)createTabBar
{
    NSInteger scale = 0;
    if (isIPhone6P) {
        scale = 3;
    }
    else{
        scale = 2;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:scale forKey:Device];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray *titleArr = @[@"首页",@"车库",@"客服",@"我的"];
    for (int i = 0; i < 4; i++)
    {
        anyButton *tabBtn = [anyButton buttonWithType:UIButtonTypeCustom];
        [tabBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9f]];
        tabBtn.tag = 100 + i;
        
        [tabBtn addTarget:self action:@selector(tabBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        tabBtn.frame = CGRectMake((kScreenW / 4) * i, 0, kScreenW / 4, kTabBarHeght);
        [tabBtn setImage:_imageArr[i] forState:UIControlStateNormal];
        tabBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [tabBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        if (i == 0) {
            [tabBtn setImage:[UIImage imageNamed:@"icon_home_selected"] forState:UIControlStateSelected];
        }else if(i ==1){
            [tabBtn setImage:[UIImage imageNamed:@"icon_car_selected"] forState:UIControlStateSelected];
        }else if (i== 2){
            [tabBtn setImage:[UIImage imageNamed:@"icon_KeFu_selected"] forState:UIControlStateSelected];
        }else{
            [tabBtn setImage:[UIImage imageNamed:@"icon_me_selected"] forState:UIControlStateSelected];
        }
        
        [tabBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [tabBtn changeImageFrame:CGRectMake((tabBtn.size.width - 25)/2, 5, 25, 25)];
        [tabBtn changeTitleFrame:CGRectMake(0, 35, tabBtn.size.width, 10)];
        tabBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [tabBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [tabBtn setTitleColor:ktabNormalColor forState:UIControlStateNormal];
        
        if (i == 0) {
            tabBtn.selected = YES;
            self.selectedBtn = tabBtn;
        }
        [self.btnArray addObject:tabBtn];
        [self.tabBar addSubview:tabBtn];
    }
}

- (void)tabBtnAction:(anyButton *)btn
{
    //获取token值
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:access_Token];
//    判断用户是否第一次登陆
//    if (accessToken == nil)
//    {
//        if (btn.tag == 103) {
//            LoginViewController *loginVC = [LoginViewController new];
//            [self presentViewController:loginVC animated:YES completion:nil];
//            return;
//        }
//    }
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    self.selectedIndex = btn.tag - 100;
}

#pragma mark - Getters

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}


- (void)messagesDidReceive:(NSArray *)aMessages{
    if ([self isNotificationMessage:aMessages.firstObject]) {
        return;
    }
#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self _showNotificationWithMessage:aMessages];
    }else {
    }
#endif
    
    UIViewController * viewControllerNow = [self currentViewController];
    if ([viewControllerNow  isKindOfClass:[HDMessageViewController class]]) {   //如果是页面XXX，则执行下面语句
    }else{
        kWeakSelf;
        if ([CustomTool runningInForeground]) {
            HCAlertViewController *alertVC = [HCAlertViewController alertControllerWithTitle:nil message:@"您有一条来自威风客服的消息,是否立即查看"];
            HCAlertAction *cancelAction = [HCAlertAction actionWithTitle:@"取消" handler:nil];
            [alertVC addAction:cancelAction];
            HCAlertAction *updateAction = [HCAlertAction actionWithTitle:@"确定" handler:^(HCAlertAction *action) {
                [weakSelf performSelector:@selector(jumpService) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
            }];
            [alertVC addAction:updateAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
        }
    }
}

- (void)jumpService{
    kWeakSelf;
    if([HChatClient sharedClient].isLoggedInBefore)
    {
        HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
        UINavigationController *chatNav=[[UINavigationController alloc]initWithRootViewController:chatVC];
        MainTabBarController *baseTabBar= (MainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [baseTabBar.viewControllers[baseTabBar.selectedIndex] presentViewController:chatNav animated:YES completion:nil];
    }
    else
    {
        //未登录
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kHXUsernameAndPsw];
        if (dic)
        {
            VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:dic];
            HChatClient *client = [HChatClient sharedClient];
            [client loginWithUsername:model.username password:model.password];
        }
        else
        {
            [HttpManage getHxUserSuccessBlock:^(NSDictionary *data) {
                VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:data];
                [[NSUserDefaults standardUserDefaults]setObject:@{@"activated":model.activated,
                                                                @"created":model.created,
                                                                  @"modified":model.modified,
                                                                  @"password":model.password,
                                                                  @"type":model.type,
                                                                  @"username":model.username,
                                                                  @"uuid":model.uuid} forKey:kHXUsernameAndPsw];
                HChatClient *client = [HChatClient sharedClient];
                HError *error = [client loginWithUsername:model.username password:model.password];
                if (!error)
                { //登录成功
                    HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
                    UINavigationController *chatNav=[[UINavigationController alloc]initWithRootViewController:chatVC];
                    [weakSelf presentViewController:chatNav animated:YES completion:nil];
                }
                else
                { //登录失败
                    return;
                }
            } withFailureBlock:^(NSError *error) {
                
            }];
        }
    }
}


-(UIViewController*) currentViewController {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
}

-(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}


- (void)_showNotificationWithMessage:(NSArray *)messages
{
    HPushOptions *options = [[HChatClient sharedClient] hPushOptions];
//    发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
    
        if (options.displayStyle == HPushDisplayStyleMessageSummary) {
            id<HDIMessageModel> messageModel  = messages.firstObject;
            NSString *messageStr = nil;
            switch (messageModel.body.type) {
                case EMMessageBodyTypeText:
                {
                    messageStr = ((EMTextMessageBody *)messageModel.body).text;
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    messageStr = NSLocalizedString(@"message.image", @"Image");
                }
                    break;
                case EMMessageBodyTypeLocation:
                {
                    messageStr = NSLocalizedString(@"message.location", @"Location");
                }
                    break;
                case EMMessageBodyTypeVoice:
                {
                    messageStr = NSLocalizedString(@"message.voice", @"Voice");
                }
                    break;
                case EMMessageBodyTypeVideo:{
                    messageStr = NSLocalizedString(@"message.vidio", @"Vidio");
                }
                    break;
                default:
                    break;
            }
    
            NSString *title = messageModel.from;
            notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        }
        else{
            notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
        }
    
    #warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //    notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
        [UIApplication sharedApplication].applicationIconBadgeNumber = ++badge;
    
    
}

- (BOOL)isNotificationMessage:(HMessage *)message {
    if (message.ext == nil) { //没有扩展
        return NO;
    }
    NSDictionary *weichat = [message.ext objectForKey:kMesssageExtWeChat];
    if (weichat == nil || weichat.count == 0 ) {
        return NO;
    }
    if ([weichat objectForKey:@"notification"] != nil && ![[weichat objectForKey:@"notification"] isKindOfClass:[NSNull class]]) {
        BOOL isNotification = [[weichat objectForKey:@"notification"] boolValue];
        if (isNotification) {
            return YES;
        }
    }
    return NO;
}




@end
