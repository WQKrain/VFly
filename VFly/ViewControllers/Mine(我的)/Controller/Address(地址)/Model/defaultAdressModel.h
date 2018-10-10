//
//  defaultAdressModel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/7/28.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface defaultAdressModel : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * addressID;

- (id) initWithDic:(NSDictionary *)dic;

@end
