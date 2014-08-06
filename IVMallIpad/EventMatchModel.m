//
//  EventMatchModel.m
//  IVMall (Ipad)
//
//  Created by sean on 14-3-10.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "EventMatchModel.h"

@implementation EventMatchModel

- (id)initWithDictionary:(NSDictionary *)dictionary EvenArray:(NSMutableArray*)evenList{
    if (self=[super init]) {
        _errorCode=[[dictionary objectForKey:@"errorCode"]intValue];
        if (_errorCode==0) {
            NSDictionary*dic=[dictionary objectForKey:@"data"];
            _startTime=[dic objectForKey:@"startTime"];
            _endTime=[dic objectForKey:@"endTime"];
            _currentTime=[dic objectForKey:@"currentTime"];
            _currentRound=[[dic objectForKey:@"currentRound"]intValue];
            _totalRounds=[[dic objectForKey:@"totalRounds"]intValue];
            NSArray*arr=[dic objectForKey:@"list"];
            for (NSDictionary*dic2 in arr) {
                EventMatchModel*even=[[EventMatchModel alloc]initWithDictionary2:dic2];
                [evenList addObject:even];
            }
            
            
        }
        
        
        
    }
    return self;

}

-(id)initWithDictionary2:(NSDictionary *)dictionary{
    if (self=[super init]) {
        
        _kickStartTime=[dictionary objectForKey:@"kickStartTime"];
        _endTime=[dictionary objectForKey:@"kickEndTime"];
        _contentGuid=[dictionary objectForKey:@"contentGuid"];
        _matchTitle=[dictionary objectForKey:@"matchTitle"];
        _matchStatus=[[dictionary objectForKey:@"matchStatus"]intValue];
        _roundNumber=[[dictionary objectForKey:@"roundNumber"]intValue];
        
        _team1Name=[dictionary objectForKey:@"team1Name"];
        _team1Img=[dictionary objectForKey:@"team1Img"];
        _team1Score=[[dictionary objectForKey:@"team1Score"]intValue];
        
        _team2Name=[dictionary objectForKey:@"team2Name"];
        _team2Img=[dictionary objectForKey:@"team2Img"];
        _team2Score=[[dictionary objectForKey:@"team2Score"]intValue];
        _playType=[dictionary objectForKey:@"playType"];
        _isCollect=[[dictionary objectForKey:@"isCollect"]intValue];
        
    }
    return self;
}

@end
