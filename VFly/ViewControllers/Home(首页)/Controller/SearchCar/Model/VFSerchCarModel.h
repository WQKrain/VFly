//
//  VFSerchCarModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/28.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFSerchCarModel : NSObject

@property (nonatomic,strong) NSArray * carList;
@property (nonatomic,strong) NSString * total;
- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFSerchCarListModel : NSObject

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * logo;
@property (nonatomic,strong) NSString * carId;
@property (nonatomic,strong) NSString * tags;
- (id) initWithDic:(NSDictionary *)dic;
@end
