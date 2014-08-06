//
//  ProductInfoModel.m
//  IVMall (Ipad)
//
//  Created by  周传森 on 14-3-12.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ProductInfoModel.h"

@implementation ProductInfoModel
- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result==0) {
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"data"]];
            
            
            if(dic){
                point = [[dic objectForKey:@"points"] floatValue];
                
                NSArray * arr = [dic objectForKey:@"contentList"];
                if (arr) {
                    if (page==1) {
                        [mList removeAllObjects];
                    }
                    for (NSDictionary *childinfo in arr) {
                        ProductInfoModel *um=[[ProductInfoModel alloc]initWithDictionaryEx:childinfo andPoint:point];
                        [mList addObject:um];
                    }
                }
                
                
                
            }
        }
    }else{
        _result=-1;
    }
    return self;
}

- (id)initWithDictionaryEx:(NSDictionary *)dictionary andPoint:(CGFloat)point1{
    if (self = [super init]){
//        _productGuid = [dictionary objectForKey:@"contentGuid"];
//        _productTitle = [dictionary objectForKey:@"contentTitle"];
//        _productDescription = [dictionary objectForKey:@"contentDescription"];
//        _productImg = [dictionary objectForKey:@"contentImg"];
//        _points = [NSString stringWithFormat:@"%0.2f",point1];
//        _playCount = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"playCount"]];
//        _favoriteCount = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"favoriteCount"]];
//        _isCollect = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"isCollect"]];
//        _result = 0;
        _productGuid = [dictionary objectForKey:@"contentGuid"];
        _productTitle = [dictionary objectForKey:@"contentTitle"];
        _productDescription = [dictionary objectForKey:@"contentDescription"];
        _productImg = [dictionary objectForKey:@"contentImg"];
        _points = [NSString stringWithFormat:@"%0.2f",point1];
        _playCount = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"playCount"]];
        _favoriteCount = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"favoriteCount"]];
        _isCollect = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"isCollect"]];
        _result = 0;
    }else{
        _result = -1;
    }
    return self;
}


@end
