//
//  AnonymousLogin.m
//  IVMallHD
//
//  Created by SMiT on 14-7-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "AnonymousLoginMode.h"

@implementation AnonymousLoginMode
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _errorCode =[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode==0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _token = [data objectForKey:@"token"];
                _vipExpiryTime = [data objectForKey:@"vipExpiryTime"];
                _vipExpiryTip = [data objectForKey:@"vipExpiryTip"];
                _vipLevel = [[data objectForKey:@"vipLevel"]intValue];
                _nickname = [data objectForKey:@"nickname"];
                _userImg = [data objectForKey:@"userImg"];
            }
        }
    }else{
        _errorCode=-1;
    }
    return self;

}
@end
