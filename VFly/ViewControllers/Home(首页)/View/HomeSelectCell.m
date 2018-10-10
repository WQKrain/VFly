//
//  HomeSelectCell.m
//  VFly
//
//  Created by 毕博洋 on 2018/9/10.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "HomeSelectCell.h"

@implementation HomeSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupView];
    }
    
    return self;
    
}


- (void)setupView {

    
    self.select1Button = [[UIButton alloc]init];
    self.select1Button.frame = CGRectMake(0, 0, SCREEN_WIDTH_S / 4, SCREEN_WIDTH_S / 750 * 180);
    self.select1Button.backgroundColor = [UIColor whiteColor];
    [self.select1Button addTarget:self action:@selector(select1:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.select1Button];
    
    self.logoImage1View = [[UIImageView alloc]init];
    self.logoImage1View.image = [UIImage imageNamed:@"home_icon_one"];
    self.logoImage1View.frame = CGRectMake(self.select1Button.width / 2 - 22, 10, 44, 44);
    [self.select1Button addSubview:self.logoImage1View];
    
    self.name1Label = [[UILabel alloc] init];
    self.name1Label.backgroundColor = [UIColor whiteColor];
    self.name1Label.font = [UIFont systemFontOfSize:14];
    self.name1Label.textColor = [UIColor blackColor];
    self.name1Label.textAlignment = NSTextAlignmentCenter;
    self.name1Label.text = @"一键租车";
    [self.select1Button addSubview:self.name1Label];
    self.name1Label.sd_layout
    .leftEqualToView(self.select1Button)
    .rightEqualToView(self.select1Button)
    .bottomEqualToView(self.select1Button)
    .heightIs(25);
    
    

    //---------------------------------
     self.select2Button = [[UIButton alloc]init];
     self.select2Button.frame = CGRectMake(SCREEN_WIDTH_S / 4, 0, SCREEN_WIDTH_S / 4, SCREEN_WIDTH_S / 750 * 180);
     self.select2Button.backgroundColor = [UIColor whiteColor];
     [self.select2Button addTarget:self action:@selector(select2:) forControlEvents:(UIControlEventTouchUpInside)];
     [self.contentView addSubview:self.select2Button];
     
     self.logoImage2View = [[UIImageView alloc]init];
     self.logoImage2View.image = [UIImage imageNamed:@"home_icon_two"];
     self.logoImage2View.frame = CGRectMake(self.select2Button.width / 2 - 22, 10, 44, 44);
     [self.select2Button addSubview:self.logoImage2View];
     
     self.name2Label = [[UILabel alloc] init];
     self.name2Label.backgroundColor = [UIColor whiteColor];
     self.name2Label.font = [UIFont systemFontOfSize:14];
     self.name2Label.textColor = [UIColor blackColor];
     self.name2Label.textAlignment = NSTextAlignmentCenter;
     self.name2Label.text = @"豪车接送";
     [self.select2Button addSubview:self.name2Label];
     self.name2Label.sd_layout
     .leftEqualToView(self.select2Button)
     .rightEqualToView(self.select2Button)
     .bottomEqualToView(self.select2Button)
     .heightIs(25);
    
    
    
    
    
    
    
    
    //---------------------------------
    self.select3Button = [[UIButton alloc]init];
    self.select3Button.frame = CGRectMake( SCREEN_WIDTH_S / 4 * 2, 0, SCREEN_WIDTH_S / 4, SCREEN_WIDTH_S / 750 * 180);
    self.select3Button.backgroundColor = [UIColor whiteColor];
    [self.select3Button addTarget:self action:@selector(select3:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.select3Button];
    
    self.logoImage3View = [[UIImageView alloc]init];
    self.logoImage3View.image = [UIImage imageNamed:@"home_icon_three"];
    self.logoImage3View.frame = CGRectMake(self.select3Button.width / 2 - 22, 10, 44, 44);
    [self.select3Button addSubview:self.logoImage3View];
    
    self.name3Label = [[UILabel alloc] init];
    self.name3Label.backgroundColor = [UIColor whiteColor];
    self.name3Label.font = [UIFont systemFontOfSize:14];
    self.name3Label.textColor = [UIColor blackColor];
    self.name3Label.textAlignment = NSTextAlignmentCenter;
    self.name3Label.text = @"威风会员";
    [self.select3Button addSubview:self.name3Label];
    self.name3Label.sd_layout
    .leftEqualToView(self.select3Button)
    .rightEqualToView(self.select3Button)
    .bottomEqualToView(self.select3Button)
    .heightIs(25);
    
    
    //---------------------------------
    self.select4Button = [[UIButton alloc]init];
    self.select4Button.frame = CGRectMake(SCREEN_WIDTH_S / 4 * 3, 0, SCREEN_WIDTH_S / 4, SCREEN_WIDTH_S / 750 * 180);
    self.select4Button.backgroundColor = [UIColor whiteColor];
    [self.select4Button addTarget:self action:@selector(select4:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.select4Button];
    
    self.logoImage4View = [[UIImageView alloc]init];
    self.logoImage4View.image = [UIImage imageNamed:@"home_icon_four"];
    self.logoImage4View.frame = CGRectMake(self.select4Button.width / 2 - 22, 10, 44, 44);
    [self.select4Button addSubview:self.logoImage4View];
    
    self.name4Label = [[UILabel alloc] init];
    self.name4Label.backgroundColor = [UIColor whiteColor];
    self.name4Label.font = [UIFont systemFontOfSize:14];
    self.name4Label.textColor = [UIColor blackColor];
    self.name4Label.textAlignment = NSTextAlignmentCenter;
    self.name4Label.text = @"车辆托管";
    [self.select4Button addSubview:self.name4Label];
    self.name4Label.sd_layout
    .leftEqualToView(self.select4Button)
    .rightEqualToView(self.select4Button)
    .bottomEqualToView(self.select4Button)
    .heightIs(25);
    

    
    
}

- (void)select1:(UIButton *)button {
    if (self.touchUpBlock)
    {
        self.touchUpBlock(0);
    }
}

- (void)select2:(UIButton *)button {
    
    if (self.touchUpBlock)
    {
        self.touchUpBlock(1);
    }
}

- (void)select3:(UIButton *)button {
    if (self.touchUpBlock)
    {
        self.touchUpBlock(2);
    }
    
}
- (void)select4:(UIButton *)button {
    if (self.touchUpBlock)
    {
        self.touchUpBlock(3);
    }
    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
