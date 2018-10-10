//
//  VFCarApplyTableViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2017/11/17.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VFCarApplyTableViewCell : UITableViewCell
@property (nonatomic , strong)UILabel *titlelabel;
@property (nonatomic , strong)UITextField *inputField;
@property (nonatomic , strong)UILabel *alertlabel;
@property (nonatomic , strong)UIImageView *iconImageView;
@property (nonatomic , strong)NSString *state;
@property (nonatomic , strong)NSString *index;
@end
