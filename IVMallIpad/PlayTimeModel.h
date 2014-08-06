//
//  PlayTimeModel.h
//  IVMallHD
//
//  Created by SmitJh on 14-7-16.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayTimeModel : NSObject
@property(assign,nonatomic)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(assign,nonatomic)int day;
@property(assign,nonatomic)int week;
@property(assign,nonatomic)int month;
@property(assign,nonatomic)int total;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
