//
//  PlayEpisodeListMode.h
//  IVMallHD
//
//  Created by SMiT on 14-8-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EpisodeMode : NSObject
@property (strong,nonatomic) NSString* contentGuid;
@property (strong,nonatomic) NSString* contentTitle;
@property (strong,nonatomic) NSString* contentImg;
@property (strong,nonatomic) NSString* contentDescription;
@property (assign,nonatomic) int playCount;
@property (assign,nonatomic) int episodeCount;
@property (strong,nonatomic) NSString* langs;
@property (strong,nonatomic) NSString* latestPlayTime;
@property (assign,nonatomic) int latestPlayEpisode;
@property (strong,nonatomic) NSString* latestPlayLang;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end


@interface PlayEpisodeListMode : NSObject
@property (assign,nonatomic) int errorCode;
@property (strong,nonatomic) NSString* errorMessage;
@property (assign,nonatomic) int pages;
@property (assign,nonatomic) int counts;
@property (strong,nonatomic) NSMutableArray* list;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
