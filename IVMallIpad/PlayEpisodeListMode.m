//
//  PlayEpisodeListMode.m
//  IVMallHD
//
//  Created by SMiT on 14-8-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PlayEpisodeListMode.h"

@implementation EpisodeMode

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _contentGuid = [dictionary objectForKey:@"contentGuid"];
        _contentTitle = [dictionary objectForKey:@"contentTitle"];
        _contentImg = [dictionary objectForKey:@"contentImg"];
        _contentDescription = [dictionary objectForKey:@"contentDescription"];
        _playCount = [[dictionary objectForKey:@"playCount"]intValue];
        _episodeCount = [[dictionary objectForKey:@"episodeCount"]intValue];
        _langs = [dictionary objectForKey:@"langs"];
        _latestPlayTime = [dictionary objectForKey:@"latestPlayTime"];
        _latestPlayEpisode = [[dictionary objectForKey:@"latestPlayEpisode"]intValue];
        _latestPlayLang = [dictionary objectForKey:@"latestPlayLang"];
    }
    return self;
}

@end


@implementation PlayEpisodeListMode
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _errorCode =[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode==0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _pages = [[data objectForKey:@"pages"]intValue];
                _counts = [[data objectForKey:@"counts"]intValue];
                NSArray* list = [data objectForKey:@"list"];
                if (list) {
                    _list = [[NSMutableArray alloc]init];
                    for (NSDictionary* child in list) {
                        EpisodeMode* um = [[EpisodeMode alloc]initWithDictionary:child];
                        [_list addObject:um];
                    }
                }
                
            }
        }
    }else{
        _errorCode=-1;
    }
    return self;
    
}
@end
