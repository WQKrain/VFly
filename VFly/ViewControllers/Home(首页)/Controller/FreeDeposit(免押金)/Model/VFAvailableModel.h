//
//  VFAvailableModel.h
//  LuxuryCar
//
//  Created by Hcar on 2018/2/2.
//  Copyright © 2018年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFAvailableModel : NSObject

@property (nonatomic,strong) NSString * quantity;
@property (nonatomic,strong) NSString * used;
@property (nonatomic,strong) NSString * available;

- (id) initWithDic:(NSDictionary *)dic;

@end
