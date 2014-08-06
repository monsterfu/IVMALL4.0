//
//  BuyListModel.m
//  IVMall
//
//  Created by fangfang on 13-11-22.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import "BuyListModel.h"
#import "Commonality.h"
#import "Macro.h"

@implementation BuyListModel
@synthesize result;
@synthesize productId;//	产品ID	String
@synthesize productTitle;//	产品名称	String
@synthesize productImg;//	产品图片	String
@synthesize points;//	点数	long
@synthesize buyTime;
@synthesize dueTime;
@synthesize isDue;

-(id)initWithVipListDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (result==0) {
            NSArray *array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"]objectForKey:@"list"]];
            if(array){
                if (page==1) {
                    [mList removeAllObjects];
                }
                for (NSDictionary *childinfo in array) {
                    BuyListModel *um=[[BuyListModel alloc]initWithVipDictionaryEx:childinfo];
                    [mList addObject:um];
                }
            }
        }
    }else{
        result=-1;
    }
    return self;
    
}

-(id)initWithVipDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (result==0) {
            NSArray *array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"]objectForKey:@"vipList"]];
            if(array){
                if (page==1) {
                    [mList removeAllObjects];
                }
                for (NSDictionary *childinfo in array) {
                    BuyListModel *um=[[BuyListModel alloc]initWithVipDictionaryEx:childinfo];
                    [mList addObject:um];
                }
            }
        }
    }else{
        result=-1;
    }
    return self;
    
}

- (id)initWithVipDictionaryEx:(NSDictionary *)dictionary{
    if (self = [super init])
    {
        isDue=NO;
        NSLog(@"json=%@",dictionary);
        result=0;
        productId=[[dictionary objectForKey:@"vipGuid"]copy];
        productTitle=[[dictionary objectForKey:@"vipTitle"]copy];
        productImg=[[dictionary objectForKey:@"vipImg"]copy];
        points=[[dictionary objectForKey:@"points"]floatValue];
        buyTime=[[dictionary objectForKey:@"buyTime"]copy];
        dueTime=[[dictionary objectForKey:@"dueTime"]copy];
        _productFrom=[[dictionary objectForKey:@"productFrom"]copy];
        _contentCount=[[dictionary objectForKey:@"contentCount"]intValue];
        _productDescription=[[dictionary objectForKey:@"vipDescription"]copy];
        
        int dateFlag=[Commonality judgeDate:dueTime withday:[Commonality SystemDate2Str]];
        if (dateFlag==-1) {
            isDue=YES;
        }
    }else{
        result=-1;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (result==0) {
            NSArray *array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"]objectForKey:@"list"]];
            if(array){
                if (page==1) {
                    [mList removeAllObjects];
                }
                for (NSDictionary *childinfo in array) {
                    BuyListModel *um=[[BuyListModel alloc]initWithDictionaryEx:childinfo];
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
    if (self = [super init])
    {
        isDue=NO;
        NSLog(@"json=%@",dictionary);
        result=0;
        productId=[dictionary objectForKey:@"productGuid"];
        productTitle=[dictionary objectForKey:@"productTitle"];
        productImg=[dictionary objectForKey:@"productImg"];
        points=[[dictionary objectForKey:@"points"]floatValue];
        buyTime=[dictionary objectForKey:@"buyTime"];
        dueTime=[dictionary objectForKey:@"dueTime"];
        _productFrom=[dictionary objectForKey:@"productFrom"];
        _contentCount=[[dictionary objectForKey:@"contentCount"]intValue];
        _productDescription=[dictionary objectForKey:@"productDescription"];
        
        int dateFlag=[Commonality judgeDate:dueTime withday:[Commonality SystemDate2Str]];
        if (dateFlag==-1) {
            isDue=YES;
        }
    }else{
        result=-1;
    }
    return self;
}


@end
