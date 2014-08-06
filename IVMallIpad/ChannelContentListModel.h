//
//  ChannelContentListModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelContentListModel : NSObject//频道内容列表
@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* contentGuid;       //	内容ID
@property(nonatomic,strong)NSString* contentTitle;      //	内容名称
@property(nonatomic,strong)NSString* contentImg;        //	内容图片
@property(nonatomic,strong)NSString* contentDescription;//	内容简介
@property(nonatomic,assign)long playCount;
@property(nonatomic,assign)long favoriteCount;
@property(nonatomic,assign)int isCollect;
@property(nonatomic,strong)NSString* publishDate;

- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray*)mList page:(int)page;
@end
