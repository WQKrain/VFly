//
//  VFEvaluationTableViewCell.m
//  LuxuryCar
//
//  Created by Hcar on 2017/10/16.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import "VFEvaluationTableViewCell.h"
#import "XHStarRateView.h"
#import "VFOrderEvaluationModel.h"

@interface VFEvaluationTableViewCell ()
@property (nonatomic, strong) UILabel *topStarLabel;
@property (nonatomic, strong) UILabel *appearanceLabel;
@property (nonatomic, strong) UILabel *theCarLabel;
@property (nonatomic, strong) UILabel *serviceLabel;

@property (nonatomic, strong) XHStarRateView *topStarRateView;
@property (nonatomic, strong) XHStarRateView *appearancelStarView;
@property (nonatomic, strong) XHStarRateView *theCarStarView;
@property (nonatomic, strong) XHStarRateView *serviceStarView;
@property (nonatomic, strong) UILabel *evaluationLabel;

@end

@implementation VFEvaluationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)createView{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 1)];
    lineView.backgroundColor = klineColor;
    [self addSubview:lineView];
    
    UILabel *titlelabel = [UILabel initWithTitle:@"我的订单" withFont:kTitleBigSize textColor:kdetailColor];
    titlelabel.frame = CGRectMake(15, 30, kScreenW-30, kTitleBigSize);
    [self addSubview:titlelabel];
    
    _topStarLabel = [UILabel initWithTitle:@"非常好" withFont:kTitleSize textColor:kdetailColor];
    _topStarLabel.frame = CGRectMake(15, titlelabel.bottom+24, kScreenW-30, kTitleSize);
    _topStarLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_topStarLabel];
    
    _topStarRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake((kScreenW-205)/2, _topStarLabel.bottom+20, 205, 25)];
    _topStarRateView.isAnimation = YES;
    _topStarRateView.rateStyle = WholeStar;
    [self addSubview:_topStarRateView];
    
    NSArray *titleArr = @[@"外观整洁",@"车内整洁",@"服务态度"];
    for (int i =0; i<3; i++) {
        UILabel *leftLabel = [UILabel initWithTitle:titleArr[i] withFont:kTitleBigSize textColor:kdetailColor];
        leftLabel.frame = CGRectMake(15, _topStarRateView.bottom + 19+i*34, 80, 34);
        [self addSubview:leftLabel];
        
        XHStarRateView *starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(leftLabel.right, leftLabel.top+6, 170, 22)];
        starView.isAnimation = YES;
        starView.rateStyle = WholeStar;
        starView.tag = i;
        [self addSubview:starView];
        
        UILabel *rightLabel = [UILabel initWithTitle:@"非常好" withFont:kTextBigSize textColor:kdetailColor];
        rightLabel.frame = CGRectMake(starView.right+5, _topStarRateView.bottom + 19+i*34, 70, 34);
        [self addSubview:rightLabel];
        
        switch (i) {
            case 0:
                _appearanceLabel = rightLabel;
                _appearancelStarView = starView;
                break;
            case 1:
                _theCarLabel = rightLabel;
                _theCarStarView = starView;
                break;
            case 2:
                _serviceLabel = rightLabel;
                 _serviceStarView = starView;
                break;
                
            default:
                break;
        }
    }
    _evaluationLabel = [UILabel initWithFont:kTextBigSize textColor:kdetailColor];
    _evaluationLabel.frame = CGRectMake(15, 293, kScreenW-30, 30);
    _evaluationLabel.numberOfLines = 0;
    [self addSubview:_evaluationLabel];
}

- (void)setModel:(VFOrderEvaluationModel*)model{
    NSArray *textArr = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
    _topStarLabel.text =textArr[[model.compositeScore intValue]-1];
    _appearanceLabel.text = textArr[[model.appearanceScore intValue]-1];
    _theCarLabel.text = textArr[[model.cleanScore intValue]-1];
    _serviceLabel.text = textArr[[model.attitudeScore intValue]-1];
    
    _topStarRateView.currentScore = [model.compositeScore intValue];
    _appearancelStarView.currentScore = [model.appearanceScore intValue];
    _theCarStarView.currentScore = [model.cleanScore intValue];
    _serviceStarView.currentScore = [model.attitudeScore intValue];
    
    CGSize titleSize = [model.evaluationContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenW-30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    _evaluationLabel.frame  =CGRectMake(15, 293, kScreenW-30, titleSize.height);
    _evaluationLabel.text = model.evaluationContent;
    
    for (int i =0;i<model.images.count;i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]]];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
         imageView.frame = CGRectMake(15+(((kScreenW-60)/3+15)*(i%3)), _evaluationLabel.bottom+(((kScreenW-60)/3+15)*(i/3)), (kScreenW-60)/3, (kScreenW-60)/3);
    }
    [self setNeedsLayout];
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
