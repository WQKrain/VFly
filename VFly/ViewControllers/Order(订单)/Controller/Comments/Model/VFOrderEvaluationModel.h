//
//  VFOrderEvaluationModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/16.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFOrderEvaluationModel : NSObject
@property (nonatomic,strong) NSArray * images;
@property (nonatomic,strong) NSString * compositeScore;
@property (nonatomic,strong) NSString * appearanceScore;
@property (nonatomic,strong) NSString * cleanScore;
@property (nonatomic,strong) NSString * attitudeScore;
@property (nonatomic,strong) NSString * evaluationContent;
@property (nonatomic,strong) NSString * time;
- (id) initWithDic:(NSDictionary *)dic;
@end
