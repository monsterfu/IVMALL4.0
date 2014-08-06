//
//  AppTipsModel.h
//  IVMallHD
//
//  Created by SMiT on 14-7-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTipsModel : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* anonymousTips;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
