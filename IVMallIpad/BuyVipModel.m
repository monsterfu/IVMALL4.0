//
//  BuyVipModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "BuyVipModel.h"
#import "Macro.h"
@implementation BuyVipModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result == 0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            _balance = [[data objectForKey:@"balance"]doubleValue];
            _vipExpiryTime = [data objectForKey:@"vipExpiryTime"];
            NSString* temp = [data objectForKey:@"vipExpiryTip"];
            if (temp && [temp isEqualToString:@"true"]) {
                _vipExpiryTip = YES;
            }else{
                _vipExpiryTip = NO;
            }
            _points = [[data objectForKey:@"points"]doubleValue];
        }
    }else{
        _result=-1;
    }
    return self;
}
@end
