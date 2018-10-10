//
//  VFHttpRequest.h
//  VFly
//
//  Created by Hcar on 2018/4/4.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFHttpRequest : NSObject

//车辆托管申请
+ (void)trustShipParameter:(NSDictionary *)parameter
              successBlock:(void(^)(NSDictionary *data))successBlock
          withFailureBlock:(void(^)(NSError *error))failureBlock;

//车辆需求提交
+ (void)userNeedCarParameter:(NSDictionary *)parameter
                successBlock:(void(^)(NSDictionary *data))successBlock
            withFailureBlock:(void(^)(NSError *error))failureBlock;

//品牌列表
+ (void)getCarBrandSuccessBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock;

//车库页车辆列表
+ (void)getCarListParameter:(NSDictionary *)parameter
               successBlock:(void(^)(NSDictionary *data))successBlock
           withFailureBlock:(void(^)(NSError *error))failureBlock;


//获取未读消息数
+ (void)messageUnreadParameter:(NSDictionary *)parameter
                  successBlock:(void(^)(NSDictionary *data))successBlock
              withFailureBlock:(void(^)(NSError *error))failureBlock;

//消息列表
+ (void)userMessageParameter:(NSDictionary *)parameter
                successBlock:(void(^)(NSDictionary *data))successBlock
            withFailureBlock:(void(^)(NSError *error))failureBlock;

//用车人员信息修改
+ (void)addUsermanUsermanID:(NSString *)usermanID
                  Parameter:(NSDictionary *)parameter
               successBlock:(void(^)(NSDictionary *data))successBlock
           withFailureBlock:(void(^)(NSError *error))failureBlock;

//热门搜索词汇
+ (void)hotVocabularyParameter:(NSDictionary *)parameter
                  successBlock:(void(^)(NSDictionary *data))successBlock
              withFailureBlock:(void(^)(NSError *error))failureBlock;

//根据金额获取优惠券列表
+ (void)couponAvailableListParameter:(NSDictionary *)parameter
                        successBlock:(void(^)(NSDictionary *data))successBlock
                    withFailureBlock:(void(^)(NSError *error))failureBlock;

//优惠券列表
+ (void)couponListParameter:(NSDictionary *)parameter
               successBlock:(void(^)(NSDictionary *data))successBlock
           withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取验证码
+ (void)smsParameter:(NSDictionary *)parameter
        successBlock:(void(^)(NSDictionary *data))successBlock
    withFailureBlock:(void(^)(NSError *error))failureBlock;

//登录
+ (void)loginParameter:(NSDictionary *)parameter
          successBlock:(void(^)(NSDictionary *data))successBlock
      withFailureBlock:(void(^)(NSError *error))failureBlock;


//免押信用
+ (void)userCrediSuccessBlock:(void(^)(NSDictionary *data))successBlock
             withFailureBlock:(void(^)(NSError *error))failureBlock;

#pragma mark---------------------车辆信息------------------------
//车辆详情
+ (void)getCarDetailParameter:(NSString *)parameter
                          dic:(NSDictionary*)dic
                 successBlock:(void(^)(NSDictionary *data))successBlock
             withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取用车人员列表
+ (void)usePeopleParameter:(NSDictionary *)parameter
              successBlock:(void(^)(NSDictionary *data))successBlock
          withFailureBlock:(void(^)(NSError *error))failureBlock;

//用车人员信息完善
+ (void)addUsePeopleParameter:(NSString *)parameter
                          dic:(NSDictionary*)dic
                 successBlock:(void(^)(NSDictionary *data))successBlock
             withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取地址列表
+ (void)addressParameter:(NSDictionary *)parameter
            successBlock:(void(^)(NSDictionary *data))successBlock
        withFailureBlock:(void(^)(NSError *error))failureBlock;

//创建订单
+ (void)createOrderParameter:(NSDictionary *)parameter
                successBlock:(void(^)(NSDictionary *data))successBlock
            withFailureBlock:(void(^)(NSError *error))failureBlock;

//图片上传
+ (void)uploadfile:(NSData *)file
      successBlock:(void(^)(NSDictionary *data))successBlock
  withFailureBlock:(void(^)(NSError *error))failureBlock;

//订单列表
+ (void)orderListParameter:(NSDictionary *)parameter
              successBlock:(void(^)(NSDictionary *data))successBlock
          withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取个人信息
+ (void)getUserInfoSuccessBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock;

//修改个人信息
+ (void)postUserInfoParameter:(NSDictionary *)parameter
                 successBlock:(void(^)(NSDictionary *data))successBlock
             withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取需支付金额
+ (void)orderShouldPayParameter:(NSDictionary *)parameter
                   successBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取支付可抵扣优惠券数量
+ (void)getAvailableCouponParameter:(NSDictionary *)par
                       SuccessBlock:(void(^)(NSDictionary *data))successBlock
                   withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取订单详情
+ (void)getOrderDetailParameter:(NSString *)orderID
                   SuccessBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock;

//删除订单
+ (void)deleteOrderParameter:(NSString *)orderID
                SuccessBlock:(void(^)(NSDictionary *data))successBlock
            withFailureBlock:(void(^)(NSError *error))failureBlock;

//评价订单
+ (void)orderEvaluationParameter:(NSDictionary *)parameter
                    SuccessBlock:(void(^)(NSDictionary *data))successBlock
                withFailureBlock:(void(^)(NSError *error))failureBlock;

//续租
+ (void)renewApplyOrderID:(NSString *)orderID
                parameter:(NSDictionary *)parameter
             SuccessBlock:(void(^)(NSDictionary *data))successBlock
         withFailureBlock:(void(^)(NSError *error))failureBlock;

//还车
+ (void)carReturnOrderID:(NSString *)orderID
            successBlock:(void(^)(NSDictionary *data))successBlock
        withFailureBlock:(void(^)(NSError *error))failureBlock;

//续租申请
+ (void)orderRenewApplyParameter:(NSDictionary *)par
                         orderID:(NSString *)orderID
                    SuccessBlock:(void(^)(NSDictionary *data))successBlock
                withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取续租详情
+ (void)getorderRenewDetailOrderID:(NSString *)orderID
                      successBlock:(void(^)(NSDictionary *data))successBlock
                  withFailureBlock:(void(^)(NSError *error))failureBlock;

//待支付余款列表
+ (void)getOrderShouldPayParameter:(NSDictionary *)par
                      successBlock:(void(^)(NSDictionary *data))successBlock
                  withFailureBlock:(void(^)(NSError *error))failureBlock;

//获取订单服务二维码
+ (void)getOrderQrcodeParameter:(NSString *)orderID
                   successBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock;


//实名认证
+ (void)userCertificationParameter:(NSDictionary *)par
                      SuccessBlock:(void(^)(NSDictionary *data))successBlock
                  withFailureBlock:(void(^)(NSError *error))failureBlock;

//余额支付
+ (void)walletPayParameter:(NSDictionary *)par
              SuccessBlock:(void(^)(NSDictionary *data))successBlock
          withFailureBlock:(void(^)(NSError *error))failureBlock;

#pragma mark------------------钱包----------------------
//银行卡列表
+ (void)getBankCardListSuccessBlock:(void(^)(NSDictionary *data))successBlock
                   withFailureBlock:(void(^)(NSError *error))failureBlock;

//银行卡限额列表
+ (void)getBankLimitListSuccessBlock:(void(^)(NSDictionary *data))successBlock
                    withFailureBlock:(void(^)(NSError *error))failureBlock;

//钱包余额充值
+ (void)walletRechargePar:(NSDictionary *)par
             SuccessBlock:(void(^)(NSDictionary *data))successBlock
         withFailureBlock:(void(^)(NSError *error))failureBlock;

@end
