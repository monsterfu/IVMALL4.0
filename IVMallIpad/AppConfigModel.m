//
//  AppConfigModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "AppConfigModel.h"

@implementation AppConfigModel

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        _errorCode=[[dictionary objectForKey:@"errorCode"]intValue];
        if (_errorCode==0) {
            NSDictionary* data=[dictionary objectForKey:@"data"];
            if (data) {
                _appVersion = [data objectForKey:@"appVersion"];
                _copyright =[data objectForKey:@"copyright"];
                _charge =[data objectForKey:@"charge"];
                
            }
        }else{
            _errorMessage = [dictionary objectForKey:@"errorMessage"];
        }
    }else{
        _errorCode = -1;
    }
    return self;
}
@end
