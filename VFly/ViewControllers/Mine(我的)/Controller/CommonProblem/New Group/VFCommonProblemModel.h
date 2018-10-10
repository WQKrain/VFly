//
//  VFCommonProblemModel.h
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VFCommonProblemModel : NSObject
@property (nonatomic,strong) NSArray * data;
@property (nonatomic,strong) NSString * code;
- (id) initWithDic:(NSDictionary *)dic;
@end


@interface VFCommonProblmTitleModel : NSObject
@property (nonatomic,strong) NSArray * children;
@property (nonatomic,strong) NSString * name;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFCommonProblmListModel : NSObject
@property (nonatomic,strong) NSArray * name;
- (id) initWithDic:(NSDictionary *)dic;


@end
