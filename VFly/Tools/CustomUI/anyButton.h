//
//  anyButton.h
//  QA
//
//  Created by   on 15-1-14.
//  Copyright (c) 2015年 cl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface anyButton : UIButton
@property (nonatomic,strong) id model;
@property (nonatomic,copy) NSString *valueStr;
-(void)changeImageFrame:(CGRect )rect;
-(void)changeTitleFrame:(CGRect )rect;
@end
