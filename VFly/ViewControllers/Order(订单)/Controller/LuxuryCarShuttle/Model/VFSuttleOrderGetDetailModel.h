//
//  VFSuttleOrderGetDetailModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/10/31.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFSuttleOrderGetDetailModel : NSObject
@property (nonatomic,strong) NSString * carModel;
@property (nonatomic,strong) NSString * descriptionStr;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * level;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * smallImage;
@property (nonatomic,strong) NSString * title;

- (id) initWithDic:(NSDictionary *)dic;

@end
