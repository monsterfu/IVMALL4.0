//
//  AdMOdel.m
//  IVMall (Ipad)
//
//  Created by sean on 14-3-4.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "AdMOdel.h"

@implementation AdMOdel

- (id)initWithDictionary:(NSDictionary *)dictionary adArray:(NSMutableArray*)adList{
    if (self=[super init]) {
        _tmpSting=[dictionary objectForKey:@"channelCode"];
        
        NSArray*arr=[dictionary objectForKey:@"items"];
        for (NSDictionary*dic in arr) {
            AdMOdel*ad=[[AdMOdel alloc]initWithDictionary:dic];
            [adList addObject:ad];
        }
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]){
        _channelCode=_tmpSting;
        _adType= [dictionary objectForKey:@"adType"];
        _adGuid= [dictionary objectForKey:@"adGuid"];
        _adTitle= [dictionary objectForKey:@"adTitle"];
        _adImg= [dictionary objectForKey:@"adImg"];
    }
    return self;
}
@end
