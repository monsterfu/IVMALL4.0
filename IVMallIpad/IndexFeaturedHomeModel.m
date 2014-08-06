//
//  IndexFeaturedHomeModel.m
//  IVMall
//
//  Created by SMiT on 14-3-20.
//  Copyright (c) 2014年 www.smit.com.cn. All rights reserved.
//

#import "IndexFeaturedHomeModel.h"

@implementation adModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _adType = [dictionary objectForKey:@"adType"];
        _adGuid = [dictionary objectForKey:@"adGuid"];
        _adTitle = [dictionary objectForKey:@"adTitle"];
        _adImg = [dictionary objectForKey:@"adImg"];
        _adAnchor = [dictionary objectForKey:@"adAnchor"];
    }
    return self;

}
@end

@implementation contentModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _contentGuid = [dictionary objectForKey:@"contentGuid"];
        _contentTitle = [dictionary objectForKey:@"contentTitle"];
        _contentDescription = [dictionary objectForKey:@"contentDescription"];
        _contentImg = [dictionary objectForKey:@"contentImg"];
        _contentType = [dictionary objectForKey:@"contentType"];
        _isEpisode = [[dictionary objectForKey:@"isEpisode"]intValue];
        _episodeCount = [[dictionary objectForKey:@"episodeCount"]intValue];
        _liveSubhead = [dictionary objectForKey:@"liveSubhead"];
        _isCollect = [[dictionary objectForKey:@"isCollect"]intValue];
    }
    return self;
}
@end

@implementation IndexFeaturedHomeModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode==0)
        {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            NSArray* adsarray = [data objectForKey:@"ads"];
            if(adsarray){
                _ads = [[NSMutableArray alloc]init];
                for (NSDictionary *childinfo in adsarray) {
                    adModel *um = [[adModel alloc]initWithDictionary:childinfo];
                    
                    NSLog(@"childinfo=%@",childinfo);
                    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                    NSString* copyright=[userDefaultes objectForKey:@"copyright_Ivmall"];
                    
                    if (![um.adType isEqualToString:@"content"] )
                    {
                        if ( copyright && [copyright isEqualToString:@"true"] )
                        {
                            [_ads addObject:um];
                        }
                    }else{
                        [_ads addObject:um];
                    }

                    
                }
            }
            
            NSArray* channels = [data objectForKey:@"channels"];
            if (channels) {
                for (int i=0; i<channels.count; i++) {
                    NSDictionary* channel = [channels objectAtIndex:i];
                    NSString* channelCode = [channel objectForKey:@"channelCode"];
                    if ([channelCode isEqualToString:@"fashion"]) {
                        NSArray* items = [channel objectForKey:@"items"];
                        if (items) {
                            _fashionList = [[NSMutableArray alloc]init];
                            for (NSDictionary *childinfo in items) {
                                contentModel *um = [[contentModel alloc]initWithDictionary:childinfo];
                                [_fashionList addObject:um];
                            }
                        }
                        
                    }else if ([channelCode isEqualToString:@"sports"]) {
                        NSArray* items = [channel objectForKey:@"items"];
                        if (items) {
                            _sportsList = [[NSMutableArray alloc]init];
                            for (NSDictionary *childinfo in items) {
                                contentModel *um = [[contentModel alloc]initWithDictionary:childinfo];
                                [_sportsList addObject:um];
                            }
                        }
                        
                    }else if ([channelCode isEqualToString:@"children"]) {
                        NSArray* items = [channel objectForKey:@"items"];
                        if (items) {
                            _childrenList = [[NSMutableArray alloc]init];
                            for (NSDictionary *childinfo in items) {
                                contentModel *um = [[contentModel alloc]initWithDictionary:childinfo];
                                [_childrenList addObject:um];
                            }
                        }
                        
                    }else if ([channelCode isEqualToString:@"city"]) {
                        NSArray* items = [channel objectForKey:@"items"];
                        if (items) {
                            _cityList = [[NSMutableArray alloc]init];
                            for (NSDictionary *childinfo in items) {
                                contentModel *um = [[contentModel alloc]initWithDictionary:childinfo];
                                [_cityList addObject:um];
                            }
                        }
                        
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
