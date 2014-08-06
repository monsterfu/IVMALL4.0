//
//  PayListModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PayListModel.h"

@implementation PayListModel
- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result==0) {
            NSArray *array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"]objectForKey:@"list"]];
            if(array){
                
                if (page==1) {
                    [mList removeAllObjects];
                }
                for (NSDictionary *childinfo in array) {
                    PayListModel *um=[[PayListModel alloc]initWithDictionaryEx:childinfo];
                    [mList addObject:um];
                }
            }
        }
    }else{
        _result=-1;
    }
    return self;
}

- (id)initWithDictionaryEx:(NSDictionary *)dictionary{
    if (self = [super init]){
        _points = [[dictionary objectForKey:@"points"]floatValue];
        _type = [dictionary objectForKey:@"type"];
        _createTime = [dictionary objectForKey:@"createTime"];
        _result = 0;
    }else{
        _result = -1;
    }
    return self;
}
@end
