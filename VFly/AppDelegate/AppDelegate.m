//
//  AppDelegate.m
//  LuxuryCar
//
//  Created by wang on 16/8/1.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "AppDelegate+configAppVersionUpdate.h"
#import "AppDelegate+configRegisterThird.h"
#import "GuideViewController.h"
#import "BaseNavigationController.h"

#import "MessageNoticeViewController.h"
#import "VFCarDetailViewController.h"

#import "OpenInstallSDK.h"
#import "WebViewVC.h"
#import "VFRegistHXModel.h"
#import "IQKeyboardManager.h"
#import "GlobalConfigModel.h"
#import "BeeCloud.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong) NSDictionary *launchOptions;
@property (nonatomic, strong) NSString *deviceTokenStr;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
    //app下载渠道来源统计
    [OpenInstallSDK setAppKey:@"nt9nek" withDelegate:self];
    //用户注册成功后调用
    [OpenInstallSDK reportRegister];
    
    //注册APNs推送
    [application registerForRemoteNotifications];
    UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound |   UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    
    [self.window makeKeyAndVisible];
    self.launchOptions = launchOptions;
    
    //初始化环信
    [self initHXServer];
    //初始化友盟
    [self setUpUMengWithOptions:launchOptions];
    //初始化BeeCloud
    [self setUpBeeCloud];
#ifdef DEBUG
    
#else
    
#endif
    if (@available(iOS 9.0, *)) {
        [self chooseToLaunchWithShortcutItem:nil];
    } else {
        // Fallback on earlier versions
    }
    
    return YES;
}


//初始化环信客服
- (void)initHXServer{
    HOptions *option = [[HOptions alloc] init];
    option.appkey = @"1447170908061557#kefuchannelapp47219"; // 必填项，appkey获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
    option.tenantId = @"47219";// 必填项，tenantId获取地址：kefu.easemob.com，“管理员模式 > 设置 > 企业信息”页面的“租户ID”
    //推送证书名字
#ifdef DEBUG
    option.apnsCertName = @"devPush";//(集成离线推送必填)
#else
    option.apnsCertName = @"disPush";
#endif
    //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
    HError *initError = [[HChatClient sharedClient] initializeSDKWithOptions:option];
    if (initError) { // 初始化错误
    }else{
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kHXUsernameAndPsw];
        if (dic) {
            VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:dic];
            HChatClient *client = [HChatClient sharedClient];
            HError *error = [client loginWithUsername:model.username password:model.password];
            if (error) { //登录成功
                [client loginWithUsername:model.username password:model.password];
            }
        }else{
            [HttpManage getHxUserSuccessBlock:^(NSDictionary *data) {
                VFRegistHXModel *model = [[VFRegistHXModel alloc]initWithDic:data];
                [[NSUserDefaults standardUserDefaults]setObject:@{@"activated":model.activated,@"created":model.created,@"modified":model.modified,@"password":model.password,@"type":model.type,@"username":model.username,@"uuid":model.uuid} forKey:kHXUsernameAndPsw];
                HChatClient *client = [HChatClient sharedClient];
                HError *error = [client loginWithUsername:model.username password:model.password];
                if (error) { //登录成功
                    [client loginWithUsername:model.username password:model.password];
                }
            } withFailureBlock:^(NSError *error) {
                
            }];
        }

        //环信表情
        [[HDEmotionEscape sharedInstance] setEaseEmotionEscapePattern:@"\\[[^\\[\\]]{1,3}\\]"];
        [[HDEmotionEscape sharedInstance] setEaseEmotionEscapeDictionary:[HDConvertToCommonEmoticonsHelper emotionsDictionary]];
        [self setupNotifiers];
    }
}


// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}


- (void)jumpRootViewController{
    //判断是否第一次登陆
    if (@available(iOS 9.0, *)) {
        [self chooseToLaunchWithShortcutItem:nil];
    } else {
        // Fallback on earlier versions
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            
        }
    }else {
        if (buttonIndex == 0) {
            
        }
    }
}

#pragma mark - 支付相关

//即将进入前台调用
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

//配置系统回调. 注意如果同时使用微信支付、支付宝等其他需要改写回调代理的SDK，请在if分支下做区分，否则会影响 分享、登录的回调
//iOS 9.0之前版本调用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //BeeCloud
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    if (![[UMSocialManager defaultManager] handleOpenURL:url])
    {
        //调用其他SDK，例如支付宝SDK等
            //Safari打开应用
            if (url)
            {
                NSString *urlStr = [url description];
                NSArray *array = [NSArray array];
                if ([urlStr containsString:@"hcarapp://"]){
                    NSArray *arr = [urlStr componentsSeparatedByString:@"carid="];
                    if (arr.count > 1) {
                        array = [arr copy];
                    }
                }
                
                VFCarDetailViewController *apnsVC = [[VFCarDetailViewController alloc] init];
                apnsVC.carId = [array lastObject];
                MainTabBarController *mainVC = (MainTabBarController *)self.window.rootViewController;
                BaseNavigationController *baseNav = (BaseNavigationController *)mainVC.viewControllers[0];
                [baseNav pushViewController:apnsVC animated:YES];
            }
        }
    }
    
    return YES;
}

//iOS 9.0之后版本调用
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //BeeCloud
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    if (![[UMSocialManager defaultManager] handleOpenURL:url])
    {
        //调用其他SDK，例如支付宝SDK等
            //Safari打开应用
            if (url)
            {
                NSString *urlStr = [url description];
                NSArray *array = [NSArray array];
                if ([urlStr containsString:@"hcarapp://"]){
                    NSArray *arr = [urlStr componentsSeparatedByString:@"carid="];
                    if (arr.count > 1) {
                        array = [arr copy];
                    }
                }else{
                    return YES;
                }
                
                VFCarDetailViewController *apnsVC = [[VFCarDetailViewController alloc] init];
                apnsVC.carId = [array lastObject];
                MainTabBarController *mainVC = (MainTabBarController *)self.window.rootViewController;
                BaseNavigationController *baseNav = (BaseNavigationController *)mainVC.viewControllers[0];
                [baseNav pushViewController:apnsVC animated:YES];
            }
        }
    }
    
    return YES;
}


#pragma mark - 推送相关

//推送注册失败时调用
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // 只能真机, 模拟器运行都会报错
//    NSString *error_str = [NSString stringWithFormat: @"%@", error];
//    NSLog(@"Failed to register for remote notification, error:%@", error_str);
}

//推送注册成功并获取设备Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[HChatClient sharedClient] bindDeviceToken:deviceToken];
    
//    向友盟注册该设备的deviceToken，便于发送Push消息
//    1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token)
    {
        [VFHttpRequest postUserInfoParameter:@{@"pushid":deviceTokenStr} successBlock:^(NSDictionary *data) {
            
        } withFailureBlock:^(NSError *error) {
            
        }];
    }
}

//收到推送时调用
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    HConversation *conversation = [[HChatClient sharedClient].chatManager getConversation:@"kefuchannelimid_889549"];
    int unreadCount = conversation.unreadMessagesCount;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
    [self clickRemoteNotification:userInfo];
}

//.iOS10以下的处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler{
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:userInfo forKey:@"userInfo"];

    }
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        //应用处于后台时的远程推送接受
        [self clickRemoteNotification:userInfo];
    }else{
        [self clickRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
     NSDictionary * userInfo = notification.request.content.userInfo;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:userInfo forKey:@"userInfo"];
//        NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        //应用程序在前台
    }
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        //应用处于后台时的远程推送接受
        [self clickRemoteNotification:userInfo];
    }else{
        
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}


//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self clickRemoteNotification:userInfo];
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString * _Nullable)identifier forRemoteNotification:(NSDictionary * _Nonnull)userInfo completionHandler:(void (^ _Nonnull)(void))completionHandler {
    // 通过identifier对各个交互式的按钮进行业务处理
    [UMessage sendClickReportForRemoteNotification:userInfo];
}

//点击推送内容
- (void)clickRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:YES];
    
    //必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];
    MainTabBarController *baseTabBar = [[MainTabBarController alloc]init];
    _window.rootViewController = baseTabBar;
    

    NSDictionary *aps = userInfo[@"aps"];
    if ([aps objectForKey:@"url"])
    {
        WebViewVC *vc = [[WebViewVC alloc]init];
        vc.urlStr = aps[@"url"];
        if ([aps objectForKey:@"category"])
        {
            vc.needToken = YES;
        }
        [baseTabBar.viewControllers[baseTabBar.selectedIndex] pushViewController:vc animated:NO];
    }
    else if ([userInfo objectForKey:@"from"])
    {
        MessageNoticeViewController *vc = [[MessageNoticeViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [baseTabBar.viewControllers[baseTabBar.selectedIndex] pushViewController:vc animated:NO];
    }
    else
    {
        HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_889549"];
        UINavigationController *chatNav=[[UINavigationController alloc]initWithRootViewController:chatVC];
        [baseTabBar.viewControllers[baseTabBar.selectedIndex] presentViewController:chatNav animated:YES completion:nil];
    }
}

#pragma mark - app从后台点击压力感应进入时调用
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
API_AVAILABLE(ios(9.0)){
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    //设置成主窗口，并显示出来
    [self.window makeKeyAndVisible];
    
    [self chooseToLaunchWithShortcutItem:shortcutItem];
    if (completionHandler){
        completionHandler(YES);
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma mark - Private Methods
// 启动选择
- (void)chooseToLaunchWithShortcutItem:(UIApplicationShortcutItem *)launchItem
API_AVAILABLE(ios(9.0)){
    //判断是否是第一次运行程序
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"];
    //版本检测
    [self checkAppVersion];
    if (!isFirst)
    {
        //第一次运行，切换到向导视图
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        _window.rootViewController = guideVC;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        //不是第一次，切换到启动动画视图
        if (self.launchOptions)
        {
            NSDictionary *remoteCotificationDic = [self.launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if(remoteCotificationDic)
            {
                [self clickRemoteNotification:self.launchOptions];
            }else{
                MainTabBarController *launchVC = [[MainTabBarController alloc] init];
                _window.rootViewController = launchVC;
            }
            
        }else {
            MainTabBarController *launchVC = [[MainTabBarController alloc] init];
            _window.rootViewController = launchVC;
        }
    }
}



#pragma mark - 第三方相关
// 设置友盟
- (void)setUpUMengWithOptions:(NSDictionary *)launchOptions
{
    //推送
    [UMConfigure initWithAppkey:@"596877d3310c934c3900011e" channel:@"App Store"];
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    // 1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
//    [UMessage registerForRemoteNotifications];
    
    if (kIsVersion10) {
        //iOS10必须加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                
            } else {
                //点击不允许
            }
        }];
    }

    // 打开调试日志
//    [[UMSocialManager defaultManager] openLog:YES];
    // 设置微信AppId、appSecret，分享url
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxbdaf37871c897e9d" appSecret:@"02446c99e880395df5f078e492a8ae53" redirectURL:@"https://mobile.umeng.com/social"];
}


//通过OpenInstall获取自定义参数，数据为空时也会回调此方法。渠道统计返回参数名称为openinstallChannelCode
- (void)getInstallParamsFromOpenInstall:(NSDictionary *) params withError: (NSError *) error {
    if (!error) {
        if (params) {
            
            if([[params allKeys] containsObject:@"count_data"]){
                NSString *paramsStr = params[@"count_data"];
                [HttpManage appDownloadParameter:paramsStr success:^(NSDictionary *data) {
                    HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                    if ([model.info isEqualToString:@"ok"]) {
                        //获取到参数后可保存到本地，等到需要使用时再从本地获取。
                        NSUserDefaults *openinstallData = [NSUserDefaults standardUserDefaults];
                        [openinstallData setObject:paramsStr forKey:@"openinstallParams"];
                    }
                } failedBlock:^(NSError *error) {
                    
                }];
            }
        }
    }
    else
    {

    }
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    //判断是否通过OpenInstall Universal Link 唤起App
    if ([OpenInstallSDK continueUserActivity:userActivity])
    {//如果使用了Universal link ，此方法必写
        return YES;
    }
    else
    {

        return YES;
    }
}

//唤醒时获取参数（如果是通过渠道页面唤醒app时，会返回渠道编号）
- (void)getWakeUpParamsFromOpenInstall: (NSDictionary *) params withError: (NSError *) error{
    NSLog(@"OpenInstall 唤醒参数：%@",params );
    if(!error)
    {
        if (params)
        {
            if([[params allKeys] containsObject:@"count_data"])
            {
                NSString *paramsStr = params[@"count_data"];
                [HttpManage appDownloadParameter:paramsStr success:^(NSDictionary *data) {
                    HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
                    if ([model.info isEqualToString:@"ok"])
                    {
                        //获取到参数后可保存到本地，等到需要使用时再从本地获取。
                        NSUserDefaults *openinstallData = [NSUserDefaults standardUserDefaults];
                        [openinstallData setObject:paramsStr forKey:@"openinstallParams"];
                    }
                } failedBlock:^(NSError *error) {
                    
                }];
            }
        }
    }
}


- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[HChatClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[HChatClient sharedClient] applicationWillEnterForeground:notif.object];
}

@end
