//
//  VFChooseSeatsViewController.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "BaseViewController.h"
@class VFSuttleListArrModel;
@protocol carSeatDelegate;
@interface VFChooseSeatsViewController : BaseViewController
@property (nonatomic , strong)VFSuttleListArrModel *carModel;
@property (nonatomic , retain)id <carSeatDelegate> delegate;
@property (nonatomic , assign)BOOL isChange;
@end

@protocol carSeatDelegate <NSObject>
@optional

- (void)carSeatButtonClick:(NSString *)seat;
@end

