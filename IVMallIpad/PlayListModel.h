//
//  PlayListModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentMode : NSObject
@property(nonatomic,strong)NSString* playID;
@property(nonatomic,strong)NSString* contentGuid;       //	内容ID
@property(nonatomic,strong)NSString* contentTitle;      //	内容名称
@property(nonatomic,strong)NSString* contentImg;        //	内容图片
@property(nonatomic,strong)NSString* createTime;        //	添加时间
@property(nonatomic,strong)NSString* dueTime;           //  过期时间
- (id)initWithDictionary:(NSDictionary*)dictionary;
@end
@interface PlayListModel : NSObject//播放记录列表
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,assign)int pages;
@property(nonatomic,assign)int counts;
@property(nonatomic,strong)NSMutableArray* list;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
