//
//  UpdatePersonInfoModel.m
//  IVMall
//
//  Created by fangfang on 13-11-21.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import "UpdatePersonInfoModel.h"
#import "Macro.h"
@implementation UpdatePersonInfoModel
@synthesize result;

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        result=[[dictionary objectForKey:@"errorCode"]intValue];
    }else{
        result=-1;
    }
    return self;
}
@end
