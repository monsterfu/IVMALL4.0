//
//  BuyAddModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyAddModel : NSObject//购买产品

@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,assign)double balance;
@property(nonatomic,assign)double points;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
