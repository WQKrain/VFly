//
//  VFCarLogoModel.h
//  VFly
//
//  Created by Hcar on 2018/5/15.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFCarLogoModel : NSObject

@property (nonatomic,strong) NSArray * brandList;
- (id) initWithDic:(NSDictionary *)dic;
@end


@interface VFCarLogoListModel : NSObject

@property (nonatomic,strong) NSString * brand;
@property (nonatomic,strong) NSString * x2;
@property (nonatomic,strong) NSString * x3;
- (id) initWithDic:(NSDictionary *)dic;
@end
