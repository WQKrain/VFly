//
//  CarModel.h
//  JSFLuxuryCar
//
//  Created by joyingnet on 16/7/30.
//  Copyright © 2016年 joyingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarModel : NSObject

@property (nonatomic,copy)NSString *picUrl;//大图的URL
@property (nonatomic,copy)NSString *name;//车的名字
@property (nonatomic,copy)NSString *smallPicUrl;//车标的URL
@property (nonatomic,copy)NSString *decLable;//车辆备注
@property (nonatomic,copy)NSString *color;//车辆颜色
@property (nonatomic,copy)NSString *price;//车辆租金
@property (nonatomic,copy)NSString *carPrice;//车辆价格
@property (nonatomic,copy)NSString *myCarModel;//车辆型号
@property (nonatomic,copy)NSString *introduction;///车辆描述
@property (nonatomic,copy)NSString *car_ID;//车辆id
@property (nonatomic,copy)NSString *deposit;//最低押金
@property (nonatomic,copy)NSString *follow;//收藏
@property (nonatomic,copy)NSString *clickNum;//社交点击量
@property (nonatomic,copy)NSString *commentNum;//社交数据评论
@property (nonatomic,copy)NSString *collectionNum;//社交收藏
@property (nonatomic,copy)NSString *picNum;//社交数据图片
@property (nonatomic,strong)NSArray *carImages;//车辆图片
@property (nonatomic,strong)NSArray *comments;//客户评价
@property (nonatomic,copy)NSString *carYear;//车辆年份
@property (nonatomic, copy) NSString *shareText;// 分享内容
@property (nonatomic, copy) NSString *area;// 地区
// 车辆参数
@property (nonatomic, copy) NSString *CJMC;     // 厂家名称
@property (nonatomic, copy) NSString *JB;       // 级别
@property (nonatomic, copy) NSString *NK;       // 年款
@property (nonatomic, copy) NSString *BSQLX;    // 变速器类型
@property (nonatomic, copy) NSString *FDJXH;    // 发动机型号
@property (nonatomic, copy) NSString *CSXS;     // 车身形式
@property (nonatomic, copy) NSString *CMS;      // 车门数
@property (nonatomic, copy) NSString *ZWS;      // 座位数
@property (nonatomic, copy) NSString *DWS;      // 档位数
@property (nonatomic, copy) NSString *PL;       // 排量

@end
