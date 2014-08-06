//
//  PayAddModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayAddModel : NSObject//点卡充值

@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,assign)double balance;          //用户余额
@property(nonatomic,strong)NSString* createTime;    //充值时间
@property(nonatomic,assign)CGFloat points;          //充值额度
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
