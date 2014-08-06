//
//  UserRegisterModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserRegisterModel.h"
#import "Macro.h"
@implementation UserRegisterModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        if (_result==0) {
            NSDictionary* data=[dictionary objectForKey:@"data"];
            if (data) {
                _token = [data objectForKey:@"token"];
            }
        }else{
            _errorMessage = [dictionary objectForKey:@"errorMessage"];
        }
    }else{
        _result=-1;
    }
    return self;
}
@end
