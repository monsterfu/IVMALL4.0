//
//  EPGInfoModel.h
//  IVMall (Ipad)
//
//  Created by sean on 14-3-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPGInfoModel : NSObject

@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* contentGuid;
@property(nonatomic,strong)NSString* contentTitle;
@property(nonatomic,strong)NSString* contentDescription;
@property(nonatomic,strong)NSString* contentImg;
@property(nonatomic,strong)NSString* startTime;
@property(nonatomic,strong)NSString* endTime;
@property(nonatomic,strong)NSString* currentTime;


@property(nonatomic,copy)NSString* epgDate;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* description;
@property(nonatomic,copy)NSString* epgStartTime;
@property(nonatomic,copy)NSString* epgEndTime;
@property(nonatomic,copy)NSString* allowCatchup;
@property(nonatomic,copy)NSString* playType;

@property(nonatomic,copy)NSString* tmpString;

- (id)initWithDictionary:(NSDictionary *)dictionary allDic:(NSMutableDictionary*)mydic;


@end
