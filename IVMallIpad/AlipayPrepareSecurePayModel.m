//
//  AlipayPrepareSecurePayModel.m
//  IVMall
//
//  Created by SMiT on 14-4-22.
//  Copyright (c) 2014年 www.smit.com.cn. All rights reserved.
//

#import "AlipayPrepareSecurePayModel.h"

@implementation AlipayPrepareSecurePayModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            _subject = [data objectForKey:@"subject"];
            _body = [data objectForKey:@"body"];
            _outTradeNo = [data objectForKey:@"outTradeNo"];
            _totalFee = [[data objectForKey:@"totalFee"]doubleValue];
            _notifyURL = [data objectForKey:@"notifyURL"];
        }
    }
    return self;
}
@end
