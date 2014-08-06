//
//  EventMatchModel.h
//  IVMall (Ipad)
//
//  Created by sean on 14-3-10.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventMatchModel : NSObject

@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* startTime;
@property(nonatomic,strong)NSString* endTime;
@property(nonatomic,strong)NSString* currentTime;
@property(nonatomic,assign)int currentRound;
@property(nonatomic,assign)int totalRounds;


@property(nonatomic,strong)NSString* kickStartTime;
@property(nonatomic,strong)NSString* kickEndTime;
@property(nonatomic,strong)NSString* contentGuid;
@property(nonatomic,strong)NSString* matchTitle;
@property(nonatomic,assign)int matchStatus;
@property(nonatomic,assign)int roundNumber;
@property(nonatomic,strong)NSString* team1Name;
@property(nonatomic,strong)NSString* team1Img;
@property(nonatomic,assign)int team1Score;

@property(nonatomic,strong)NSString* team2Name;
@property(nonatomic,strong)NSString* team2Img;
@property(nonatomic,assign)int team2Score;


@property(nonatomic,strong)NSString* playType;
@property(nonatomic,assign)int isCollect;



- (id)initWithDictionary:(NSDictionary *)dictionary EvenArray:(NSMutableArray*)evenList;


@end
