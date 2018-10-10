//
//  HttpManage.h
//  JSFLuxuryCar
//
//  Created by joyingnet on 16/7/30.
//  Copyright © 2016年 joyingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CarModel.h"

@interface HttpManage : NSObject

//用户授信情况
+ (void)getCustomerQualificationSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//旧资料重新提交审核资料
+ (void)resetQualifyParameter:(NSDictionary *)dic success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//剩余名额
+ (void)getFreedepositAvailableSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//排行榜
+ (void)getFreedepositTopsSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//车库列表
+ (void)getFreedepositCarsParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//免押金自驾下单
+ (void)appFreedepositRentalOrderParameter:(NSDictionary *)dic success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//获取门店列表
+ (void)getStoresSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取订单服务二维码
+ (void)getQrcodeUrlParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

// app下载自定义参数上传
+ (void)appDownloadParameter:(NSString *)content success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

// 需求车辆提交接口
+ (void)needCarSubmitParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//获取接送订单详情
+ (void)getShuttleDetailParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取订单续租折扣算法
+ (void)getOrderEvaluationParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取订单续租折扣算法
+ (void)renewMapParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//跳过认证
+ (void)jumpCreditSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//环信注册
+ (void)getHxUserSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取常见问题列表
+ (void)getQuestionJsonDataSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取通知消息列表
+ (void)getNoticeMessageParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取钱包及账单消息列表
+ (void)messageListWithParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取钱包及账单消息未读数
+ (void)unreadMessageSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//热门城市
+ (void)getHotCitySuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//热门标签
+ (void)getCarTagWithParameter:(NSDictionary *)dic withSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//热门车型
+ (void)getHotCarWithParameter:(NSDictionary *)dic withSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//删除订单
+ (void)orderDelParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//订单评价
+ (void)orderEvaluationParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//获取订单评价
+ (void)getOrderEvaluationParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//续租
+ (void)rentalRenewParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//根据订单号获取金额
+ (void)getMoneyByOrderIdParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//确认还车 v1.3
+ (void)confirmReturnCarParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//银行卡限额列表
+ (void)bankLimitListSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//获取vip信息
+ (void)getVipInfoSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//vip卡列表 1.1
+ (void)vipLevelListSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//充值vip下单
+ (void)vipOrderParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//预存款明细详情
+ (void)vipDetailParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//预存款明细
+ (void)vipLogParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//预存款充值下单
+ (void)viprechargeParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

#pragma mark-------------超值长租----------------

//超值套餐下的车辆列表
+ (void)packageCarListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//车辆信息获取
+ (void)packageCarInfoParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//超值套餐申请
+ (void)packageApplyParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//活动抽奖
+ (void)lotteryDrawSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

#pragma mark-------------地址----------------

//我的地址列表
+ (void)myAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//添加地址
+ (void)addAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//编辑地址
+ (void)editAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//删除地址
+ (void)delAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//设置为默认地址
+ (void)setAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//单条地址详情
+ (void)addressDetailParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//获取默认地址
+ (void)getDefaultAddressSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark-------------优惠券----------------
//优惠券列表
+ (void)couponParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//选择优惠券的列表
+ (void)chooseListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//过期优惠券列表
+ (void)expiredCouponListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//积分明细
+ (void)scoreLogParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//积分明细详情
+ (void)scoreDetailParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//获取AppStroe中版本（监测版本更新）
//+ (void)getASVersionTodetectionVersionUpdateWithUrl:(NSString *)urlStr withBlock:(void(^)(NSDictionary *dic))myBlock;

//获取未读消息数
+ (void)getmMessageCount:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//连连用户签约信息查询 API 接口
+ (void)queryLLBankCardBineListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//全局配置获取
+ (void)getGlobalConfig:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//获取合伙人状态
+ (void)checkIsSellerSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//个人资料列表
+ (void)creditListSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//设置个人资料
+ (void)setUserInfoParameter:(NSDictionary *)parameter success:(void (^)(NSString*))myBlock failedBlock:(void (^)())failedBlock;

//意见反馈
+ (void)feedbackParameter:(NSDictionary *)parameter success:(void (^)(NSString*))myBlock failedBlock:(void (^)())failedBlock;

//还车城市
+ (void)getCarBackCitySuccessBlock:(void(^)(NSArray *dataArr))successBlock withFailureBlock:(void(^)(NSString *error))failureBlock;

//上传图片
+ (void)uploadFileImage:(NSData *)image success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//自驾租车车辆列表 new
+ (void)getCarListForIndexParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//会员级别列表 new
+ (void)getVipLevelListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock;

//身份信息获取 new
+ (void)getCardInfoSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//我的收藏 new
+ (void)getStarListParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//我的足迹 new
+ (void)getVisitListParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//车辆托管提交
+ (void)carTrusteeshipParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock;

//设置头像
+ (void)setAvatarParameter:(NSDictionary *)parameter With:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//设置昵称
+ (void)setNicknameParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock;

//充值下单
+ (void)rechargeParameter:(NSDictionary *)parameter With:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//获取余额
+ (void)getMoneySuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//银行卡列表 new
+ (void)getBankCardListParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//新增银行卡 new
+ (void)addbankCardParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock;

//编辑银行卡
+ (void)editBankCardParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock;

//删除银行卡
+ (void)delBankCardParameter:(NSDictionary *)parameter Success:(void (^)(NSString *))statusBlock withFailedBlock:(void (^)())failedBlock;

//站内支付
+ (void)walletPayParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock;

//申请提现
+ (void)cashApplyParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock;

//余额明细
+ (void)getWalletLogParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))statusBlock withFailedBlock:(void (^)())failedBlock;

//余额明细详情
+ (void)getWalletDetailParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))statusBlock withFailedBlock:(void (^)())failedBlock;

//获取首页轮播图
+ (void)getBannerSuccess:(void (^)(NSArray *))myBlock failedBlock:(void (^)())failedBlock;

//获取短信验证码
+ (void)getPhoneCodeWith:(NSString *)account action:(NSString *)action withBlock:(void (^)(NSString *))statusBlock withFailedBlock:(void (^)())failedBlock;
//确认登录
+ (void)getTokenWithTel:(NSString *)tel WithCode:(NSString *)code WithSuccessBlock:(void(^)(NSString *token))myBlock;

// 提交订单信息
//+ (void)updateDateToSessionWith:(NSMutableArray *)array WithCarID:(NSString *)carID WithOrder:(NSString *)orderStr WithBlock:(void(^)(NSDictionary *dict))myBlock;

//豪车接送列表
+ (void)getShuttleListSuccessBlock:(void(^)(NSDictionary *dic))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

// 提交接送订单信息, 返回定金等数值
+ (void)submitPickUpOrderInfoWith:(NSDictionary *)parameterDic withSuccessfulBlock:(void(^)(NSDictionary *dic))successfulBlock withFailureBlock:(void(^)(NSString *failedData))failureBlock;

//自驾租车获取金额回调
+ (void)getRentalInfoParameterDic:(NSDictionary *)parameterDic withSuccessfulBlock:(void(^)(NSDictionary *dic))successfulBlock withFailureBlock:(void (^)(NSString *failedData))failureBlock;

//提交信用
+ (void)updataCreditName:(NSString *)name withCardID:(NSString *)cardID withSuccessfulBlock:(void(^)(NSString *str))successfulBlock withFailureBlock:(void(^)(NSString *failedData))failureBlock;

//获取订单列表
+ (void)getUserOrderMessageParameter:(NSDictionary *)parameter success:(void(^)(NSDictionary *data))myBlock failure:(void(^)(NSError *error))failureBlock;

//获取接送订单列表
+ (void)getUserShuttlesOrderParameter:(NSDictionary *)parameter success:(void(^)(NSDictionary *data))myBlock failure:(void(^)(NSError *error))failureBlock;

//获取已关闭订单列表
+ (void)getCloseOrderMessageParameter:(NSDictionary *)parameter success:(void(^)(NSDictionary *data))myBlock failure:(void(^)(NSError *error))failureBlock;

//获取车辆列表
+ (void)getTheCarImageByCarID:(NSString *)carID success:(void(^)(NSDictionary *data))myBlock failure:(void(^)(NSError *error))failureBlock;

//获取订单详情
+ (void)getOrderMessageWithOrderID:(NSString*)order_id With:(void(^)(NSDictionary *dic))myBlock;

//搜索
+ (void)getSearchCarDataWithPar:(NSDictionary *)dic With:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock;

//租车城市
+ (void)getCityCounts:(void(^)(NSMutableArray *array))Black;

//'接送'信息介绍
+ (void)getPickUpIntroduceInfo:(void(^)(NSArray *array))infoBlock;

//豪车接送 获取金额回调
+ (void)getShuttleInfoDict:(NSDictionary *)dict withSuccessBlock:(void(^)(NSDictionary *dic))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//豪车接送 提交订单
+ (void)hotCarSubmitOrderInfoWithDict:(NSDictionary *)dict withSuccessBlock:(void(^)(NSDictionary *dic))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

//==================================================================
//获取用户信息
+(void)getUserInfoWithToken:(NSString *)token withSuccessBlock:(void (^)(NSDictionary *))dicBlock withFailedBlock:(void (^)())failedBlcok;

//我要还车
+ (void)willGoBackTheCarWithOrderId:(NSString *)orderId withBlock:(void(^)(NSString *status))statusBlock;

//提交评论
+ (void)updateCommentContentWithOrderId:(NSString *)orderId withRating:(NSInteger)starNum withContent:(NSString *)content withBlock:(void(^)(NSString *status))statusBlock;

//浏览记录
+ (void)visitLogListWithUserId:(NSString *)uid withBlock:(void(^)(NSMutableArray *mArr))arrayBlock;

//收藏车辆/取消收藏
+ (void)favoriteCollectioCarWithCarId:(NSString *)carId withBlock:(void(^)(NSString *status))statusBlock;

//获取我的收藏
+ (void)getMyFavoriteCollectionCarWithUserId:(NSString *)uid withBlock:(void(^)(NSMutableArray *mArr))arrayBlock;

//判断用户是否上传身份信息
+ (void)isUpdateUserInfoWithUid:(NSString *)uid withBlock:(void(^)(NSDictionary *statusDic))statusBlock;

// 开启隐私相关的功能和升级类型
+ (void)checkOutPrivateFunctionWithBlock:(void(^)(NSDictionary *dict))dictBlock;

// 上传通讯录
+ (void)uploadContacts:(NSDictionary *)contactsDict WithBlock:(void(^)(NSDictionary *dict))dictBlock;

// 上传位置的经纬度
+ (void)uploadCoordinate:(NSDictionary *)coordinateDict WithBlock:(void(^)(NSDictionary *dict))dictBlock;

// 自定义分享app的文字提示
+ (void)shareAppWithUserID:(NSString *)userID Block:(void(^)(NSDictionary *dict))dictBlock;

//=======================================================================

// 新首页 限时优惠
+ (void)getHomeLimitedTimeOffersWithSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

//首页 资讯列表
+ (void)getHomeActivitiesParameter:(NSDictionary *)parameter SuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

//近期活动
+ (void)getActivityParameter:(NSDictionary *)parameter SuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

//消息列表
+ (void)messageListParameter:(NSDictionary *)parameter SuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

// 新首页 热门车型
+ (void)getHomeHotCarWithCity:(NSString *)city withSuccessBlock:(void(^)(NSArray *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

// 新首页 一键租车 选择车辆
+ (void)getShortcutRentCarInfoWithSuccessBlock:(void(^)(NSArray *brands, NSArray *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

// 新首页 一键租车 提交订单
+ (void)submitShortcutCarOrderInfoWithDict:(NSDictionary *)dict withSuccessBlock:(void(^)(NSString *info))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

//=======================================================================

// 车型(新 出行) logo
+ (void)getCarLogoWithSuccessBlock:(void(^)(NSArray *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

// 车型(新 出行) 依据logo获取车辆信息 车辆列表
+ (void)getCarDataForLogoWithLocalCity:(NSString *)city withCarLogo:(NSString *)logo withSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;
//热门标签
+ (void)getHotLabelSuccessBlock:(void(^)(NSArray *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;
//=======================================================================

// 订单信息 根据地区改变价格
+ (void)getPriceFromCityWithCarId:(NSString *)carId withCity:(NSString *)city withSuccessBlock:(void(^)(NSString *priceStr))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

//=======================================================================
//实名认证
+ (void)beeCloudAuthReqWithName:(NSString *)name withIdNo:(NSString *)idNo withCard_no:(NSString *)card_no withMobile:(NSString *)mobile withSuccessBlock:(void(^)())successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;

// 推荐车辆
+ (void)recommendCarsWithCarID:(NSString *)carID withBlock:(void(^)(NSMutableArray *mArr))arrayBlock;

#pragma mark--------------免押金功能实现接口（实名认证、电子签名）---------------------
//实名认证状态于信息
+ (void)realNameAuthenticationStateWithToken:(NSString *)token withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock;

//身份证认证
+ (void)idCardcertificationWirhParameter:(NSDictionary *)dic successBlock:(void(^)(NSString *info))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//驾照认证
+ (void)driveCardcertificationWirhParameter:(NSDictionary *)dic successBlock:(void(^)(NSString *info))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//新订单详情（免押金部分）
+ (void)depositBreaksOrderDetailWithParameter:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock;

//开通免押金功能
+ (void)openDepositBreaksWirhParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;

//免押金服务费查询
+ (void)queryDepositBreaksSeversPriceWithParameter:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock;

//银行四要素校验
+ (void)bankCardCheakWithParameter:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock;

// 历史签约4要素
+ (void)bankCardHistoryWithParameter:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock;
@end
