//
//  ChannelCatContentListMode.m
//  IVMallHD
//
//  Created by SMiT on 14-7-11.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ChannelCatContentListMode.h"

@implementation CatContentMode

- (id)initWithDictionary:(NSDictionary *)dictionary

{
    if (self = [super init])
    {
        _contentGuid = [dictionary objectForKey:@"contentGuid"];
        _contentTitle = [dictionary objectForKey:@"contentTitle"];
        _contentDescription = [dictionary objectForKey:@"contentDescription"];
        _contentType = [dictionary objectForKey:@"contentType"];
        _contentImg = [dictionary objectForKey:@"contentImg"];
        _contentFrom = [dictionary objectForKey:@"contentFrom"];
        _isEpisode = [[dictionary objectForKey:@"isEpisode"]intValue];
        _episodeCount = [[dictionary objectForKey:@"episodeCount"]intValue];
        _playCount = [[dictionary objectForKey:@"playCount"]intValue];
        _favoriteCount = [[dictionary objectForKey:@"favoriteCount"]intValue];
        _isCollect = [[dictionary objectForKey:@"isCollect"]intValue];
        _langs = [dictionary objectForKey:@"langs"];
    }
    return self;
}
@end

@implementation ChannelCatContentListMode
- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray*)mList startIndex:(NSInteger)startIndex
{
    if (self = [super init])
    {
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _counts = [[data objectForKey:@"counts"]intValue];
                if (startIndex == 0) {
//                    mList = [[NSMutableArray alloc]initWithCapacity:_counts];
                    [mList removeAllObjects];
                    
                }
                NSArray* list = [data objectForKey:@"list"];
                if (list) {
                    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
                    for (NSDictionary* child in list) {
                        CatContentMode* um = [[CatContentMode alloc]initWithDictionary:child];
                        [tempArray addObject:um];
                    }
                    if (startIndex == 0) {
                        [mList addObjectsFromArray:tempArray];
                    }
                    NSRange range = {startIndex, tempArray.count};
                    [mList replaceObjectsInRange:range withObjectsFromArray:tempArray];
//                    [mList addObjectsFromArray:tempArray];
                }
            }
        }
    }
    return self;
}
@end
