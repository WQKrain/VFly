//
//  VFUpoladImageModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFUpoladImageModel : NSObject

@property (nonatomic,strong) NSString * picId;
@property (nonatomic,strong) NSString * path;
- (id) initWithDic:(NSDictionary *)dic;

@end
