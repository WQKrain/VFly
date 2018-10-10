//
//  EditAddressTableViewCell.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/27.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddressTableViewCell : UITableViewCell
@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UILabel *addressLabel;
@property (nonatomic , strong)UILabel *phoneLabel;
@property (nonatomic , strong)UIButton *deleteBtn;
@property (nonatomic , strong)UIButton *editBtn;
@property (nonatomic , strong)UIButton *defaultBtn;
@property (nonatomic , strong)UILabel *defaultLabel;

@end
