//
//  ChannelsModel.h
//  IVMall (Ipad)
//
//  Created by sean on 14-3-4.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelsModel : NSObject

@property(nonatomic,strong)NSString* channelCode;
@property(nonatomic,strong)NSString* channelType;
@property(nonatomic,strong)NSString* channelName;
@property(nonatomic,strong)NSString* channelImg;
@property(nonatomic,strong)NSString* copyright;

- (id)initWithDictionary:(NSDictionary *)dictionary channArray:(NSMutableArray*)channList;

@end
