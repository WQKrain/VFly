//
//  HttpManage.m
//  JSFLuxuryCar
//
//  Created by joyingnet on 16/7/30.
//  Copyright © 2016年 joyingnet. All rights reserved.
//

#import "HttpManage.h"
#import "BeeCloud.h"                            // 支付

#import "NSString+Base64.h"

#import "HCBannerModel.h"
#import "HttpRequest.h"

#import "LoginModel.h"

@implementation HttpManage

#pragma mark ------------免押金2.0-----------
//用户授信情况
+ (void)getCustomerQualificationSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"customer/qualification" parameters:@{@"token":token} success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//旧资料重新提交审核资料
+ (void)resetQualifyParameter:(NSDictionary *)dic success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"customer/reQualify" parameters:dic success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//剩余名额
+ (void)getFreedepositAvailableSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"freedeposit/available" parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//排行榜
+ (void)getFreedepositTopsSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"freedeposit/tops" parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//车库列表
+ (void)getFreedepositCarsParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"freedeposit/cars" parameters:dic success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//免押金自驾下单
+ (void)appFreedepositRentalOrderParameter:(NSDictionary *)dic success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"freedeposit/rentalOrder" parameters:dic success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//获取门店列表
+ (void)getStoresSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"stores" parameters:nil success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//获取订单服务二维码
+ (void)getQrcodeUrlParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"order/service/qrcode" parameters:dic success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

// app下载自定义参数上传
+ (void)appDownloadParameter:(NSString *)content success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"c/download/submit" parameters:@{@"count_data":content} success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

// 需求车辆提交接口
+ (void)needCarSubmitParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"needCarSubmit" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//获取接送订单详情
+ (void)getShuttleDetailParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"shuttleDetail" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//获取订单续租折扣算法
+ (void)getOrderEvaluationParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"getOrderEvaluation" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//获取订单续租折扣算法
+ (void)renewMapParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"renewMap" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//跳过认证 (未使用)
+ (void)jumpCreditSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    NSString *token  =[[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"jumpCredit" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//环信注册
+ (void)getHxUserSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"getHxUser" parameters:nil success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//获取常见问题列表
+ (void)getQuestionJsonDataSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"getQuestionJsonData" parameters:nil success:^(id data) {
        NSDictionary*diction=(NSDictionary*)data;
//        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(diction);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//获取通知消息列表
+ (void)getNoticeMessageParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"getNoticeMessage" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}


//获取钱包及账单消息列表
+ (void)messageListWithParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"messageList" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//获取钱包及账单消息未读数
+ (void)unreadMessageSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"unreadMessage" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//热门城市
+ (void)getHotCitySuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    
    [HttpRequest getWithUrlString:@"getHotCity" parameters:@{@"limit":@"6"} success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//热门标签
+ (void)getCarTagWithParameter:(NSDictionary *)dic withSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    
    [HttpRequest getWithUrlString:@"getHotVocabulary" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//热门车型
+ (void)getHotCarWithParameter:(NSDictionary *)dic withSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    
    [HttpRequest getWithUrlString:@"getHotCar" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//删除订单
+ (void)orderDelParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"orderDel" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//订单评价
+ (void)orderEvaluationParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"orderEvaluation" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//获取订单评价
+ (void)getOrderEvaluationParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"getOrderEvaluation" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        
    }];
}

//续租
+ (void)rentalRenewParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"rentalRenew" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}


//根据订单号获取金额
+ (void)getMoneyByOrderIdParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"getMoneyByOrderId" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//确认还车 v1.3
+ (void)confirmReturnCarParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"confirmReturnCar" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"加载失败"];
    }];
}

//银行卡限额列表
+ (void)bankLimitListSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"bankLimitList" parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//获取vip信息
+ (void)getVipInfoSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"getVipInfo" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//vip卡列表 1.1
+ (void)vipLevelListSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"vipLevelList" parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//充值vip下单
+ (void)vipOrderParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock{
    [HttpRequest postWithUrlString:@"viprecharge" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
        [ProgressHUD showError:@"加载失败"];
    }];
}

//预存款明细
+ (void)vipLogParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"vipLog" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}


//预存款明细详情
+ (void)vipDetailParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"vipDetail" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//预存款充值下单
+ (void)viprechargeParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock{
    [HttpRequest postWithUrlString:@"viprecharge" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"加载失败"];
    }];
}

//超值套餐下的车辆列表（未使用）
+ (void)packageCarListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"packageCarList" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//车辆信息获取（未使用）
+ (void)packageCarInfoParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"packageCarInfo" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//超值套餐申请（未使用）
+ (void)packageApplyParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock{
    [HttpRequest postWithUrlString:@"packageApply" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"加载失败"];
    }];
}


//活动抽奖（未使用）
+ (void)lotteryDrawSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest postWithUrlString:@"lotteryDraw" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        if ([model.info isEqualToString:@"ok"]) {
            myBlock(model.data);
        }else{
            [CustomTool alertViewShow:model.info];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"加载失败"];
    }];
}

/*
 地址
 */

//我的地址列表
+ (void)myAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"myAddress" parameters:parameter success:^(id data) {
        
//        NSLog(@"=======================================%@",data);
        
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//添加地址
+ (void)addAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"addAddress" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//编辑地址
+ (void)editAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"editAddress" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//删除地址
+ (void)delAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"delAddress" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//设置为默认地址
+ (void)setAddressParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"setAddress" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//单条地址详情
+ (void)addressDetailParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest postWithUrlString:@"addressDetail" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//获取默认地址
+ (void)getDefaultAddressSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"getDefaultAddress" parameters:@{@"token":token} success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        
    }];
}



//优惠券列表
+ (void)couponParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"couponList" parameters:parameter success:^(id data) {
//        NSLog(@"============data========%@",data);
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//过期优惠券列表
+ (void)expiredCouponListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"expiredCouponList" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//选择优惠券的列表
+ (void)chooseListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"chooseList" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//积分明细
+ (void)scoreLogParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"scoreLog" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//积分明细详情
+ (void)scoreDetailParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [HttpRequest getWithUrlString:@"scoreDetail" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}


//获取未读消息数
+ (void)getmMessageCount:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"unreadMessage" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        
    }];
}

//连连用户签约信息查询 API 接口 （未使用）
+ (void)queryLLBankCardBineListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock{
    [HttpRequest thirdUrlString:@"https://queryapi.lianlianpay.com/bankcardbindlist.htm" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}

//全局配置获取
+ (void)getGlobalConfig:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest getWithUrlString:@"globalConfig" parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//获取合伙人状态
+ (void)checkIsSellerSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"checkIsSeller" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//个人资料列表
+ (void)creditListSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"creditList" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//设置个人资料
+ (void)setUserInfoParameter:(NSDictionary *)parameter success:(void (^)(NSString*))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"setUserInfo" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//意见反馈
+ (void)feedbackParameter:(NSDictionary *)parameter success:(void (^)(NSString*))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"feedback" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}



//上传图片
+ (void)uploadFileImage:(NSData *)image success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest uploadFile:@"upload" image:image success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//获取首页轮播图
+ (void)getBannerSuccess:(void (^)(NSArray *))myBlock failedBlock:(void (^)())failedBlock{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *url = kFormat(@"getBanner/%@", app_Version);
    [HttpRequest getWithUrlString:url parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSArray *array = [NSArray array];
        HCBannerModel *banModel = [[HCBannerModel alloc]initWithDic:model.data];
        array = banModel.bannerList;
        myBlock(array);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//自驾租车车辆列表 new （未使用）
+ (void)getCarListForIndexParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest getWithUrlString:@"carListForIndex" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//会员级别列表 new
+ (void)getVipLevelListParameter:(NSDictionary *)parameter success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)(NSError *error))failedBlock
{
    [HttpRequest getWithUrlString:@"vipLevelList" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(error);
    }];
}


//身份信息获取 new
+ (void)getCardInfoSuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"cardInfo" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *temp = model.data;
        [[NSUserDefaults standardUserDefaults]setObject:temp[@"name"] forKey:kname];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//我的收藏 new
+ (void)getStarListParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest getWithUrlString:@"starList" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//我的足迹 new（未使用）
+ (void)getVisitListParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest getWithUrlString:@"visitList" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//车辆托管提交
+ (void)carTrusteeshipParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"carTrusteeship" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//设置头像
+ (void)setAvatarParameter:(NSDictionary *)parameter With:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"setAvatar" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//设置昵称
+ (void)setNicknameParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"setNickname" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//获取余额
+ (void)getMoneySuccess:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    [HttpRequest getWithUrlString:@"getMoney" parameters:@{@"token":token} success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        if ([model.info isEqualToString:@"ok"]) {
            myBlock(model.data);
        }
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//银行卡列表 new
+ (void)getBankCardListParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest getWithUrlString:@"bankCardList" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//新增银行卡 new（未使用）
+ (void)addbankCardParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"addbankCard" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//充值下单
+ (void)rechargeParameter:(NSDictionary *)parameter With:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"recharge" parameters:parameter success:^(id data) {
        myBlock(data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}


//编辑银行卡（未使用）
+ (void)editBankCardParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"editBankCard" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//删除银行卡（未使用）
+ (void)delBankCardParameter:(NSDictionary *)parameter Success:(void (^)(NSString *))statusBlock withFailedBlock:(void (^)())failedBlock{
    [HttpRequest getWithUrlString:@"delBankCard" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        statusBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}


//站内支付
+ (void)walletPayParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"walletPay" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.info);
    } failure:^(NSError *error) {
       failedBlock(kFormat(@"%@", error));
    }];
}


//申请提现（未使用）
+ (void)cashApplyParameter:(NSDictionary *)parameter With:(void (^)(NSString *))myBlock failedBlock:(void (^)())failedBlock
{
    [HttpRequest postWithUrlString:@"cashApply" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        myBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//余额明细
+ (void)getWalletLogParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))statusBlock withFailedBlock:(void (^)())failedBlock{
    [HttpRequest getWithUrlString:@"walletLog" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        statusBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}


//余额明细详情
+ (void)getWalletDetailParameter:(NSDictionary *)parameter Success:(void (^)(NSDictionary *))statusBlock withFailedBlock:(void (^)())failedBlock{
    [HttpRequest getWithUrlString:@"walletDetail" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        statusBlock(model.data);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

//获取验证码
+ (void)getPhoneCodeWith:(NSString *)account action:(NSString *)action withBlock:(void (^)(NSString *))statusBlock withFailedBlock:(void (^)())failedBlock{
    [HttpRequest getWithUrlString:[NSString stringWithFormat:@"sms?mobile=%@&action=%@",account,action] parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        statusBlock(model.info);
    } failure:^(NSError *error) {
        failedBlock(kFormat(@"%@", error));
    }];
}

+ (void)getTokenWithTel:(NSString *)tel WithCode:(NSString *)code WithSuccessBlock:(void (^)(NSString *))myBlock{
    NSString *pushID = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
    NSDictionary *dic;
    if (pushID) {
        dic = @{@"mobile":tel,@"code":code,@"pushId":pushID};
    }else{
        dic = @{@"mobile":tel,@"code":code};
    }
    
    [HttpRequest postWithUrlString:@"login" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        if ([obj.info isEqualToString:@"ok"]) {
            LoginModel *model = [[LoginModel alloc]initWithDic:obj.data];
            NSString *tokenStr = model.token;
            //存储access_Token
            [[NSUserDefaults standardUserDefaults] setObject:tokenStr forKey:access_Token];
        }
        myBlock(obj.info);
    } failure:^(NSError *error) {
        
    }];
}

// 提交自驾租车订单信息
+ (void)submitPickUpOrderInfoWith:(NSDictionary *)parameterDic withSuccessfulBlock:(void(^)(NSDictionary *dic))successfulBlock withFailureBlock:(void (^)(NSString *failedData))failureBlock;
{
    [HttpRequest postWithUrlString:@"rentalOrder" parameters:parameterDic success:^(id data) {
        successfulBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error.userInfo);
    }];
}

//自驾租车获取金额回调（未使用）
+ (void)getRentalInfoParameterDic:(NSDictionary *)parameterDic withSuccessfulBlock:(void(^)(NSDictionary *dic))successfulBlock withFailureBlock:(void (^)(NSString *failedData))failureBlock{
    
    [HttpRequest postWithUrlString:@"getRentalInfo" parameters:parameterDic success:^(id data) {
        successfulBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}


//搜索
+ (void)getSearchCarDataWithPar:(NSDictionary *)dic With:(void (^)(NSDictionary *))myBlock failedBlock:(void (^)())failedBlock{
    [HttpRequest getWithUrlString:@"searchCar" parameters:dic success:^(id data) {
        HCBaseMode *baseObj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *tempDic = baseObj.data;
        myBlock(tempDic);
    } failure:^(NSError *error) {
    }];
}

//'接送'信息介绍（未使用）
+ (void)getPickUpIntroduceInfo:(void (^)(NSArray *))infoBlock;
{
    [HttpRequest getWithUrlString:@"getShuttleList" parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dic = model.data;
        NSArray *arr = dic[@"shuttleList"];
        if (infoBlock) {
            infoBlock(arr);
        }

    } failure:^(NSError *error) {
        
    }];
}

//豪车接送列表
+ (void)getShuttleListSuccessBlock:(void(^)(NSDictionary *dic))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock
{
    [HttpRequest getWithUrlString:@"shuttleList" parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        successBlock(model.data);
    } failure:^(NSError *error) {
        
    }];
}


//豪车接送 获取金额回调（未使用）
+ (void)getShuttleInfoDict:(NSDictionary *)dict withSuccessBlock:(void(^)(NSDictionary *dic))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock
{
    [HttpRequest postWithUrlString:@"getShuttleInfo" parameters:dict success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}


//豪车接送 提交订单
+ (void)hotCarSubmitOrderInfoWithDict:(NSDictionary *)dict withSuccessBlock:(void(^)(NSDictionary *dic))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock
{
    [HttpRequest postWithUrlString:@"shuttleOrder" parameters:dict success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}


//获取用户信息
+(void)getUserInfoWithToken:(NSString *)token withSuccessBlock:(void (^)(NSDictionary *))dicBlock withFailedBlock:(void (^)())failedBlcok
{
    [HttpRequest getWithUrlString:kFormat(@"getInfoByToken?token=%@", token) parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        LoginModel *obj = [[LoginModel alloc]initWithDic:model.data];
        NSString *credit = obj.credit;
        //存储用户信用绑定状态
        [[NSUserDefaults standardUserDefaults] setObject:credit forKey:creditStatus];
        [[NSUserDefaults standardUserDefaults] setObject:obj.mobile forKey:kmobile];
        [[NSUserDefaults standardUserDefaults] setObject:obj.name forKey:kname];
        [[NSUserDefaults standardUserDefaults] setObject:obj.headImg forKey:kHeadImage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dicBlock(model.data);
    } failure:^(NSError *error) {
        
    }];
}

//身份信息验证（未使用）
+ (void)updataCreditName:(NSString *)name withCardID:(NSString *)cardID withSuccessfulBlock:(void(^)(NSString *str))successfulBlock withFailureBlock:(void(^)(NSString *failedData))failureBlock {
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    
    NSDictionary *dictionary = @{
                                 @"name":name,
                                 @"card":cardID,
                                 @"token":tokenStr
                                 };

    [HttpRequest postWithUrlString:@"setCredit" parameters:dictionary success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        if ([model.info isEqualToString:@"ok"]) {
            [[NSUserDefaults standardUserDefaults]setObject:name forKey:kname];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:creditStatus];
        }else {
            [CustomTool alertViewShow:model.info];
        }
        successfulBlock(model.info);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//获取自驾订单列表
+ (void)getUserOrderMessageParameter:(NSDictionary *)parameter success:(void(^)(NSDictionary *data))myBlock failure:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"rentalList" parameters:parameter success:^(id data) {
        
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *tempDic = model.data;
        if (myBlock) {
            myBlock(tempDic);
        }
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//获取接送订单列表
+ (void)getUserShuttlesOrderParameter:(NSDictionary *)parameter success:(void(^)(NSDictionary *data))myBlock failure:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"shuttles" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *tempDic = model.data;
        if (myBlock) {
            myBlock(tempDic);
        }
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}


//获取已关闭订单列表
+ (void)getCloseOrderMessageParameter:(NSDictionary *)parameter success:(void(^)(NSDictionary *data))myBlock failure:(void(^)(NSError *error))failureBlock{
    [HttpRequest getWithUrlString:@"getCloseOrder" parameters:parameter success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *tempDic = model.data;
        if (myBlock) {
            myBlock(tempDic);
        }
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}


//获取车辆详情
+ (void)getTheCarImageByCarID:(NSString *)carID success:(void(^)(NSDictionary *data))myBlock failure:(void(^)(NSError *error))failureBlock{
    NSDictionary *cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    VFNotificationCityModel *model = [[VFNotificationCityModel alloc]initWithDic:cityDic];
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    if (tokenStr) {
        
    }else{
        tokenStr = @"";
    }
    NSDictionary *dictionary = @{
                                 @"token":tokenStr,
                                 @"carId":carID,
                                 @"cityId":model.countyID
                                 };
    
    [HttpRequest getWithUrlString:@"getCarDetail" parameters:dictionary success:^(id data) {
        HCBaseMode *baseObj = [[HCBaseMode alloc]initWithDic:data];
        if (myBlock) {
            myBlock(baseObj.data);
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"加载失败"];
    }];
}


+ (void)getOrderMessageWithOrderID:(NSString *)order_id With:(void(^)(NSDictionary *dic))myBlock
{
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSDictionary *dictionary = @{
                                 @"token":tokenStr,
                                 @"orderId":order_id,
                                 };

    [HttpRequest getWithUrlString:@"orderDetail" parameters:dictionary success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = model.data;
        myBlock(dataDic);
    } failure:^(NSError *error) {
    }];
}


//我要还车  待更新
+(void)willGoBackTheCarWithOrderId:(NSString *)orderId withBlock:(void (^)(NSString *))statusBlock
{
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *_loginID = [[NSUserDefaults standardUserDefaults]objectForKey:LoginId];
    
    NSDictionary *dictionary = @{@"type":@"",
                                 @"value":_loginID,
                                 @"token":tokenStr,
                                 @"order_id":orderId
                                 };
    [HttpRequest postWithUrlString:@"return_car" parameters:dictionary success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        statusBlock(obj.info);
    } failure:^(NSError *error) {
        
    }];
}

//提交订单评论 待更新
+ (void)updateCommentContentWithOrderId:(NSString *)orderId withRating:(NSInteger)starNum withContent:(NSString *)content withBlock:(void (^)(NSString *))statusBlock
{
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *_loginID = [[NSUserDefaults standardUserDefaults]objectForKey:LoginId];
    NSString *star = [NSString stringWithFormat:@"%ld",(long)starNum];
    NSDictionary *dictionary = @{@"type":@"",
                                 @"value":_loginID,
                                 @"token":tokenStr,
                                 @"order_id":orderId,
                                 @"star":star,
                                 @"comment":content
                                 };

    [HttpRequest postWithUrlString:@"comment_order" parameters:dictionary success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        statusBlock(obj.info);
    } failure:^(NSError *error) {
        
    }];
}

//浏览记录 待更新
+(void)visitLogListWithUserId:(NSString *)uid withBlock:(void (^)(NSMutableArray *))arrayBlock
{
    NSDictionary *parameters = [NSDictionary dictionary];
    parameters = @{@"uid":uid};
    [HttpRequest getWithUrlString:@"list_visit_log" parameters:parameters success:^(id data) {
        
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"浏览记录获取失败"];
    }];
}

//收藏车辆/取消收藏
+ (void)favoriteCollectioCarWithCarId:(NSString *)carId withBlock:(void (^)(NSString *))statusBlock
{
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:access_Token];
    NSString *token = tokenStr? tokenStr:@"0";
    NSDictionary *parameters = [NSDictionary dictionary];
        parameters = @{@"carId":carId,@"token":token};
        [HttpRequest postWithUrlString:@"c/star/car" parameters:parameters success:^(id data) {
            NSString *status = [NSString stringWithFormat:@"%@", data[@"data"][@"isStar"]];
        if (statusBlock) {
            statusBlock(status);
        }
    } failure:^(NSError *error) {
        NSError *underError = error.userInfo[@"NSUnderlyingError"];
        NSData *responseData = underError.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [ProgressHUD showError:@"操作失败"];
    }];
}

//获取我的收藏  待更新
+ (void)getMyFavoriteCollectionCarWithUserId:(NSString *)uid withBlock:(void (^)(NSMutableArray *))arrayBlock
{
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!uid) {
        parameters = nil;
    } else
    {
        parameters = @{@"uid":uid};
    }

    [HttpRequest getWithUrlString:@"list_love_log" parameters:parameters success:^(id data) {
        
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"收藏获取失败"];
    }];
}

//判断用户是否上传身份信息  待更新
+ (void)isUpdateUserInfoWithUid:(NSString *)uid withBlock:(void (^)(NSDictionary *))statusBlock
{
    [HttpRequest getWithUrlString:@"check_id" parameters:nil success:^(id data) {
        statusBlock(data);
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
    }];
}


//待更新
+ (void)checkOutPrivateFunctionWithBlock:(void (^)(NSDictionary *))dictBlock
{

}

//待更新
+ (void)uploadContacts:(NSDictionary *)contactsDict WithBlock:(void (^)(NSDictionary *))dictBlock
{
    //对通讯录进行AES加密
    NSData *dataDic = [NSJSONSerialization dataWithJSONObject:contactsDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *Str = [[NSString alloc] initWithData:dataDic encoding:NSUTF8StringEncoding];
    NSString *contactsStr = [AESCrypt encrypt:Str password:@"wangzhiyu"];
    

}

//待更新
+ (void)uploadCoordinate:(NSDictionary *)coordinateDict WithBlock:(void (^)(NSDictionary *))dictBlock
{
    NSDictionary *paramatersDict = @{
                                     @"localVersion":kAppLocalVersion,
                                     @"deviceIDFA":[[NSUserDefaults standardUserDefaults] objectForKey:kDeviceIDFA],
                                     @"token":[[NSUserDefaults standardUserDefaults] objectForKey:access_Token],
                                     @"value":[[NSUserDefaults standardUserDefaults] objectForKey:LoginId],
                                     @"coordinate":coordinateDict
                                     };
    [HttpRequest postWithUrlString:@"coordinate" parameters:paramatersDict success:^(id data) {
        
    } failure:^(NSError *error) {
    }];
}

//待更新
+ (void)shareAppWithUserID:(NSString *)userID Block:(void (^)(NSDictionary *))dictBlock
{
    [HttpRequest postWithUrlString:@"share" parameters:nil success:^(id data) {
        
    } failure:^(NSError *error) {
    }];
}

//=======================================================================

// 新首页 限时优惠（未使用）
+ (void)getHomeLimitedTimeOffersWithSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;
{
    [HttpRequest getWithUrlString:@"getDiscount" parameters:nil success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//首页 资讯文章列表
+ (void)getHomeActivitiesParameter:(NSDictionary *)parameter SuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock
{
    [HttpRequest getWithUrlString:@"news" parameters:parameter success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        successBlock(dataDic);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//近期活动
+ (void)getActivityParameter:(NSDictionary *)parameter SuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock
{
    [HttpRequest getWithUrlString:@"getActivity" parameters:parameter success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        successBlock(dataDic);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//消息列表
+ (void)messageListParameter:(NSDictionary *)parameter SuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock{
    [HttpRequest getWithUrlString:@"messageList" parameters:parameter success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        successBlock(dataDic);
    } failure:^(NSError *error) {
         failureBlock(error.domain);
    }];
}

// 新首页 热门车型
+ (void)getHomeHotCarWithCity:(NSString *)city withSuccessBlock:(void(^)(NSArray *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;
{
    [HttpRequest getWithUrlString:@"getTopCar" parameters:@{@"cityId":city} success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        NSArray *tempArr = dataDic[@"topCarList"];
        successBlock(tempArr);
    } failure:^(NSError *error) {
//        failureBlock(error.domain);
    }];
}

// 新首页 一键租车（未使用）
+ (void)getShortcutRentCarInfoWithSuccessBlock:(void(^)(NSArray *brands, NSArray *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock;
{
    [HttpRequest getWithUrlString:@"getOnekeyCarList" parameters:nil success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        NSArray *carList =dataDic[@"carList"];
        NSArray *brands = dataDic[@"brandList"];
        successBlock(brands,carList);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

// 新首页 一键租车 提交申请 （未使用）
+ (void)submitShortcutCarOrderInfoWithDict:(NSDictionary *)dict withSuccessBlock:(void(^)(NSString *info))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;
{
    [HttpRequest postWithUrlString:@"oneKey" parameters:dict success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.info);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//=======================================================================

// 车型(新 出行) logo
+ (void)getCarLogoWithSuccessBlock:(void(^)(NSArray *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;
{
    [HttpRequest getWithUrlString:@"getBrandList" parameters:nil success:^(id data) {
        HCBaseMode *model = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = model.data;
        NSArray *dataArr = dataDic[@"brandList"];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in dataArr) {
            CarModel *model = [[CarModel alloc] init];
            model.name = dict[@"brand"];
            model.picUrl = dict[@"x3"];
            [dataArray addObject:model];
        }
        successBlock(dataArray);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

// 车型(新 出行) 车辆列表
+ (void)getCarDataForLogoWithLocalCity:(NSString *)city withCarLogo:(NSString *)logo withSuccessBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock;
{ [HttpRequest getWithUrlString:@"getCarList" parameters:@{@"cityId":city,@"brand":logo} success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        successBlock(obj.data);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//获取热门标签
+ (void)getHotLabelSuccessBlock:(void(^)(NSArray *data))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock {
    [HttpRequest getWithUrlString:@"getCarTag" parameters:nil success:^(id data) {
        NSArray *array = [NSArray array];
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *temoDic = obj.data;
        array = temoDic[@"tagList"];
        if (successBlock) {
            successBlock(array);
        }

    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//=======================================================================

// 订单信息 根据地区改变价格
+ (void)getPriceFromCityWithCarId:(NSString *)carId withCity:(NSString *)city withSuccessBlock:(void(^)(NSString *priceStr))successBlock withFailureBlock:(void(^)(NSString *result_msg))failureBlock
{
    NSDictionary *dic = @{@"carId":carId,@"city":city};
    [HttpRequest getWithUrlString:@"getCarPriceByCity" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        successBlock(dataDic[@"price"]);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//还车城市（未使用）
+ (void)getCarBackCitySuccessBlock:(void(^)(NSArray *dataArr))successBlock withFailureBlock:(void(^)(NSString *error))failureBlock
{
    [HttpRequest getWithUrlString:@"returnCityList" parameters:nil success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        successBlock(dataDic[@"location"]);
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
}

//=======================================================================

//实名认证
+ (void)beeCloudAuthReqWithName:(NSString *)name withIdNo:(NSString *)idNo withCard_no:(NSString *)card_no withMobile:(NSString *)mobile withSuccessBlock:(void (^)())successBlock withFailureBlock:(void (^)(NSString *))failureBlock
{
    NSMutableDictionary *parameters = [BCPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [BCPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    if (!name.isValid) {
        if (failureBlock) {
            failureBlock(@"姓名错误");
        };
        return;
    }
    if (!idNo.isValid) {
        if (failureBlock) {
            failureBlock(@"身份证号错误");
        };
        return;
    }
    if (!card_no.isValid) {
        if (failureBlock) {
            failureBlock(@"银行卡号错误");
        };
        return;
    }
    if (!mobile.isValid) {
        if (failureBlock) {
            failureBlock(@"手机号错误");
        };
        return;
    }
    parameters[@"name"] = name;
    parameters[@"id_no"] = idNo;
    parameters[@"card_no"] = card_no;
    parameters[@"mobile"] = mobile;
    
    BCHTTPSessionManager *manager = [BCPayUtil getBCHTTPSessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/2/auth", kBCHost] parameters:parameters progress:nil
          success:^(NSURLSessionTask *task, id response) {
              if (response[@"resultCode"] == BCErrCodeSuccess) {
                  
                  if (successBlock) {
                      successBlock();
                  }
              } else
              {
                  if (failureBlock) {
                      failureBlock(response[@"result_msg"]);
                  };
              }
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              if (failureBlock) {
                  failureBlock(kNetWorkError);
              };
          }];
}

+ (void)recommendCarsWithCarID:(NSString *)carID withBlock:(void (^)(NSMutableArray *))arrayBlock
{
    NSDictionary *cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalCity];
    VFNotificationCityModel *model = [[VFNotificationCityModel alloc]initWithDic:cityDic];
    [HttpRequest getWithUrlString:@"getAutoCar" parameters:@{@"cityId":model.countyID,@"limit":@"4"} success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        NSArray *dataArr = dataDic[@"carList"];
        NSMutableArray *callBackArr = [NSMutableArray array];
        for (NSDictionary *dict in dataArr) {
            CarModel *model = [[CarModel alloc] init];
            model.car_ID = dict[@"carId"];
            model.myCarModel = dict[@"title"];
            model.picUrl = dict[@"image"];
            model.price = dict[@"price"];
            [callBackArr addObject:model];
        }
        arrayBlock(callBackArr);
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"推荐车辆获取失败"];
    }];
}

#pragma mark--------------免押金功能实现接口（实名认证、电子签名）---------------------
//实名认证状态于信息
+ (void)realNameAuthenticationStateWithToken:(NSString *)token withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock{
    [HttpRequest getWithUrlString:@"customer/certification/status" parameters:@{@"token":token,} success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        successBlock(dataDic);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//身份证认证
+ (void)idCardcertificationWirhParameter:(NSDictionary *)dic successBlock:(void(^)(NSString *info))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest postWithUrlString:@"customer/certification/card" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSString *info = obj.info;
        successBlock(info);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//驾照认证
+ (void)driveCardcertificationWirhParameter:(NSDictionary *)dic successBlock:(void(^)(NSString *info))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest postWithUrlString:@"customer/certification/driving" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSString *info = obj.info;
        successBlock(info);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//新订单详情（免押金部分）（未使用）
+ (void)depositBreaksOrderDetailWithParameter:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock{
    [HttpRequest getWithUrlString:@"order/detail" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        successBlock(dataDic);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//开通免押金功能（未使用）
+ (void)openDepositBreaksWirhParameter:(NSDictionary *)dic successBlock:(void(^)(NSDictionary *data))successBlock withFailureBlock:(void(^)(NSError *error))failureBlock{
    [HttpRequest postWithUrlString:@"order/freedeposit/open" parameters:dic success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//免押金服务费查询（未使用）
+ (void)queryDepositBreaksSeversPriceWithParameter:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock{
    [HttpRequest getWithUrlString:@"order/freedeposit/service_fee" parameters:dic success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//银行四要素校验
+ (void)bankCardCheakWithParameter:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock{
    [HttpRequest getWithUrlString:@"bankcard/check" parameters:dic success:^(id data) {
        successBlock(data);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

// 历史签约4要素（未使用）
+ (void)bankCardHistoryWithParameter:(NSDictionary *)dic withSuccessBlock:(void (^)(NSDictionary *))successBlock withFailureBlock:(void (^)(NSError *))failureBlock{
    [HttpRequest getWithUrlString:@"bankcard/history" parameters:dic success:^(id data) {
        HCBaseMode *obj = [[HCBaseMode alloc]initWithDic:data];
        NSDictionary *dataDic = obj.data;
        successBlock(dataDic);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

@end
