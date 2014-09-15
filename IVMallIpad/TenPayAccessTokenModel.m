//
//  TenPayAccessTokenModel.m
//  IVMallHD
//
//  Created by Monster on 14-9-1.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "TenPayAccessTokenModel.h"

@implementation TenPayAccessTokenModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        _errorCode = [dictionary objectForKey:@"errorCode"];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if ([_errorCode isEqualToString:@"0"]) {
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"data"]];
            if(dic){
                _accessToken = [dic objectForKey:@"accessToken"];
            }
        }
    }
    return self;
}
@end
