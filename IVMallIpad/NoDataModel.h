//
//  NoDataModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoDataModel : NSObject//data 无意义

@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
