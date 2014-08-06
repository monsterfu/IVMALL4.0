//
//  IndexAllInfo.m
//  IVMall (Ipad)
//
//  Created by sean on 14-3-4.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "IndexAllInfo.h"
#import "AdMOdel.h"
#import "ChannelsModel.h"
#import "Macro.h"
@implementation IndexAllInfo

- (id)initWithDictionary:(NSDictionary *)dictionary adArray:(NSMutableArray*)adList  channelsArray:(NSMutableArray*)channelList{
    if (self=[super init]) {
        _errorCode=[[dictionary objectForKey:@"errorCode"]intValue];
        if (_errorCode==0) {
            NSArray*adArray=[[dictionary objectForKey:@"data"]objectForKey:@"ads"];
            for (NSDictionary*dic in adArray) {
                AdMOdel*ad=[[AdMOdel alloc] initWithDictionary:dic adArray:adList];
                NSLog(@"%@",ad);
            }
            
            
            NSArray*channArray=[[dictionary objectForKey:@"data"]objectForKey:@"channels"];
            for (NSDictionary*dic2 in channArray) {
                ChannelsModel*channe=[[ChannelsModel alloc]initWithDictionary:dic2 channArray:channelList];
                [channelList addObject:channe];
            }
            
        }
        
        
    }
    return self;
}

@end
