//
//  ChannelContentListModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ChannelContentListModel.h"

@implementation ChannelContentListModel
- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result==0) {
            NSArray *array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"]objectForKey:@"list"]];
            if(array){
                
                if (page==1) {
                    [mList removeAllObjects];
                }
                for (NSDictionary *childinfo in array) {
                    ChannelContentListModel *um=[[ChannelContentListModel alloc]initWithDictionaryEx:childinfo];
                    [mList addObject:um];
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
        _contentImg = [dictionary objectForKey:@"contentImg"];
        _playCount = [[dictionary objectForKey:@"playCount"]intValue];
        _favoriteCount = [[dictionary objectForKey:@"favoriteCount"]intValue];
        _isCollect = [[dictionary objectForKey:@"isCollect"]intValue];
        _result = 0;
    }else{
        _result = -1;
    }
    return self;
}

@end
