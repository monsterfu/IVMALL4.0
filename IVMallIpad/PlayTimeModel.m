//
//  PlayTimeModel.m
//  IVMallHD
//
//  Created by SmitJh on 14-7-16.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PlayTimeModel.h"

@implementation PlayTimeModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self=[super init]) {
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
            NSDictionary* playTime = [[dictionary objectForKey:@"data"]objectForKey:@"playTime"];
            if (playTime) {
                _day = [[playTime objectForKey:@"day"]intValue];
                _week = [[playTime objectForKey:@"week"]intValue];
                _month = [[playTime objectForKey:@"month"]intValue];
                _total = [[playTime objectForKey:@"total"]intValue];
            }
        }
    }
    return self;
}
@end
