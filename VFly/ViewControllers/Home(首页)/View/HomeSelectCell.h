//
//  HomeSelectCell.h
//  VFly
//
//  Created by 毕博洋 on 2018/9/10.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSelectCell : UITableViewCell

@property (nonatomic, copy) void(^touchUpBlock)(NSInteger a);

//点击按钮
@property (nonatomic, strong) UIButton *select1Button;
@property (nonatomic, strong) UIImageView *logoImage1View;
@property (nonatomic, strong) UILabel *name1Label;

@property (nonatomic, strong) UIButton *select2Button;
@property (nonatomic, strong) UIImageView *logoImage2View;
@property (nonatomic, strong) UILabel *name2Label;

@property (nonatomic, strong) UIButton *select3Button;
@property (nonatomic, strong) UIImageView *logoImage3View;
@property (nonatomic, strong) UILabel *name3Label;

@property (nonatomic, strong) UIButton *select4Button;
@property (nonatomic, strong) UIImageView *logoImage4View;
@property (nonatomic, strong) UILabel *name4Label;




@end
