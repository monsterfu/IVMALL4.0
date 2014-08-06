//
//  UserDetailMode.m
//  IVMallHD
//
//  Created by SMiT on 14-7-7.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserDetailMode.h"

@implementation UserDetailMode

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _nickname = [data objectForKey:@"nickname"];
                _email = [data objectForKey:@"email"];
                _lang = [data objectForKey:@"lang"];
                _birthday = [data objectForKey:@"birthday"];
                _gender = [data objectForKey:@"gender"];
                _address = [data objectForKey:@"address"];
                _balance = [[data objectForKey:@"balance"]floatValue];
                _userImg = [data objectForKey:@"userImg"];
                _vipExpiryTime = [data objectForKey:@"vipExpiryTime"];
                _vipExpiryTip = [data objectForKey:@"vipExpiryTip"];
                _vipLevel = [[data objectForKey:@"vipLevel"]intValue];
            }
        }
    }
    return  self;
}
@end
