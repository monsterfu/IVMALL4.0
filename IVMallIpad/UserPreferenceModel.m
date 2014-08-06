//
//  UserPreferenceModel.m
//  IVMallHD
//
//  Created by  周传森 on 14-4-23.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserPreferenceModel.h"

@implementation UserPreferenceModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _preferenceKey = [data objectForKey:@"preferenceKey"];
                _preferenceValue = [data objectForKey:@"preferenceValue"];
            }
        }
    }else{
        _errorCode=-1;
    }
    return self;
}
@end
