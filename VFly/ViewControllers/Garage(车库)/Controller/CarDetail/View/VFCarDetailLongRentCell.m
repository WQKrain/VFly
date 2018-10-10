//
//  VFCarDetailLongRentCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/20.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFCarDetailLongRentCell.h"
#import "VFCarDetailModel.h"
@implementation VFCarDetailLongRentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"image_discount"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    return self;
}

- (void)setModel:(VFCarDetailModel *)model{
//    if (!_bgView) {
//        _bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 200)];
//        _bgView.backgroundColor = kWhiteColor;
//        [self addSubview:_bgView];
//        for (int i=0; i<5; i++) {
//            UILabel *oneColumn= [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kdetailColor];
//            oneColumn.textAlignment = NSTextAlignmentCenter;
//            [_bgView addSubview:oneColumn];
//
//            UILabel *twoColumn= [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kdetailColor];
//            twoColumn.textAlignment = NSTextAlignmentCenter;
//
//            [_bgView addSubview:twoColumn];
//
//            UILabel *threeColumn= [UILabel initWithTitle:@"" withFont:kTextBigSize textColor:kdetailColor];
//            threeColumn.textAlignment = NSTextAlignmentCenter;
//            [_bgView addSubview:threeColumn];
//
//            if (i== 0 || i== 2 || i== 4) {
//                oneColumn.backgroundColor = kNewBgColor;
//                twoColumn.backgroundColor = kNewBgColor;
//                threeColumn.backgroundColor = kNewBgColor;
//            }
//
//            if (i>0) {
//                NSArray *dataArr = model.level;
//                VFCarLevelDetailModel *levelModel = [[VFCarLevelDetailModel alloc]initWithDic:dataArr[i-1]];
//                oneColumn.text =kFormat(@"%@-%@天", levelModel.minDay,levelModel.maxDay);
//                float price = [model.price intValue]*[levelModel.zk floatValue];
//                twoColumn.text = kFormat(@"%.2f", price);
//
//                if (i!=0) {
//                    threeColumn.text = model.price;
//                }
//
//            }else{
//                threeColumn.text = @"普通日均价(元)";
//                oneColumn.text = @"天数";
//                twoColumn.text = @"长租日均价(元)";
//            }
//
//            switch (i) {
//                case 0:
//                    oneColumn.frame = CGRectMake(0, 0, kSpaceW(100), 36);
//                    twoColumn.frame = CGRectMake(oneColumn.right, 0, ceilf(kSpaceW(120)),36);
//                    threeColumn.frame = CGRectMake(twoColumn.right, 0, ceilf(self.width-30-kSpaceW(220)), 36);
//                    break;
//                case 1:
//                    oneColumn.frame = CGRectMake(0, 36, kSpaceW(100), 46);
//                    twoColumn.frame = CGRectMake(oneColumn.right, 36, ceilf(kSpaceW(120)), 46);
//                    threeColumn.frame = CGRectMake(twoColumn.right, 36, ceilf(self.width-30-kSpaceW(220)), 46);
//                    break;
//                case 2:
//                    oneColumn.frame = CGRectMake(0, 82, kSpaceW(100), 36);
//                    twoColumn.frame = CGRectMake(oneColumn.right, 82, ceilf(kSpaceW(120)), 36);
//                    threeColumn.frame = CGRectMake(twoColumn.right, 82, ceilf(self.width-30-kSpaceW(220)), 36);
//                    break;
//                case 3:
//                    oneColumn.frame = CGRectMake(0, 118, kSpaceW(100), 46);
//                    twoColumn.frame = CGRectMake(oneColumn.right, 118, ceilf(kSpaceW(120)), 46);
//                    threeColumn.frame = CGRectMake(twoColumn.right, 118, ceilf(self.width-30-kSpaceW(220)), 46);
//                    break;
//                case 4:
//                    oneColumn.frame = CGRectMake(0, 164, kSpaceW(100), 36);
//                    twoColumn.frame = CGRectMake(oneColumn.right, 164, ceilf(kSpaceW(120)), 36);
//                    threeColumn.frame = CGRectMake(twoColumn.right, 164, ceilf(self.width-30-kSpaceW(220)), 36);
//                    break;
//                default:
//                    break;
//            }
//        }
//
//    }
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
