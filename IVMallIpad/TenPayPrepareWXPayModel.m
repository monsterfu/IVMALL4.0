//
//  TenPayPrepareWXPayModel.m
//  IVMallHD
//
//  Created by Monster on 14-9-1.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "TenPayPrepareWXPayModel.h"

@implementation TenPayPrepareWXPayModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        _errorCode = [dictionary objectForKey:@"errorCode"];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if ([_errorCode isEqualToString:@"0"]) {
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"data"]];
            if(dic){
                _prepayid = [dic objectForKey:@"prepayid"];
                _nonceStr = [dic objectForKey:@"nonceStr"];
                _timestamp = [dic objectForKey:@"timestamp"];
                _packageValue = [dic objectForKey:@"packageValue"];
                _sign = [dic objectForKey:@"sign"];
                _accessToken = [dic objectForKey:@"accessToken"];
                _subject = [dic objectForKey:@"subject"];
                _body = [dic objectForKey:@"body"];
                _outTradeNo = [dic objectForKey:@"outTradeNo"];
                _totalFee = [dic objectForKey:@"totalFee"];
            }
        }
    }
    return self;
}
@end
