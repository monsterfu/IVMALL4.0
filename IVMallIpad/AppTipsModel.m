//
//  AppTipsModel.m
//  IVMallHD
//
//  Created by SMiT on 14-7-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "AppTipsModel.h"

@implementation AppTipsModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _errorCode =[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode==0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _anonymousTips  =   [data objectForKey:@"anonymous.login.tips"];
                _vipExpiryTime  =   [data objectForKey:@"vipExpiryTime"];
                _currentTime    =   [data objectForKey:@"currentTime"];

            }
        }
    }else{
        _errorCode=-1;
    }
    return self;
    
}
@end
