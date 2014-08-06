//
//  ContentEpisodeItemListModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface ContentEpisodeItemListModel : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,assign)int pages;
@property(nonatomic,assign)int counts;
@property(nonatomic,strong)NSString* episodeGuid;
@property(nonatomic,strong)NSString* episodeTitle;
@property(nonatomic,strong)NSString* episodeImg;
@property(nonatomic,strong)NSString* episodeDescription;
@property(nonatomic,assign)int episodeCount;
@property(nonatomic,assign)int episodeLast;
@property(nonatomic,assign)int playCount;
@property(nonatomic,assign)int favoriteCount;
@property(nonatomic,assign)int isCollect;
@property(nonatomic,strong)NSMutableArray* list;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface ContentItem : NSObject
@property(nonatomic,strong)NSString* contentGuid;
@property(nonatomic,strong)NSString* contentTitle;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
