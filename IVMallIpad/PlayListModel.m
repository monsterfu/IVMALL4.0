//
//  PlayListModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PlayListModel.h"

@implementation ContentMode
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]){
        _playID = [dictionary objectForKey:@"id"];
        _contentGuid = [dictionary objectForKey:@"contentGuid"];
        _contentTitle = [dictionary objectForKey:@"contentTitle"];
        _contentImg = [dictionary objectForKey:@"contentImg"];
        _createTime = [dictionary objectForKey:@"createTime"];
        _dueTime = [dictionary objectForKey:@"dueTime"];
    }
    return self;
}

@end

@implementation PlayListModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _errorCode=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode==0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _pages = [[data objectForKey:@"pages"]intValue];
                _counts = [[data objectForKey:@"counts"]intValue];
                NSArray *array = [data objectForKey:@"list"];
                if(array){
                    _list = [[NSMutableArray alloc]init];

                    for (NSDictionary *childinfo in array) {
                        ContentMode *um = [[ContentMode alloc]initWithDictionary:childinfo];
                        [_list addObject:um];
                    }
                }
            }
 
        }
    }else{
        _errorCode = -1;
    }
    return self;
}


@end
