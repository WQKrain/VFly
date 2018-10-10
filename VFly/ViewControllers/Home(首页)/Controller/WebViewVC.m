//
//  WebViewVC.m
//  LuxuryCar
//
//  Created by joyingnet on 16/8/20.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import "WebViewVC.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "RentCarViewController.h"
#import "MainTabBarController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface WebViewVC ()<UIWebViewDelegate,JSObjcWebViewDelegate,UIActionSheetDelegate,NJKWebViewProgressDelegate>{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDescr;
@property (nonatomic, copy) NSString *shareImgUrlStr;
@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, strong) JSContext *JSContext;
@property (nonatomic , strong)NSString *shareMes;
@property (nonatomic , strong)NSString *lastUrl;

@property (nonatomic , assign)BOOL back;

@end

@implementation WebViewVC

-(instancetype)init
{
    if (self = [super init]) {
    }
    self.hidesBottomBarWhenPushed = YES;
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.UMPageStatistical = @"webChain";
    
    NSLog(@"%@",self.urlStr);
    
    _back = NO;
    [self customView];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *string = [NSString stringWithFormat:@"%@%@",_urlStr,token];
    NSString *urlStr = self.needToken?string:self.urlStr;
    NSString *lastStr = self.isForB?[NSString stringWithFormat:@"%@%@&client=ios",urlStr,token]:urlStr;
    NSString *str1 = [lastStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController.navigationBar addSubview:_progressView];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:str1] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    [self.webV loadRequest:request];
    
    if (_longRentShow) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        button.frame = CGRectMake(5, kStatutesBarH, 44, 44);
        [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customNavigationView{

    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 22, 22);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)defaultLeftBtnClick {
    if (_webV.canGoBack==YES) {
        if (self.isForB) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_webV goBack];
            return;
        }
    }else{
        [self.webV stopLoading];
        
        if(self.isPresent)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)customView{
    if (_isPresent) {
        self.webV =[[UIWebView alloc] initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH)];
        if (_urlTitle) {
            self.titleStr = _urlTitle;
        }else{
            self.urlTitle = @"常见问题";
        }
    }else if (_longRentShow){
        if (@available(iOS 11.0, *)) {
            self.webV =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        } else {
            self.webV =[[UIWebView alloc] initWithFrame:CGRectMake(0, kStatutesBarH, kScreenW, kScreenH)];
        }
    }else if (_noNav){
        self.webV =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    }else {
        self.webV =[[UIWebView alloc] initWithFrame:CGRectMake(0, 44+kStatutesBarH, kScreenW, kScreenH-44-kStatutesBarH)];
    }
    
    self.webV.backgroundColor = [UIColor whiteColor];
    //关闭水平滑动条
    self.webV.scrollView.showsHorizontalScrollIndicator = NO;
    //关闭垂直滑动条
    self.webV.scrollView.showsVerticalScrollIndicator = NO;
    self.webV.delegate = self;
    self.webV.scalesPageToFit = YES;
    [self.view addSubview:self.webV];
    
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.shareBtn];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webV.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    if (_isForB) {
        
    }else{
        if (_urlTitle) {
            self.title = _urlTitle;
        }else{
            self.title = [_webV stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
    }
}

#pragma mark - JSObjcDelegate

//一元租车
- (void)login {
    kWeakself;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
        [HttpManage lotteryDrawSuccess:^(NSDictionary *data) {
//            PayViewController *vc= [[PayViewController alloc]init];
//            vc.orderId = data[@"orderId"];
//            vc.orderCost = @"1";
//            vc.patText = data[@"text"];
//            vc.singleType = @"7";
//            [weakSelf.navigationController pushViewController:vc animated:YES];
        } failedBlock:^{
            
        }];
    }else {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

//跳转到支付页
- (void)goToPay:(NSString *)str{
    NSData *data  = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    PayViewController *vc= [[PayViewController alloc]init];
//    vc.orderId = dic[@"orderId"];
//    vc.orderCost = dic[@"money"];
//    vc.singleType = dic[@"moneyType"];
//    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到我的界面
- (void)goToMine{
}

//跳转到钱包界面
- (void)goToWallet{
//    MyWalletViewController *vc = [[MyWalletViewController alloc]init];
//    //self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

//登录
- (void)goToLogin{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (token) {
    }else {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)getToken{
    NSString *postStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    JSValue *Callback = self.JSContext[@"setToken"];
    //传值给web端
    [Callback callWithArguments:@[postStr]];
}

- (void)getVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    JSValue *Callback = self.JSContext[@"setVersion"];
    [Callback callWithArguments:@[app_Version]];
}

- (void)getPushId{
    NSString *pushID = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
    JSValue *Callback = self.JSContext[@"setPushId"];
    if (pushID) {
        [Callback callWithArguments:@[pushID]];
    }else{
        [Callback callWithArguments:@[@"用户未开启推送"]];
    }
}

- (void)getDeviceToken{
    JSValue *Callback = self.JSContext[@"getDeviceToken"];
    [Callback callWithArguments:@[[[NSUserDefaults standardUserDefaults]objectForKey:@"uuid"]]];
}

- (void)getCity{
    JSValue *Callback = self.JSContext[@"setCity"];
    [Callback callWithArguments:@[[[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity]]];
}

- (void)goBack{
    kWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_back) {
            if(weakSelf.isPresent)
            {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
        _back = YES;
    });
}

- (void)gotoIndex{
    kWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        MainTabBarController *mainTabBarC = (MainTabBarController *)weakSelf.tabBarController;
        mainTabBarC.selectedIndex = 0;
        mainTabBarC.selectedBtn.selected = NO;
        anyButton *button = mainTabBarC.btnArray[0];
        button.selected = YES;
        mainTabBarC.selectedBtn = button;
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        _back = YES;
    });
}


- (void)goBack:(NSString *)str{
    kWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_back) {
            if(weakSelf.isPresent)
            {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
        _back = YES;
    });
}

- (void)goToCarList{
    RentCarViewController *vc =[[RentCarViewController alloc]init];
    vc.secondVC = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSURL * currentURL = webView.request.URL;
    if ([currentURL.host isEqualToString:@"mp.weixin.qq.com"]) {
        if ([url.host isEqualToString:@"mp.weixin.qq.com"]) {
            return NO;
        }
    }
    
    _lastUrl = [request.URL absoluteString];
    _JSContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打印异常
    _JSContext.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
    };
    _JSContext[@"vfly"] =self;
    self.JSContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        
    };
    return YES;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"appShare(title,desc,imgUrl)"];
}

//加载失败时调用
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [JSFProgressHUD hiddenHUD:self.view];
    [webView.scrollView.mj_header endRefreshing];
    if([error code] == NSURLErrorCancelled){
        return;
    }
}


// 分享按钮事件
- (void)baseWebviewShareBtnAction
{
    kWeakself;
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据platformType调用相关平台进行分享
//        DLog(@"mineVC.share: platformType=%ld userInfo=%@",platformType,userInfo);
//        [weakSelf shareTextToPlatformType:platformType];
//    }];
}

//// 分享内容及回调
//- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMShareWebpageObject *webPageObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:nil thumImage:kUrlWithString(self.shareImgUrlStr)];
//    //设置文本
//    webPageObject.webpageUrl = self.urlStr;
//
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:webPageObject];
//
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            DLog(@"************Share fail with error %@*********",error);
//        }else{
//            [ProgressHUD showSuccess:@"分享成功"];
//        }
//    }];
//}



#pragma mark - Getters/Setters

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:kImageNamed(@"BackCircle") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, 0, SpaceW(44), SpaceH(44));
        [_shareBtn setImage:kImageNamed(@"shareBtn") forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(baseWebviewShareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (void)wxShare:(NSString *)callString{
    _shareMes = callString;
    if ([WXApi isWXAppInstalled]) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信", @"朋友圈",nil];
        actionSheet.delegate=self;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
//    }else if (buttonIndex == 1){
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
//    }
}

//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
//    if (_shareMes == nil) {
//        //        创建网页内容对象
//        NSString* thumbURL =  @"https://newoa.joyingnet.com/banner/share@3x.png";
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"威风出行-专注豪车租赁" descr:@"来不及解释了，快和我一起上车! v-fly.club" thumImage:thumbURL];
//        //设置网页地址
//        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
//        //    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
//
//        //获取问号的位置，问号后是参数列表
//        NSRange range = [_lastUrl rangeOfString:@"?"];
//        //获取参数列表
//        NSString *propertys = [_lastUrl substringFromIndex:(int)(range.location+1)];
//        //进行字符串的拆分，通过&来拆分，把每个参数分开
//        NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
//        //把subArray转换为字典
//        //tempDic中存放一个URL中转换的键值对
//        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:4];
//
//        for (int i= 0; i<subArray.count; i++) {
//            //在通过=拆分键和值
//            NSArray *dicArray = [subArray[i] componentsSeparatedByString:@"="];
//            if (dicArray.count == 1) {
//
//            }else{
//                //给字典加入元素
//                [tempDic setObject:dicArray[1] forKey:dicArray[0]];
//            }
//        }
//        bool isContain = [[tempDic allKeys] containsObject:@"carId"];
//        if (isContain) {
//            NSString *str = tempDic[@"carId"];
//            NSString *url = [NSString stringWithFormat:@"http://app.joyingnet.com/v-fly/www/#/car_detail?carId=%@&token=%@",str,token];
//            shareObject.webpageUrl = url;
//        }else {
//            NSString *url = [NSString stringWithFormat:@"http://app.joyingnet.com/v-fly/www/#/car_detail?token=%@",token];
//            shareObject.webpageUrl = url;
//        }
//        //    分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//
//    }else{
//        NSData *data  = [_shareMes dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dic[@"title"] descr:dic[@"desc"] thumImage:dic[@"imgUrl"]];
//        NSString *url = dic[@"link"];
//        shareObject.webpageUrl = url;
//        messageObject.shareObject = shareObject;
//    }
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            [CustomTool alertViewShow:@"分享失败"];
//        }else{
//            [CustomTool alertViewShow:@"分享成功"];
//        }
//    }];
//}


@end
