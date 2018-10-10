//
//  VFfreedepositTopsModel.h
//  LuxuryCar
//
//  Created by Hcar on 2018/2/2.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFfreedepositTopsModel : NSObject
@property (nonatomic,strong) NSArray * tops;

- (id) initWithDic:(NSDictionary *)dic;

@end

@interface VFfreedepositTopsListModel : NSObject
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * total_deductions;
@property (nonatomic,strong) NSString * sort;

- (id) initWithDic:(NSDictionary *)dic;

@end
