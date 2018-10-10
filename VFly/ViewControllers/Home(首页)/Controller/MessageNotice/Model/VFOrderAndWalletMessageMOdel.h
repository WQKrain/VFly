//
//  VFOrderAndWalletMessageMOdel.h
//  LuxuryCar
//
//  Created by Hcar on 2017/9/30.
//  Copyright © 2017年 zY_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFOrderAndWalletMessageMOdel : NSObject
@property (nonatomic,strong) NSArray * messageList;
@property (nonatomic,strong) NSString * remainder;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFOrderAndWalletMessageListModel : NSObject

@property (nonatomic,strong) NSString * messageID;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,assign) NSInteger otherStatus;
@property (nonatomic,strong) NSString * extends;

- (id) initWithDic:(NSDictionary *)dic;
@end

@interface VFOrderAndWalletMessageExtendsModel : NSObject

@property (nonatomic,strong) NSString * orderId;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * logId;

- (id) initWithDic:(NSDictionary *)dic;
@end
