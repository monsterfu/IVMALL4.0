//
//  UserLoginModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserLoginModel.h"
#import "AppDelegate.h"

@implementation UserLoginModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        _errorCode=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode==0)
        {
            NSDictionary* data=[dictionary objectForKey:@"data"];
            if (data)
            {
                _token = [data objectForKey:@"token"];
//                [AppDelegate App].token = _token;
                _vipExpiryTime = [data objectForKey:@"vipExpiryTime"];
                _vipExpiryTip = [data objectForKey:@"vipExpiryTip"];
                _vipLevel = [[data objectForKey:@"vipLevel"]intValue];
            }
        }
    }else
    {
        _errorCode=-1;
    }
    return self;
}
@end
