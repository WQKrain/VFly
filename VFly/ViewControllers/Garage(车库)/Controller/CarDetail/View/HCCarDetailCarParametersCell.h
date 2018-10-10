//
//  HCCarDetailCarParametersCell.h
//  LuxuryCar
//
//  Created by sunhui on 16/11/16.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFCarDetailModel;
// label的tag值，方便赋值
typedef NS_ENUM(NSUInteger, HCCarDetailParametersType){
    HCCarDetailParametersZero = 1,
    HCCarDetailParametersThree = 4
};

@interface HCCarDetailCarParametersCell : UITableViewCell

@property (nonatomic, strong) VFCarDetailModel *carDetailModel; /* 数据 */
@end
