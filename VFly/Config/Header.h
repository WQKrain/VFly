//
//  Header.h
//  VFly
//
//  Created by Hcar on 2018/1/24.
//  Copyright © 2018年 VFly. All rights reserved.
//

#ifndef Header_h
#define Header_h

#pragma mark - 系统相关

#ifdef DEBUG
#define kNewBaseApi         @"https://test.weifengchuxing.com/api/"
//#define kNewBaseApi         @"https://api2.weifengchuxing.com/api/"
#else
#define kNewBaseApi         @"https://api2.weifengchuxing.com/api/"
#endif


#define kPreviewingPopNotification      @"kPreviewingPopNotification"
#define kLocalCityID                    @"kLocalCityID"

// 沙盒常用路径
#define kFolderPath         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//网络状态
#define kNetworkConnectionState              @"NetworkConnectionState"
#define kReachableViaWiFi                    @"ReachableViaWiFi"
#define kReachableViaWWAN                    @"ReachableViaWWAN"
#define kNotReachable                        @"NotReachable"
#define kUnknown                             @"Unknown"

#define chooseCarClass                       1000

#define HexColor(hex)               [UIColor colorWithRed:((hex>>16)&0xFF)/255.0 green:((hex>>8)&0xFF)/255.0 blue:(hex&0xFF)/255.0 alpha:1.0]
#define RGB(r, g, b)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kScreenW            [UIScreen mainScreen].bounds.size.width
#define kScreenH            [UIScreen mainScreen].bounds.size.height

#define SpaceW(w)           w/2.0/375.0*kScreenW
#define SpaceH(h)           h/2.0/667.0*kScreenH

#define kSpaceW(w)           w/375.0*kScreenW
#define kSpaceH(h)           h/667.0*kScreenH

// 本地存储相关
// 本地存储相关
#define isFollow            @"isFollow"                 // 是否收藏
#define Device              @"DeviceModel"
#define access_Token        @"access_token_response"    // 用户登录唯一标识
#define GlobalConfig        @"GlobalConfig"             // 全局信息

#define RealNameState       @"RealNameState"            // 身份证认证
#define DriverLicenseState  @"DriverLicenseState"       // 驾驶证认证

#define kmobile             @"mobile"                   //用户手机号
#define kname               @"name"
#define kHeadImage          @"headImage"

#define creditStatus        @"creditStatus"             // 用户信用标识

#define kDeviceIDFA         @"kDeviceIDFA"              // 设备唯一标识的值
#define kDeviceToken        @"kDeviceToken"             // 发送消息推送的标识符, app卸载重装会改变
#define LoginId             @"LoginId"                  // 用户登录的手机号
#define UserId              @"userID"                   // 服务器记录的用户编号
#define kPrivateIsOpen      @"kPrivateIsOpen"           // 隐私相关功能的开关
#define kIsNeedLocation     @"kIsNeedLocation"          // 是否需要定位
#define kCacheDateKey       @"kCacheDateKey"            // 记录是否需要清理banner缓存的key
#define kIsCleanBannerM     @"kIsCleanBannerMemory"     // 是否清理banner缓存
#define kLocalCity          @"kLocalCity"               // 当前位置
#define kLocalCityID        @"kLocalCityID"
#define kHXUsernameAndPsw   @"kHXUsernameAndPsw"
#define kOrderAlertShow     @"orderAlertShow"

//字号
#define kNewMoneyTitle              47
#define kNewCouponsTitle            38
#define kNewBigTitle                30
#define kNewTitle                   24
#define kTitleSize                  18
#define kTitleBigSize               16
#define kTitle                      15
#define kTextBigSize                14
#define kTextSize                   12                  // label字号
#define kTextSmallSize              10
#define kPicZoom                    3.0/4.0
#define kactionPicZoom              9.0/16.0

// 常用颜色
#define kBlodFont                   @"Helvetica-Bold"
#define kClearColor                 [UIColor clearColor]
#define kWhiteColor                 [UIColor whiteColor]
#define kBlackColor                 [UIColor blackColor]
#define klineColor                  HexColor(0xD8D8D8)
#define kdetailColor                HexColor(0x494949)
#define kMainColor                  HexColor(0xE72528)
#define kTextBlueColor              HexColor(0x3779c6)
#define kHomeBgColor                HexColor(0x111111)
#define kNewBgColor                 HexColor(0xF6F6F6)
#define kNewDetailColor             HexColor(0xa8a8a8)
#define kHomeLineColor              HexColor(0xEBEBEB)
#define ktitleColor                 HexColor(0x333333)
#define kGrayColor                  HexColor(0x9B9B9B)  // 灰色
#define ktabNormalColor             HexColor(0x9b9b9b)
#define kTitleBoldColor             HexColor(0x222222)
#define kBackgroundColor            HexColor(0xF2F2F2)  // 淡灰背景色
#define kTextColor                  HexColor(0x4A4A4A)  // 淡黑字体颜色
#define kNewButtonColor             HexColor(0xEB3A3D)
#define kViewBgColor                HexColor(0xFAFAFA)
#define kNewboderColor              HexColor(0xEBEBEB)
#define kNewSelectColor             HexColor(0xE72528)
#define kNewPointSelectColor        HexColor(0xFF6467)
#define kNewLineColor               HexColor(0xececec)
#define ktextGrayClolr              HexColor(0x6b6b6b)
#define kChoosebtnColor             HexColor(0x547fe3)
#define kPinklineColor              HexColor(0xFF8989)
#define kNewTitleColor              HexColor(0x141414)
#define kButtonTextBlueColor        HexColor(0x90C3FF)
#define kBarBgColor                 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]

//app信息
#define kAppUrl             @"https://itunes.apple.com/cn/app/%E5%A8%81%E9%A3%8E%E5%87%BA%E8%A1%8C/id1261673349?mt=8"
#define kAppLocalVersion    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kSystemVersion      [UIDevice currentDevice].systemVersion
#define kIsVersion8         [kSystemVersion floatValue] >= 8.0
#define kIsVersion9         [kSystemVersion floatValue] >= 9.0
#define kIsVersion10        [kSystemVersion floatValue] >= 10.0

#define isIPhone4                   ([[UIScreen mainScreen] bounds].size.height == 480)
#define isIPhone5                   ([[UIScreen mainScreen] bounds].size.height == 568)
#define isIPhone6                   ([[UIScreen mainScreen] bounds].size.height == 667)
#define isIPhone6P                  ([[UIScreen mainScreen] bounds].size.height == 736)

#define X(view)                     (view).frame.origin.x
#define Y(view)                     (view).frame.origin.y
#define Width(view)                 (view).frame.size.width
#define Height(view)                (view).frame.size.height

//View 圆角+边框
#define ViewBorderRadius(view, radius, width, color)\
\
[view.layer setCornerRadius:(radius)];\
[view.layer setMasksToBounds:YES];\
[view.layer setBorderWidth:(width)];\
[view.layer setBorderColor:[color CGColor]]


// block
#define kWeakself                   typeof(self) __weak weakSelf = self
// 拼接字符串
#define kFormat(string, args...)    [NSString stringWithFormat:string, args]
// url
#define kUrlWithString(str)         [NSURL URLWithString:(str)]
// 图片
#define kImageNamed(str)            [UIImage imageNamed:(str)]
#define kImageOriginal(str)         [[UIImage imageNamed:(str)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

// 字体
#define kBoldFontOfSize(size)       [UIFont boldSystemFontOfSize:(size)]
// 调试打印
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"<%s : %d> %s  " fmt), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent]   UTF8String], __LINE__, __PRETTY_FUNCTION__,  ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#ifdef DEBUG
#define BLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else
#define BLog(FORMAT, ...) nil
#endif


//iphoneX适配相关

#define isIPhoneX  ([[UIScreen mainScreen] bounds].size.height == 812)
//状态栏高度
#define Status_Bar_Height  [[UIApplication sharedApplication] statusBarFrame].size.height
#define kTabBarHeght  (isIPhoneX ? 82 : 49)
#define kStatutesBarH (isIPhoneX?44:20)
#define kNavgationBarH  44
#define kTabBarH  49
#define kSafeBottomH  (isIPhoneX?34:0)
#define kNavBarH  (kStatutesBarH +44)
#define kHeaderH  (kNavBarH +kNavTitleH)

#define kNavTitleH  62
#define kOldNavBarH (kNavBarH +90)


//AdjustsScrollViewInsetNever(self,self.tableview) 这个宏 包含两个参数 第一个参数就表示 当前控制器  第二个控制器表示需要特殊设置的scrollview及子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}
#endif /* Header_h */
