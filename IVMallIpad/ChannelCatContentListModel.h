//
//  ChannelCatContentListModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelCatContentListModel : NSObject//频道猫全部内容列表

@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* contentGuid;       //	内容ID
@property(nonatomic,strong)NSString* contentTitle;      //	内容名称
@property(nonatomic,strong)NSString* contentDescription;//	内容简介
@property(nonatomic,strong)NSString* contentType;       //	内容类型
@property(nonatomic,strong)NSString* contentImg;        //	内容图片
@property(nonatomic,strong)NSString* contentFrom;       //	内容来源
@property(nonatomic,assign)int isEpisode;               //  是否剧集

@property(nonatomic,assign)int counts;  //总共页数
@property(nonatomic,assign)int allCoun;

@property(nonatomic,assign)int episodeCount;
@property(nonatomic,assign)int episodeLast;
@property(nonatomic,assign)int roundCount;
@property(nonatomic,assign)int roundLast;
@property(nonatomic,strong)NSString* liveSubhead;
@property(nonatomic,assign)double playCount;
@property(nonatomic,assign)int favoriteCount;
@property(nonatomic,assign)int isCollect;
@property(nonatomic,strong)NSString* langs;       //支持的语言

@property(nonatomic,assign)int modelTag;

- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray*)mList page:(int)page;
@end
