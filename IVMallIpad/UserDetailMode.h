//
//  UserDetailMode.h
//  IVMallHD
//
//  Created by SMiT on 14-7-7.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailMode : NSObject

@property (nonatomic,assign) int errorCode;
@property (nonatomic,strong) NSString* errorMessage;
@property (nonatomic,strong) NSString* nickname;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* lang;
@property (nonatomic,strong) NSString* birthday;
@property (nonatomic,strong) NSString* gender;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,assign) float balance;
@property (nonatomic,strong) NSString* userImg;
@property (nonatomic,strong) NSString* vipExpiryTime;
@property (nonatomic,strong) NSString* vipExpiryTip;
@property (nonatomic,assign) int vipLevel;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
