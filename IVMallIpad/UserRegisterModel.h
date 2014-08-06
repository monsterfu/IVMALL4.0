//
//  UserRegisterModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRegisterModel : NSObject//用户注册

@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* token;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
