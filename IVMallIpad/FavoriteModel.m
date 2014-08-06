//
//  FavoriteModel.m
//  IVMall
//
//  Created by fangfang on 13-11-21.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import "FavoriteModel.h"


@implementation FavoriteModel
@synthesize result;
@synthesize productId;//	产品ID	String
@synthesize productTitle;//	产品名称	String
@synthesize productImg;//	产品图片	String
@synthesize collectTime;//	收藏时间	String
@synthesize isSelect;

- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        result=[[dictionary objectForKey:@"errorCode"]intValue];
        if (result==0) {
            NSArray *array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"]objectForKey:@"list"]];
            if(array){
                
                if (page==1) {
                    [mList removeAllObjects];
                    
                }
                for (NSDictionary *childinfo in array) {
                    FavoriteModel *um=[[FavoriteModel alloc]initWithDictionaryEx:childinfo];
                    [mList addObject:um];
                }
            }
        }
    }else{
        result=-1;
    }
    return self;
}

- (id)initWithDictionaryEx:(NSDictionary *)dictionary{
    if (self = [super init]){
        isSelect=NO;
        result=0;
        productId=[dictionary objectForKey:@"contentGuid"];
        productTitle=[dictionary objectForKey:@"contentTitle"];
        productImg=[dictionary objectForKey:@"contentImg"];
        collectTime=[dictionary objectForKey:@"collectTime"];
        _favID=[dictionary objectForKey:@"id"];
        _lang=[dictionary objectForKey:@"lang"];
        _contentDesc=[dictionary objectForKey:@"contentDesc"];
        
    }else{
        result=-1;
    }
    return self;
}


@end
