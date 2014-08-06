//
//  UserLoginModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginModel : NSObject//用户登录

@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* token;
@property(nonatomic,strong)NSString* vipExpiryTime;
@property(nonatomic,strong)NSString* vipExpiryTip;
@property(nonatomic,assign)int vipLevel;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
