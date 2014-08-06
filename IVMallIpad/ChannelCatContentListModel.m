//
//  ChannelCatContentListModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ChannelCatContentListModel.h"

@implementation ChannelCatContentListModel
- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString* copyright=[userDefaultes objectForKey:@"copyright_Ivmall"];
        if (_result==0) {
            NSArray *array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"]objectForKey:@"list"]];
            _counts=[[[dictionary objectForKey:@"data"]objectForKey:@"pages"]intValue];
            _allCoun=[[[dictionary objectForKey:@"data"]objectForKey:@"counts"]intValue];
            if(array){
                if (page==1) {
                    [mList removeAllObjects];
                }
                for (NSDictionary *childinfo in array) {
                    ChannelCatContentListModel *um=[[ChannelCatContentListModel alloc]initWithDictionaryEx:childinfo];
                    
                    
                    if ( copyright && [copyright isEqualToString:@"true"] ) {
                        [mList addObject:um];
                    }
                    else
                    {
                        if ([um.contentTitle rangeOfString:@"迪斯尼"].location == NSNotFound) {
                            [mList addObject:um];
                        }
                    }
                
                    

                }
            }
        }
    }else{
        _result=-1;
    }
    return self;
}

- (id)initWithDictionaryEx:(NSDictionary *)dictionary{
    if (self = [super init]){
        _contentGuid = [dictionary objectForKey:@"contentGuid"];
        _contentTitle = [dictionary objectForKey:@"contentTitle"];
        _contentDescription = [dictionary objectForKey:@"contentDescription"];
        _contentType = [dictionary objectForKey:@"contentType"];
        _contentImg = [dictionary objectForKey:@"contentImg"];
        _contentFrom = [dictionary objectForKey:@"contentFrom"];
        _isEpisode = [[dictionary objectForKey:@"isEpisode"]intValue];
        _episodeCount = [[dictionary objectForKey:@"episodeCount"]intValue];
        _episodeLast = [[dictionary objectForKey:@"episodeLast"]intValue];
        _roundCount = [[dictionary objectForKey:@"roundCount"]intValue];
        _roundLast = [[dictionary objectForKey:@"roundLast"]intValue];
        _liveSubhead = [dictionary objectForKey:@"liveSubhead"];
        _playCount = [[dictionary objectForKey:@"playCount"]doubleValue];
        _favoriteCount = [[dictionary objectForKey:@"favoriteCount"]intValue];
        _isCollect = [[dictionary objectForKey:@"isCollect"]intValue];
        _langs = [dictionary objectForKey:@"langs"];
        _result = 0;
    }else{
        _result = -1;
    }
    return self;
}
@end
