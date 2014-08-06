//
//  ProductPlayModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ProductPlayModel.h"

@implementation ProductPlayModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        _errorCode=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
             NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _URI = [data objectForKey:@"URI"];
                _catchupURI = [data objectForKey:@"catchupURI"];
            }
        }
    }else{
        _errorCode=-1;
    }
    return self;
}
@end
