//
//  VFAdvantageView.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/14.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol didSelectTableViewCellDelegate <NSObject>

- (void)myBankCardListAddBankClick;
@end

@interface VFAdvantageView : UIView

@property (nonatomic, assign) id<didSelectTableViewCellDelegate> delegate;

- (void)show:(NSString *)title sectionTitle:(NSArray *)sectionArr rowArr:(NSArray *)rowArr;
-(void)animateOut;
@end
