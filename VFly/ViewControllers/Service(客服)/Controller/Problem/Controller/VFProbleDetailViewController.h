//
//  VFProbleDetailViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/12.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class VFProblmTitleModel;
@interface VFProbleDetailViewController : BaseViewController
@property (nonatomic , strong)VFProblmTitleModel *dataModel;
@property (nonatomic , strong)NSString *name;
@end
