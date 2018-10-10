//
//  VFCarDetailServiceTableViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/18.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^VFCarDetailServerViewButtonActionBlock)(NSInteger buttonTag);

@interface VFCarDetailServiceTableViewCell : UITableViewCell
@property (nonatomic, copy) VFCarDetailServerViewButtonActionBlock carDetailServerClickBlock;
@end
