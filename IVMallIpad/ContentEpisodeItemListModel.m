//
//  ContentEpisodeItemListModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ContentEpisodeItemListModel.h"

@implementation ContentEpisodeItemListModel
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
                _episodeGuid = [data objectForKey:@"episodeGuid"];
                _episodeTitle = [data objectForKey:@"episodeTitle"];
                _episodeImg = [data objectForKey:@"episodeImg"];
                _episodeDescription = [data objectForKey:@"episodeDescription"];
                _episodeCount = [[data objectForKey:@"episodeCount"]intValue];
                _episodeLast = [[data objectForKey:@"episodeLast"]intValue];
                _playCount = [[data objectForKey:@"playCount"]intValue];
                _favoriteCount = [[data objectForKey:@"favoriteCount"]intValue];
                _isCollect = [[data objectForKey:@"isCollect"]intValue];
                NSArray* list = [data objectForKey:@"list"];
                if (list) {
                    _list = [[NSMutableArray alloc]init];
                    for (NSDictionary* child in list) {
                        ContentItem* um = [[ContentItem alloc]initWithDictionary:child];
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
@implementation ContentItem

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]){
        _contentGuid = [dictionary objectForKey:@"contentGuid"];
        _contentTitle = [dictionary objectForKey:@"contentTitle"];
    }
    return self;
}
@end
