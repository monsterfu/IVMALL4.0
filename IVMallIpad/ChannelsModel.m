//
//  ChannelsModel.m
//  IVMall (Ipad)
//
//  Created by sean on 14-3-4.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ChannelsModel.h"

@implementation ChannelsModel

- (id)initWithDictionary:(NSDictionary *)dictionary channArray:(NSMutableArray*)channList{
    if (self=[super init]) {
        _channelCode= [dictionary objectForKey:@"channelCode"];
        _channelType= [dictionary objectForKey:@"channelType"];
        _channelName= [dictionary objectForKey:@"channelName"];
        _channelImg= [dictionary objectForKey:@"channelImg"];
        _copyright= [dictionary objectForKey:@"copyright"];
    }
    return self;
}

@end
