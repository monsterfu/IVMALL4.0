//
//  AppPointsModel.m
//  IVMall
//
//  Created by SMiT on 14-4-21.
//  Copyright (c) 2014年 www.smit.com.cn. All rights reserved.
//

#import "AppPointsModel.h"

@implementation AppPointModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _points = [[dictionary objectForKey:@"points"]doubleValue];
        _price = [[dictionary objectForKey:@"price"]doubleValue];
    }
    return self;
}
@end

@implementation AppPointsModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
            NSArray* list = [[dictionary objectForKey:@"data"]objectForKey:@"list"];
            if (list) {
                _list = [[NSMutableArray alloc]init];
                for (NSDictionary*dic in list) {
                    AppPointModel* um = [[AppPointModel alloc]initWithDictionary:dic];
                    [_list addObject:um];
                }
                
                //增加自定义LIST
                NSDictionary* customerPiceDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"points",@"0",@"price", nil];
                AppPointModel* um = [[AppPointModel alloc]initWithDictionary:customerPiceDic];
                [_list addObject:um];
            }
        }
    }
    return self;
}
@end
