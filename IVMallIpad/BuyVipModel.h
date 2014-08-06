//
//  BuyVipModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyVipModel : NSObject//购买VIP资格

@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,assign)double balance;
@property(nonatomic,strong)NSString* vipExpiryTime;
@property(nonatomic,assign)BOOL vipExpiryTip;
@property(nonatomic,assign)double points;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
