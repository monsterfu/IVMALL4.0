//
//  UserBalanceModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBalanceModel : NSObject//获取当前余额

@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,assign)double balance;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
