//
//  AppTwoDimensionPayModel.m
//  IVMallHD
//
//  Created by Monster on 14-7-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "AppTwoDimensionPayModel.h"

@implementation AppTwoDimensionPayModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            _qrcodeURL = [data objectForKey:@"qrcodeURL"];
            _qrcodeImgURL = [data objectForKey:@"qrcodeImgURL"];
            _outTradeNo = [data objectForKey:@"outTradeNo"];
        }
    }
    return self;
}
@end
