//
//  IndexFeaturedHomeModel.h
//  IVMall
//
//  Created by SMiT on 14-3-20.
//  Copyright (c) 2014年 www.smit.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface adModel : NSObject
@property(nonatomic,strong)NSString* adType;
@property(nonatomic,strong)NSString* adGuid;
@property(nonatomic,strong)NSString* adTitle;
@property(nonatomic,strong)NSString* adImg;
@property(nonatomic,strong)NSString* adAnchor;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface contentModel : NSObject
@property(nonatomic,strong)NSString* contentGuid;
@property(nonatomic,strong)NSString* contentTitle;
@property(nonatomic,strong)NSString* contentDescription;
@property(nonatomic,strong)NSString* contentImg;
@property(nonatomic,strong)NSString* contentType;
@property(nonatomic,assign)int isEpisode;
@property(nonatomic,assign)int episodeCount;
@property(nonatomic,strong)NSString* liveSubhead;
@property(nonatomic,assign)int isCollect;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface IndexFeaturedHomeModel : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSMutableArray* ads;
@property(nonatomic,strong)NSMutableArray* childrenList;
@property(nonatomic,strong)NSMutableArray* sportsList;
@property(nonatomic,strong)NSMutableArray* fashionList;
@property(nonatomic,strong)NSMutableArray* cityList;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
