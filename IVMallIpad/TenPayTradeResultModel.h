//
//  TenPayTradeResultModel.h
//  IVMallHD
//
//  Created by Monster on 14-9-1.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenPayTradeResultModel : NSObject
@property(nonatomic,assign)int result;
@property (nonatomic,strong) NSString* errorMessage;
@property (nonatomic,strong) NSString* tradeResult;
@property (nonatomic,assign) double points;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
