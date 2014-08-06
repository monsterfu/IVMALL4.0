//
//  RegistModel.m
//  IVMall
//
//  Created by fangfang on 13-11-20.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import "RegistModel.h"
#import "Commonality.h"
#import "AppDelegate.h"
#import "Macro.h"

@implementation RegistModel
@synthesize result;
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        result=[[dictionary objectForKey:@"errorCode"]intValue];
        if (result==0) {
            NSDictionary* data=[dictionary objectForKey:@"data"];
            if (data) {
            }
        }
    }else{
        result=-1;
    }
    return self;
}
@end
