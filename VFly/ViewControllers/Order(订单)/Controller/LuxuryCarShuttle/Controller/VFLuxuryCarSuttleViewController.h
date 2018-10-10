//
//  VFLuxuryCarSuttleViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class VFSuttleListArrModel;
@protocol CarLevelDelegate;
@interface VFLuxuryCarSuttleViewController : BaseViewController

@property (nonatomic , assign)BOOL isChange;
@property (nonatomic,retain) id <CarLevelDelegate> delegate;

@end

@protocol CarLevelDelegate <NSObject>
@optional

- (void)carLevelButtonClick:(VFSuttleListArrModel *)model;
@end
