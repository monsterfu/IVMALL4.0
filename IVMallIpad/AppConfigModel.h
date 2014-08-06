//
//  AppConfigModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfigModel : NSObject//应用控制

@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* appVersion;
@property(nonatomic,strong)NSString * copyright;
@property(nonatomic,strong)NSString * charge;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
