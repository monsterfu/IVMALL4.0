//
//  AnonymousLogin.h
//  IVMallHD
//
//  Created by SMiT on 14-7-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnonymousLoginMode : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* token;
@property(nonatomic,strong)NSString* vipExpiryTime;
@property(nonatomic,strong)NSString* vipExpiryTip;
@property(nonatomic,assign)int vipLevel;
@property(nonatomic,strong)NSString* nickname;
@property(nonatomic,strong)NSString* userImg;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
