//
//  NSString+random.m
//  FuMiProduct
//
//  Created by Monster on 14-6-4.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "NSString+random.h"

@implementation NSString (random)

+(NSString*)randomStr
{
    u_int32_t i = arc4random();
    NSString* randStr = [NSString stringWithFormat:@"%d",i];
    randStr = [randStr stringByReplacingOccurrencesOfString:@"-" withString:@"1"];
    randStr = [randStr substringToIndex:6];
    NSDate* date = [NSDate date];
    NSString* dateStr = [date description];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    dateStr = [dateStr substringToIndex:14];
    
    return [NSString stringWithFormat:@"%@%@",dateStr,randStr];
}

@end
