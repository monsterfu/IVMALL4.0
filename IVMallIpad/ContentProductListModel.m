//
//  ContentProductListModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ContentProductListModel.h"

@implementation ProductModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        _productGuid = [dictionary objectForKey:@"productGuid"];
        _productTitle = [dictionary objectForKey:@"productTitle"];
        _productDescription = [dictionary objectForKey:@"productDescription"];
        _productImg = [dictionary objectForKey:@"productImg"];
        _points = [[dictionary objectForKey:@"points"]doubleValue];
        _buyPoints = [[dictionary objectForKey:@"buyPoints"]doubleValue];
        _contentCount = [[dictionary objectForKey:@"contentCount"]intValue];
        _isBuy = [[dictionary objectForKey:@"isBuy"]intValue];
        _productFrom = [dictionary objectForKey:@"productFrom"];
    }
    return self;
}
@end

@implementation VipModel
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        _vipGuid = [dictionary objectForKey:@"vipGuid"];
        _vipTitle = [dictionary objectForKey:@"vipTitle"];
        _vipImg = [dictionary objectForKey:@"vipImg"];
        _vipDescription = [dictionary objectForKey:@"vipDescription"];
        _points = [[dictionary objectForKey:@"points"]doubleValue];
        NSString* temp = [dictionary objectForKey:@"trial"];
        if (temp && [temp isEqualToString:@"true"]) {
            _trial = YES;
        }else{
            _trial = NO;
        }
    }
    return self;
}
@end

@implementation ContentProductListModel
- (id)initWithDictionary:(NSDictionary *)dictionary andVipArr:(NSMutableArray*)vipArr :(NSMutableArray *)ContentArr{
    if (self = [super init])
    {
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result == 0) {
            NSArray* array1 = [[dictionary objectForKey:@"data"]objectForKey:@"list"];
            if (array1) {
                for (NSDictionary* childinfo in array1) {
                    ProductModel *um = [[ProductModel alloc]initWithDictionary:childinfo];
                    [ContentArr addObject:um];
                }
                
            }
            NSArray* array2 = [[dictionary objectForKey:@"data"]objectForKey:@"vipList"];
            
            if (array2) {
                for (NSDictionary* childinfo in array2) {
                    VipModel *um = [[VipModel alloc]initWithDictionary:childinfo];
                    [vipArr addObject:um];
                }
            }
        }
    }else{
        _result=-1;
    }
    return self;

}
@end
