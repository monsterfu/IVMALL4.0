//
//  AdMOdel.h
//  IVMall (Ipad)
//
//  Created by sean on 14-3-4.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdMOdel : NSObject

@property(nonatomic,strong)NSString* channelCode;

@property(nonatomic,strong)NSString* adType;
@property(nonatomic,strong)NSString* adGuid;
@property(nonatomic,strong)NSString* adTitle;
@property(nonatomic,strong)NSString* adImg;
@property(nonatomic,strong)NSString*tmpSting;

- (id)initWithDictionary:(NSDictionary *)dictionary adArray:(NSMutableArray*)adList;

@end
