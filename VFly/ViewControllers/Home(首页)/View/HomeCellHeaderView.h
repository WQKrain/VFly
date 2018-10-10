//
//  HomeCellHeaderV.h
//  LuxuryCar
//
//  Created by TheRockLee on 2016/11/15.
//  Copyright © 2016年 zY_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HomeCellHeaderType) {
    HomeCellHeaderTypeButton,
    HomeCellHeaderTypeLabel,
    HomeCellHeaderTypeMoreButton,
};

typedef enum : NSUInteger {
    HomeCellHeaderViewLeftButton,
    HomeCellHeaderViewRightButton,
    HomeCellHeaderViewBottomLeftButton,
    HomeCellHeaderViewBottomRightButton,
    HomeCellHeaderViewMoreBtn,
} HomeCellHeaderViewButtonTag;

typedef enum : NSUInteger {
    HomeCellHeaderViewVolatileLabel,
    HomeCellHeaderViewUnvolatileLabel,
} HomeCellHeaderViewLabelType;

typedef void(^HomeCellHeaderViewButtonActionBlock)(NSInteger buttonTag);

@interface HomeCellHeaderView : UIView
@property (nonatomic, strong) UIButton *modrButton;  
@property (nonatomic, strong) UILabel *upperLabel;      // 上部label
@property (nonatomic, strong) UILabel *underLabel;      // 下部label
@property (nonatomic, strong) UIImageView *upperIcon;   // 文字左侧图标
@property (nonatomic, assign) NSInteger timeLag;        // 时间差
@property (nonatomic, assign) BOOL isBegin;
@property (nonatomic, strong) UIImageView *showImage;


@property (nonatomic, copy) HomeCellHeaderViewButtonActionBlock buttonClickBlock;

@property (nonatomic, copy) HomeCellHeaderViewButtonActionBlock moreClickBlock;

- (instancetype)initWithType:(NSUInteger)type UpperStr:(NSString *)upperStr UnderStr:(NSString *)underStr;

@end
