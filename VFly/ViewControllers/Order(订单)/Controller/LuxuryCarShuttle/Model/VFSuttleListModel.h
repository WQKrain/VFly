//
//  VFSuttleListModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/22.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFSuttleListModel : NSObject

@property (nonatomic,strong) NSArray * shuttleList;

- (id) initWithDic:(NSDictionary *)dic;


@end

@interface VFSuttleListArrModel : NSObject

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * carModel;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * level;
@property (nonatomic,strong) NSString * deatil;
@property (nonatomic,strong) NSString * smallImage;


- (id) initWithDic:(NSDictionary *)dic;


@end
