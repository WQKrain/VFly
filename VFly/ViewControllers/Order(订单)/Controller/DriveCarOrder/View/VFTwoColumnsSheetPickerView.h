//
//  VFTwoColumnsSheetPickerView.h
//  VFly
//
//  Created by Hcar on 2018/4/11.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VFTwoColumnsSheetPickerView;
//回调  pickerView 回传类本身 用来做调用 销毁动作
//     choiceString  回传选择器 选择的单个条目字符串
typedef void(^twoColumnsSheetPickerViewBlock)(VFTwoColumnsSheetPickerView *pickerView,NSString *name,NSString *mobile);

@interface VFTwoColumnsSheetPickerView : UIView

@property (nonatomic,copy)twoColumnsSheetPickerViewBlock callBack;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

//------单条选择器
+(instancetype)VFTwoColumnsSheetPickerViewWithTitle:(NSArray *)title rightArr:(NSArray *)rightArr andHeadTitle:(NSString *)headTitle Andcall:(twoColumnsSheetPickerViewBlock)callBack;
//显示
-(void)show;
//销毁类
-(void)dismissPicker;

@end
