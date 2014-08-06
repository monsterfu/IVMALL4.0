//
//  IndexAllInfo.h
//  IVMall (Ipad)
//
//  Created by sean on 14-3-4.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexAllInfo : NSObject

@property(nonatomic,assign)int errorCode;

- (id)initWithDictionary:(NSDictionary *)dictionary adArray:(NSMutableArray*)adList  channelsArray:(NSMutableArray*)channelList;



@end
