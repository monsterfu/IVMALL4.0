//
//  TradeResultModel.m
//  IVMallHD
//
//  Created by Monster on 14-7-29.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "TradeResultModel.h"

@implementation TradeResultModel


- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result==0) {
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"data"]];
            if(dic){
                _points = [[dic objectForKey:@"points"]doubleValue];
                _tradeResult = [dic objectForKey:@"tradeResult"];
            }
        }
    }else{
        _result=-1;
    }
    return self;
}
@end