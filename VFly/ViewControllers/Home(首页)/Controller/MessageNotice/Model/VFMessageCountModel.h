//
//  VFMessageCountModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFMessageCountModel : NSObject
@property (nonatomic,strong) NSDictionary * message;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFMessageCountListModel : NSObject

@property (nonatomic,strong) NSString * wallet;
@property (nonatomic,strong) NSString * order;

- (id) initWithDic:(NSDictionary *)dic;
@end
