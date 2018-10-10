//
//  VFHttpRequest.m
//  VFly
//
//  Created by Hcar on 2018/4/4.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFHttpRequest.h"
#import "VFHttpManage.h"
#import "LoginModel.h"

@implementation VFHttpRequest

//车辆托管申请
+ (void)trustShipParameter:(NSDictionary *)parameter
              successBlock:(void(^)(NSDictionary *data))successBlock
          withFailureBlock:(void(^)(NSError *error))failureBlock{

    [VFHttpManage postWithUrlString:@"c/car/trustShip"
                         parameters:parameter
                            success:^(id data) {
                                successBlock(data);
                            } failure:^(NSError *error) {
                                failureBlock(error);
                            }];
    
}

//车辆需求提交
+ (void)userNeedCarParameter:(NSDictionary *)parameter
                successBlock:(void(^)(NSDictionary *data))successBlock
            withFailureBlock:(void(^)(NSError *error))failureBlock {

    [VFHttpManage postWithUrlString:@"c/car/need" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}


//品牌列表
+ (void)getCarBrandSuccessBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock{
    [VFHttpManage getWithUrlString:@"c/brand" parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        
    }];
}


//车库页车辆列表
+ (void)getCarListParameter:(NSDictionary *)parameter
               successBlock:(void(^)(NSDictionary *data))successBlock
           withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/car" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        
    }];
}


//获取未读消息数
+ (void)messageUnreadParameter:(NSDictionary *)parameter
                  successBlock:(void(^)(NSDictionary *data))successBlock
              withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/message/unread"
                        parameters:parameter
                           success:^(id data) {
        successBlock(data);
                           } failure:^(NSError *error) {
                               
                           }];
}

//消息列表
+ (void)userMessageParameter:(NSDictionary *)parameter
                successBlock:(void(^)(NSDictionary *data))successBlock
            withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/message" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        
    }];
}


//用车人员信息修改
+ (void)addUsermanUsermanID:(NSString *)usermanID
                  Parameter:(NSDictionary *)parameter
               successBlock:(void(^)(NSDictionary *data))successBlock
           withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage putWithUrlString:kFormat(@"c/userman/%@", usermanID)  parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//热门搜索词汇
+ (void)hotVocabularyParameter:(NSDictionary *)parameter
                  successBlock:(void(^)(NSDictionary *data))successBlock
              withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/hot/vocabulary" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//根据金额获取优惠券列表
+ (void)couponAvailableListParameter:(NSDictionary *)parameter
                        successBlock:(void(^)(NSDictionary *data))successBlock
                    withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/coupon/available" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//优惠券列表
+ (void)couponListParameter:(NSDictionary *)parameter
               successBlock:(void(^)(NSDictionary *data))successBlock
           withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/coupon" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//获取验证码
+ (void)smsParameter:(NSDictionary *)parameter
        successBlock:(void(^)(NSDictionary *data))successBlock
    withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage postWithUrlString:@"c/sms" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//登录
+ (void)loginParameter:(NSDictionary *)parameter
          successBlock:(void(^)(NSDictionary *data))successBlock
      withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage postWithUrlString:@"c/login" parameters:parameter success:^(id data) {
        VFBaseMode *model = [[VFBaseMode alloc]initWithDic:data];
        VFLoginModel *obj = [[VFLoginModel alloc]initWithDic:model.data];
        [[NSUserDefaults standardUserDefaults]setObject:obj.token forKey:access_Token];
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//免押信用
+ (void)userCrediSuccessBlock:(void(^)(NSDictionary *data))successBlock
             withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/user/credit" parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

#pragma mark---------------------车辆信息------------------------
//车辆详情
+ (void)getCarDetailParameter:(NSString *)parameter
                          dic:(NSDictionary*)dic
                 successBlock:(void(^)(NSDictionary *data))successBlock
             withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:kFormat(@"c/car/%@", parameter) parameters:dic success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//获取用车人员列表
+ (void)usePeopleParameter:(NSDictionary *)parameter
              successBlock:(void(^)(NSDictionary *data))successBlock
          withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/userman" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//用车人员信息完善
+ (void)addUsePeopleParameter:(NSString *)parameter
                          dic:(NSDictionary*)dic
                 successBlock:(void(^)(NSDictionary *data))successBlock
             withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage putWithUrlString:kFormat(@"c/userman/%@", parameter) parameters:dic success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//获取地址列表
+ (void)addressParameter:(NSDictionary *)parameter
            successBlock:(void(^)(NSDictionary *data))successBlock
        withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/address" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//创建订单
+ (void)createOrderParameter:(NSDictionary *)parameter
                successBlock:(void(^)(NSDictionary *data))successBlock
            withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage postWithUrlString:@"c/order" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//图片上传
+ (void)uploadfile:(NSData *)file
      successBlock:(void(^)(NSDictionary *data))successBlock
  withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage uploadFile:@"c/image/upload" image:file success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error){
    }];
}

//订单列表
+ (void)orderListParameter:(NSDictionary *)parameter
              successBlock:(void(^)(NSDictionary *data))successBlock
         withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/order" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//获取个人信息
+ (void)getUserInfoSuccessBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/user" parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//修改个人信息
+ (void)postUserInfoParameter:(NSDictionary *)parameter
                 successBlock:(void(^)(NSDictionary *data))successBlock
             withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage postWithUrlString:@"c/user" parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//获取需支付金额
+ (void)orderShouldPayParameter:(NSDictionary *)parameter
                   successBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage getWithUrlString:@"c/order/can/deduction"
                        parameters:parameter
                           success:^(id data) {
                               successBlock(data);
                           } failure:^(NSError *error) {
                           }];
}

//获取支付可抵扣优惠券数量
+ (void)getAvailableCouponParameter:(NSDictionary *)par
                       SuccessBlock:(void(^)(NSDictionary *data))successBlock
                   withFailureBlock:(void(^)(NSError *error))failureBlock {
    
    [VFHttpManage getWithUrlString:@"c/coupon/available" parameters:par success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//获取订单详情
+ (void)getOrderDetailParameter:(NSString *)orderID
                   SuccessBlock:(void(^)(NSDictionary *data))successBlock
               withFailureBlock:(void(^)(NSError *error))failureBlock {
    
    [VFHttpManage getWithUrlString:kFormat(@"c/order/%@", orderID) parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {

    }];
}

//删除订单
+ (void)deleteOrderParameter:(NSString *)orderID
                SuccessBlock:(void(^)(NSDictionary *data))successBlock
            withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage deleteWithUrlString:kFormat(@"c/order/%@", orderID) parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//评价订单
+ (void)orderEvaluationParameter:(NSDictionary *)parameter
                    SuccessBlock:(void(^)(NSDictionary *data))successBlock
                withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage postWithUrlString:@"c/order/evaluation"
                         parameters:parameter
                            success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//续租
+ (void)renewApplyOrderID:(NSString *)orderID
                parameter:(NSDictionary *)parameter
             SuccessBlock:(void(^)(NSDictionary *data))successBlock
         withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage postWithUrlString:kFormat(@"c/order/%@/renew/apply", orderID) parameters:parameter success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//还车
+ (void)carReturnOrderID:(NSString *)orderID
            successBlock:(void(^)(NSDictionary *data))successBlock
        withFailureBlock:(void(^)(NSError *error))failureBlock {
    [VFHttpManage putWithUrlString:kFormat(@"c/order/%@/return", orderID) parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//待支付余款列表
+ (void)getOrderShouldPayParameter:(NSDictionary *)par
                      successBlock:(void(^)(NSDictionary *data))successBlock
                  withFailureBlock:(void(^)(NSError *error))failureBlock {
    
    [VFHttpManage getWithUrlString:@"c/order/should/pay" parameters:par success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//获取订单服务二维码
+ (void)getOrderQrcodeParameter:(NSString *)orderID
                   successBlock:(void(^)(NSDictionary *data))successBlock
              withFailureBlock:(void(^)(NSError *error))failureBlock {
    
    [VFHttpManage getWithUrlString:kFormat(@"c/order/%@/qrcode", orderID) parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//续租申请
+ (void)orderRenewApplyParameter:(NSDictionary *)par
                         orderID:(NSString *)orderID
                    SuccessBlock:(void(^)(NSDictionary *data))successBlock
                withFailureBlock:(void(^)(NSError *error))failureBlock{
    
    [VFHttpManage postWithUrlString:kFormat(@"c/order/%@/renew/apply", orderID) parameters:par success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//获取续租详情
+ (void)getorderRenewDetailOrderID:(NSString *)orderID
                      successBlock:(void(^)(NSDictionary *data))successBlock
                  withFailureBlock:(void(^)(NSError *error))failureBlock{
    
    [VFHttpManage getWithUrlString:kFormat(@"c/order/%@/renew", orderID) parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}


//实名认证
+ (void)userCertificationParameter:(NSDictionary *)par
                      SuccessBlock:(void(^)(NSDictionary *data))successBlock
                  withFailureBlock:(void(^)(NSError *error))failureBlock{
    
    [VFHttpManage postWithUrlString:@"c/user/certification" parameters:par success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//余额支付
+ (void)walletPayParameter:(NSDictionary *)par
              SuccessBlock:(void(^)(NSDictionary *data))successBlock
         withFailureBlock:(void(^)(NSError *error))failureBlock{
    
    [VFHttpManage postWithUrlString:@"c/walletPay" parameters:par success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

#pragma mark------------------钱包----------------------
//银行卡列表
+ (void)getBankCardListSuccessBlock:(void(^)(NSDictionary *data))successBlock
                   withFailureBlock:(void(^)(NSError *error))failureBlock{
    [VFHttpManage getWithUrlString:@"c/bankCard" parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//银行卡限额列表
+ (void)getBankLimitListSuccessBlock:(void(^)(NSDictionary *data))successBlock
                    withFailureBlock:(void(^)(NSError *error))failureBlock{
    [VFHttpManage getWithUrlString:@"c/bank/limit" parameters:@{@"flush":@"0"} success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}

//钱包余额充值
+ (void)walletRechargePar:(NSDictionary *)par
             SuccessBlock:(void(^)(NSDictionary *data))successBlock
         withFailureBlock:(void(^)(NSError *error))failureBlock{
    [VFHttpManage postWithUrlString:@"c/wallet/recharge" parameters:par success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
    }];
}


@end
