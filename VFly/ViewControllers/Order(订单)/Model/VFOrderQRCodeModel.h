//
//  VFOrderQRCodeModel.h
//  LuxuryCar
//
//  Created by Hcar on 2018/1/16.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFOrderQRCodeModel : NSObject
@property (nonatomic,strong) NSString * qrcode_src;
@property (nonatomic,strong) NSString * overdue_time;
- (id) initWithDic:(NSDictionary *)dic;
@end
