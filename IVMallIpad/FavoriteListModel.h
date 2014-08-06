//
//  FavoriteListModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteListModel : NSObject//收藏列表

@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* favID;
@property(nonatomic,strong)NSString* contentGuid;       //	内容ID
@property(nonatomic,strong)NSString* contentTitle;      //	内容名称
@property(nonatomic,strong)NSString* contentImg;        //	内容图片
@property(nonatomic,strong)NSString* collectTime;       //	收藏时间	
@property(nonatomic,strong)NSString* lang;
@property(nonatomic,strong)NSString* isEpisode;
@property(nonatomic,strong)NSString* contentType;
@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic,assign)int pages;
@property (nonatomic,assign) int counts;

- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray*)mList page:(int)page;
@end
