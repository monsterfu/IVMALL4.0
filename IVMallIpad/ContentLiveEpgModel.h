//
//  ContentLiveEpgModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface EpgModel : NSObject
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* description;
@property(nonatomic,strong)NSString* epgStartTime;
@property(nonatomic,strong)NSString* epgEndTime;
@property(nonatomic,assign)int allowCatchup;
@property(nonatomic,strong)NSString* playType;
@end

@interface EpgItemsModel : NSObject
@property(nonatomic,strong)NSString* epgDate;
@property(nonatomic,strong)NSMutableArray* items;
@end

@interface ContentLiveEpgModel : NSObject//Live EPG 列表
@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* contentGuid;
@property(nonatomic,strong)NSString* contentTitle;
@property(nonatomic,strong)NSString* contentImg;
@property(nonatomic,strong)NSString* contentDescription;
@property(nonatomic,strong)NSString* startTime;
@property(nonatomic,strong)NSString* endTime;
@property(nonatomic,strong)NSString* currentTime;
@property(nonatomic,strong)NSMutableArray* list;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
