//
//  VFOrderEvaluationModel.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/16.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFOrderEvaluationModel.h"

@implementation VFOrderEvaluationModel

- (id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSDictionary *tempDic = dic[@"evaluationDetails"];
        self.images = tempDic[@"images"];
        self.compositeScore = tempDic[@"compositeScore"];
        self.appearanceScore = tempDic[@"appearanceScore"];
        self.cleanScore = tempDic[@"cleanScore"];
        self.attitudeScore = tempDic[@"attitudeScore"];
        self.evaluationContent = tempDic[@"evaluationContent"];
        self.time = tempDic[@"time"];
    }
    return self;
}

@end
