//
//  VFCommonProblemDetailController.h
//  VFly
//
//  Created by 毕博洋 on 2018/9/20.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VFCommonProblmTitleModel;
@interface VFCommonProblemDetailController : UIViewController

@property (nonatomic , strong)VFCommonProblmTitleModel *dataModel;
@property (nonatomic , strong)NSString *name;
@end

NS_ASSUME_NONNULL_END
