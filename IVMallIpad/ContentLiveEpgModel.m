//
//  ContentLiveEpgModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ContentLiveEpgModel.h"
#import "Macro.h"

@implementation EpgModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        _title = [dictionary objectForKey:@"title"];
        _description = [dictionary objectForKey:@"description"];
        _epgStartTime = [dictionary objectForKey:@"epgStartTime"];
        _epgEndTime = [dictionary objectForKey:@"epgEndTime"];
        _allowCatchup = [[dictionary objectForKey:@"allowCatchup"]intValue];
        _playType = [dictionary objectForKey:@"playType"];
        
    }
    return self;
}
@end
@implementation EpgItemsModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {

        _epgDate = [dictionary objectForKey:@"epgDate"];
        NSArray* array = [dictionary objectForKey:@"items"];
        if (array) {
            _items = [[NSMutableArray alloc]init];
            for (NSDictionary*dic in array) {
                EpgModel* um = [[EpgModel alloc]initWithDictionary:dic];
                [_items addObject:um];
            }
        }


    }
    return self;
}
@end
@implementation ContentLiveEpgModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result == 0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            _contentGuid = [dictionary objectForKey:@"contentGuid"];
            _contentTitle = [data objectForKey:@"contentTitle"];
            _contentImg = [data objectForKey:@"contentImg"];
            _contentDescription = [data objectForKey:@"contentDescription"];
            _startTime = [data objectForKey:@"startTime"];
            _endTime = [data objectForKey:@"endTime"];
            _currentTime = [data objectForKey:@"currentTime"];
            NSArray* array = [data objectForKey:@"list"];
            if (array) {
                _list = [[NSMutableArray alloc]init];
                for (NSDictionary* childinfo in array) {
                    EpgItemsModel* um = [[EpgItemsModel alloc]initWithDictionary:childinfo];
                    [_list addObject:um];
                }
                
            }
        }
    }else{
        _result=-1;
    }
    return self;
}
@end
