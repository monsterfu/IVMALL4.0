//
//  ChannelCatContentListMode.h
//  IVMallHD
//
//  Created by SMiT on 14-7-11.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CatContentMode : NSObject
@property (nonatomic,strong) NSString* contentGuid;
@property (nonatomic,strong) NSString* contentTitle;
@property (nonatomic,strong) NSString* contentDescription;
@property (nonatomic,strong) NSString* contentType;
@property (nonatomic,strong) NSString* contentImg;
@property (nonatomic,strong) NSString* contentFrom;
@property (nonatomic,assign) int isEpisode;
@property (nonatomic,assign) int episodeCount;
@property (nonatomic,assign) int playCount;
@property (nonatomic,assign) int favoriteCount;
@property (nonatomic,assign) int isCollect;
@property (nonatomic,strong) NSString* langs;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface ChannelCatContentListMode : NSObject
@property (nonatomic,assign) int errorCode;
@property (nonatomic,strong) NSString* errorMessage;
@property (nonatomic,assign) int counts;
- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray*)mList startIndex:(int)startIndex;
@end
