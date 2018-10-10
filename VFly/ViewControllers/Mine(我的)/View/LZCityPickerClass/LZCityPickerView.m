//
//  LZCityPickerView.m
//  LZCityPicker
//
//  Created by Artron_LQQ on 16/8/29.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZCityPickerView.h"
#import "CityModel.h"
#import "VFNotificationCityModel.h"

#define lz_screenWidth ([UIScreen mainScreen].bounds.size.width)
#define lz_screenHeight ([UIScreen mainScreen].bounds.size.height)
// 216 UIPickerView固定高度
static NSInteger const lz_pickerHeight = 246;
static NSInteger const lz_buttonHeight = 30;

@interface LZCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    
    // 记录当前选择器是否已经显示
    BOOL __isShowed ;
    
    NSString *_pid;
}
 // 当前父视图
@property (nonatomic, strong) UIView *_superView;
@property (nonatomic, copy) lz_backBlock _selectBlock;
@property (nonatomic, copy) lz_actionBlock _cancelBlock;

// subViews
@property (strong, nonatomic)UIView *contentView;
@property (strong, nonatomic)UIPickerView *pickerView;
@property (strong, nonatomic)UIButton *commitButton;
@property (strong, nonatomic)UIButton *cancelButton;
@property (strong, nonatomic)UIImageView *bkgImageView;
@property (strong, nonatomic)UIVisualEffectView *blurView;
@property (strong, nonatomic)CALayer *topLine;
//dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) LZProvince *__currentProvience;
@property (nonatomic, strong) LZCity *__currentCity;
@property (nonatomic, strong) LZArea *__currentArea;

@property (nonatomic, strong) NSDictionary *selectDic;

@end
@implementation LZCityPickerView

+ (instancetype)showInView:(UIView *)view selectDic:(NSDictionary*)dic didSelectWithBlock:(lz_backBlock)block cancelBlock:(lz_actionBlock)cancel {
    
    LZCityPickerView* cityPicker = [[LZCityPickerView alloc]init];
    cityPicker.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_pickerHeight);
    cityPicker._superView = view;
    
    cityPicker.autoChange = YES;
    [cityPicker showWithBlock:nil];
    
    cityPicker._selectBlock = block;
    cityPicker._cancelBlock = cancel;
    cityPicker.selectDic = dic;
    cityPicker.interval = 0.20;
    
    
    [cityPicker pickerView];
    
    if (cityPicker.backgroundImage) {
        
        cityPicker.bkgImageView.image = cityPicker.backgroundImage;
        
        [cityPicker insertSubview:cityPicker.blurView aboveSubview:cityPicker.bkgImageView];
    }
    
    if (!cityPicker.autoChange) {
        cityPicker.cancelButton.frame = CGRectMake(10, 5, 40, lz_buttonHeight - 10);
    }
    
    cityPicker.commitButton.frame = CGRectMake(lz_screenWidth - 50, 0, 40, 40);
    cityPicker.cancelButton.frame = CGRectMake(10, 0, 40, 40);
    UILabel *titleLabel = [UILabel initWithTitle:@"选择地区" withFont:kTitleBigSize textColor:kdetailColor];
    titleLabel.frame = CGRectMake(50, 0, kScreenW-100, 40);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cityPicker.contentView addSubview:titleLabel];
    cityPicker.topLine.frame = CGRectMake(0, 0, lz_screenWidth, 0.4);
    [cityPicker.contentView.layer addSublayer:cityPicker.topLine];
    
    
    VFNotificationCityModel *obj = [[VFNotificationCityModel alloc]initWithDic:cityPicker.selectDic];
    for (int i = 0; i<cityPicker.dataSource.count; i++) {
        LZProvince *pro = [cityPicker.dataSource objectAtIndex:i];
        if ([pro.name isEqualToString:obj.provinceName]) {
            [cityPicker.pickerView selectRow:i inComponent:0 animated:YES];
            
            cityPicker.__currentProvience = pro;
            
            for (int j=0; j<cityPicker.__currentProvience.cities.count; j++) {
                LZCity *city = [cityPicker.__currentProvience.cities objectAtIndex:j];
                if ([city.name isEqualToString:obj.cityName]) {
                    
                    cityPicker.__currentCity = city;
                    [cityPicker.pickerView selectRow:j inComponent:1 animated:YES];
                    
                    for (int k=0; k<cityPicker.__currentCity.areas.count; k++) {
                        LZArea *area = [cityPicker.__currentCity.areas objectAtIndex:k];
                        if ([area.name isEqualToString:obj.countyName]) {
                            [cityPicker.pickerView selectRow:k inComponent:2 animated:YES];
                            
                            [cityPicker setPrvice:pro city:city county:area];
                        }
                    }
                    
                }
            }
        }
    }
    return cityPicker;
}

- (void)setPrvice:(LZProvince *)prvice city:(LZCity *)city county:(LZArea *)county{
    self.__currentProvience  = prvice;
    self.__currentCity = city;
    self.__currentArea = county;
}

- (void)showWithBlock:(void(^)())block {
    if (__isShowed == YES) {
        return;
    }
    
    __isShowed = YES;
    [self._superView addSubview:self];
    [UIView animateWithDuration:self.interval animations:^{
        self.frame = CGRectMake(0, lz_screenHeight - lz_pickerHeight, lz_screenWidth, lz_pickerHeight);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}

- (void)dismissWithBlock:(void(^)())block {
    
    if (__isShowed == NO) {
        return;
    }
    
    __isShowed = NO;
    [UIView animateWithDuration:self.interval animations:^{
        self.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_pickerHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (block) {
            block();
        }
    }];
}

#pragma mark - property getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

- (NSDictionary *)textAttributes {
    if (_textAttributes == nil) {
        _textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
    }
    
    return _textAttributes;
}

- (NSDictionary *)titleAttributes {
    if (_titleAttributes == nil) {
        _titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
    }
    
    return _titleAttributes;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSAssert(!self._superView, @"ERROR: Please use 'showInView:didSelectWithBlock:' to initialize, and the first parameter can not be nil!");
//        NSLog(@"视图初始化了");
        self.backgroundColor = [UIColor whiteColor];
        [self loadData];
    }
    
    return self;
}


- (void)dealloc {
}
#pragma mark - /** 加载数据源 */
- (void)loadData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area_mini" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray* dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *provinceArr = [[NSMutableArray alloc]init];
    //此步骤取出所有的省
    for (NSDictionary *province in dataArr) {
        CityModel *obj = [[CityModel alloc]initWithDic:province];
        [provinceArr addObject:obj];
    }
    
    for (CityModel *obj in provinceArr) {
        //通过全部省份的数组出来所有的城市
        LZProvince *province = [[LZProvince alloc]init];
        province.name = obj.name;
        NSMutableArray *cityArr = [[NSMutableArray alloc]init];
        for (NSDictionary *temCity in obj.child) {
            CityModel *obj = [[CityModel alloc]initWithDic:temCity];
            LZCity *city = [[LZCity alloc]init];
            city.name = obj.name;
            city.province = province.name;
            
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            NSMutableArray *code = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in obj.child) {
                [arr addObject:dic[@"name"]];
                [code addObject:dic[@"id"]];
            }
            city.areas = arr;
            city.codes = code;
            [cityArr addObject:city];
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:arr.count];
            
            for (int i=0;i < city.areas.count;i++) {
                LZArea *area = [[LZArea alloc]init];
                area.name = city.areas[i];
                area.cityCode = city.codes[i];
                area.province = province.name;
                area.city = city.name;
                [array addObject:area];
            }
            
            city.areas = array;
            
        }
        province.cities = [cityArr copy];
        [self.dataSource addObject:province];
    }
    
    // 设置当前数据
    LZProvince *defPro = [self.dataSource firstObject];
    
    self.__currentProvience = defPro;
    
    LZCity *defCity = [defPro.cities firstObject];
    
    self.__currentCity = defCity;
    
    self.__currentArea = [defCity.areas firstObject];
}

#pragma mark - 懒加载子视图
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_contentView];
    }
    
    return _contentView;
}

- (UIImageView *)bkgImageView {
    if (_bkgImageView == nil) {
        _bkgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bkgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bkgImageView.clipsToBounds = YES;
        [self insertSubview:_bkgImageView atIndex:0];
    }
    
    return _bkgImageView;
}

- (UIVisualEffectView *)blurView {
    if (_blurView == nil) {
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        blurView.frame = _bkgImageView.bounds;
        
        _blurView = blurView;
    }
    
    return _blurView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, lz_buttonHeight, lz_screenWidth, lz_pickerHeight - lz_buttonHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        [self.contentView addSubview:_pickerView];
    }
    
    return _pickerView;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"完成" attributes:self.titleAttributes];
        [_commitButton setAttributedTitle:str forState:UIControlStateNormal];
        
        [_commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commitButton];
    }
    
    return _commitButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"取消" attributes:self.titleAttributes];
        [_cancelButton setAttributedTitle:str forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelButton];
    }
    
    return _cancelButton;
}

- (CALayer *)topLine {
    if (_topLine == nil) {
        _topLine = [CALayer layer];
        _topLine.backgroundColor = [UIColor grayColor].CGColor;
    }
    
    return _topLine;
}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    [self pickerView];
//
//    if (self.backgroundImage) {
//
//        self.bkgImageView.image = self.backgroundImage;
//
//        [self insertSubview:self.blurView aboveSubview:self.bkgImageView];
//    }
//
//    if (!self.autoChange) {
//        self.cancelButton.frame = CGRectMake(10, 5, 40, lz_buttonHeight - 10);
//    }
//
//    self.commitButton.frame = CGRectMake(lz_screenWidth - 50, 0, 40, 40);
//    self.cancelButton.frame = CGRectMake(10, 0, 40, 40);
//    UILabel *titleLabel = [UILabel initWithTitle:@"选择地区" withFont:kTitleBigSize textColor:kdetailColor];
//    titleLabel.frame = CGRectMake(50, 0, kScreenW-100, 40);
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:titleLabel];
//    self.topLine.frame = CGRectMake(0, 0, lz_screenWidth, 0.4);
//    [self.contentView.layer addSublayer:self.topLine];
//
//
//    VFNotificationCityModel *obj = [[VFNotificationCityModel alloc]initWithDic:self.selectDic];
//
//    NSLog(@"==============================%@",self.selectDic);
//    NSLog(@"==============================%@",obj.cityName);
//    NSLog(@"==============================%@",obj.countyName);
//
//    for (int i = 0; i<self.dataSource.count; i++) {
//        LZProvince *pro = [self.dataSource objectAtIndex:i];
//        if ([pro.name isEqualToString:obj.provinceName]) {
//            [_pickerView selectRow:i inComponent:0 animated:YES];
//        }
//    }
//
//    for (int j=0; j<__currentProvience.cities.count; j++) {
//        LZCity *city = [__currentProvience.cities objectAtIndex:j];
//        if ([city.name isEqualToString:obj.cityName]) {
//            [_pickerView selectRow:j inComponent:1 animated:YES];
//        }
//    }
//
//    for (int k=0; k<__currentCity.areas.count; k++) {
//        LZArea *area = [__currentCity.areas objectAtIndex:k];
//        if ([area.name isEqualToString:obj.countyName]) {
//            [_pickerView selectRow:k inComponent:1 animated:YES];
//        }
//    }
//
//}
#pragma mark - 按钮点击事件
- (void)commitButtonClick:(UIButton *)button {
    
    // 选择结果回调
    if (self._selectBlock) {
        NSString *address = [NSString stringWithFormat:@"%@-%@-%@",self.__currentArea.province,self.__currentArea.city,self.__currentArea.name];
        self._selectBlock(address,self.__currentArea.province,self.__currentArea.city,self.__currentArea.name,self.__currentArea.cityCode);
    }
    
    __weak typeof(self)ws = self;
    [self dismissWithBlock:^{
        
        if (ws._cancelBlock) {
            ws._cancelBlock();
        }
    }];
}

- (void)cancelButtonClick:(UIButton *)button {
    
    __weak typeof(self)ws = self;
    [self dismissWithBlock:^{
        
        if (ws._cancelBlock) {
            ws._cancelBlock();
        }
    }];
}

#pragma mark - UIPickerView 代理和数据源方法
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    
//    CGFloat width = lz_screenWidth/3.0;
//    
//    if (component == 0) {
//        return width - 20;
//    } else if (component == 1) {
//        
//        return width;
//    } else {
//        
//        return width + 20;
//    }
//}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.dataSource.count;
    } else if (component == 1) {
        
        return self.__currentProvience.cities.count;
    } else {
        
        return self.__currentCity.areas.count;
    }
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    return @"城市列表";
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        
        LZProvince *pro = [self.dataSource objectAtIndex:row];
//        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:pro.name attributes:self.textAttributes];
//        label.attributedText = attStr;
        label.text =pro.name;
    } else if (component == 1) {
        if (self.__currentProvience.cities.count > row) {
            
            LZCity *city = [self.__currentProvience.cities objectAtIndex:row];
//            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:city.name attributes:self.textAttributes];
//            label.attributedText = attStr;
            label.text = city.name;
        }
    } else {
        if (self.__currentCity.areas.count > row) {
            
            LZArea *area = [self.__currentCity.areas objectAtIndex:row];
//            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:area.name attributes:self.textAttributes];
//            label.attributedText = attStr;
            label.text = area.name;
        }
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
    if (component == 0) {
        
        LZProvince *province = [self.dataSource objectAtIndex:row];
        self.__currentProvience = province;
        
        LZCity *city = [province.cities firstObject];
        self.__currentCity = city;
        
        self.__currentArea = [city.areas firstObject];
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        
        if (self.__currentProvience.cities.count > row) {
            
            LZCity *city = [self.__currentProvience.cities objectAtIndex:row];
            self.__currentCity = city;
            
            self.__currentArea = [city.areas firstObject];
        }
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 2) {
        
        if (self.__currentCity.areas.count > row) {
             self.__currentArea = [self.__currentCity.areas objectAtIndex:row];
        }
    }
    
    // 选择结果回调
    if (__selectBlock && self.autoChange) {
        
        NSString *address = [NSString stringWithFormat:@"%@-%@-%@",self.__currentArea.province,self.__currentArea.city,self.__currentArea.name];
        __selectBlock(address,self.__currentArea.province,self.__currentArea.city,self.__currentArea.name,self.__currentArea.cityCode);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
