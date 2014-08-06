//
//  EPGInfoModel.m
//  IVMall (Ipad)
//
//  Created by sean on 14-3-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "EPGInfoModel.h"

@implementation EPGInfoModel


- (id)initWithDictionary:(NSDictionary *)dictionary allDic:(NSMutableDictionary*)mydic{
    if (self=[super init]) {
        _errorCode=[[dictionary objectForKey:@"errorCode"]intValue];
        
        if (_errorCode==0) {
            
            NSDictionary*dic=[dictionary objectForKey:@"data"];
            
            _contentGuid=[dic objectForKey:@"contentGuid"];
            _contentTitle=[dic objectForKey:@"contentTitle"];
            _contentDescription=[dic objectForKey:@"contentDescription"];
            _contentImg=[dic objectForKey:@"contentImg"];
            _startTime=[dic objectForKey:@"startTime"];
            _endTime=[dic objectForKey:@"endTime"];
            _currentTime=[dic objectForKey:@"currentTime"];
            
            NSArray*arr=[dic objectForKey:@"list"];
            int i=0;
            NSMutableArray*date=[[NSMutableArray alloc]init];
            for (NSDictionary*dic2 in arr) {
                _epgDate=[dic2 objectForKey:@"epgDate"];
//                NSRange rang=[_epgDate rangeOfString:@"T"];
                NSString* str=[_epgDate substringWithRange:NSMakeRange(5, 5)];
                [date addObject:str];
                
                NSArray*arr2=[dic2 objectForKey:@"items"];
                NSMutableArray*epgarr=[[NSMutableArray alloc]init];
                for (NSDictionary*dic3 in arr2) {
                    EPGInfoModel*epg=[[EPGInfoModel alloc]initWithDictionary2:dic3];
                    [epgarr addObject:epg];
                }
                [mydic setObject:epgarr forKey:[NSString stringWithFormat:@"epg_%i",i]];
                i++;
            }
            [mydic setObject:date forKey:@"epg_dateArray"];
        }
        
        
        
        
    }
    return self;
}



-(id)initWithDictionary2:(NSDictionary *)dictionary{
    if (self=[super init]) {
        _title=[dictionary objectForKey:@"title"];
        _description=[dictionary objectForKey:@"description"];
        _epgStartTime=[dictionary objectForKey:@"epgStartTime"];
        _epgEndTime =[dictionary objectForKey:@"epgEndTime"];
        _allowCatchup=[dictionary objectForKey:@"allowCatchup"];
        _playType=[dictionary objectForKey:@"playType"];
    }
    return self;
}


@end








