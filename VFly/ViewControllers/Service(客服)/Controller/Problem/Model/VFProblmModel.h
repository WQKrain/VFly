//
//  VFProblmModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/12.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFProblmModel : NSObject
@property (nonatomic,strong) NSArray * data;
@property (nonatomic,strong) NSString * code;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFProblmTitleModel : NSObject
@property (nonatomic,strong) NSArray * children;
@property (nonatomic,strong) NSString * name;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFProblmListModel : NSObject
@property (nonatomic,strong) NSArray * name;
- (id) initWithDic:(NSDictionary *)dic;
@end
