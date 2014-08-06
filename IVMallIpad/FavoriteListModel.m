//
//  FavoriteListModel.m
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "FavoriteListModel.h"

@implementation FavoriteListModel
- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page{
    if (self = [super init])
    {
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result==0) {
            _pages = [[[dictionary objectForKey:@"data"] objectForKey:@"pages"] intValue];
            _counts = [[[dictionary objectForKey:@"data"]objectForKey:@"counts"] intValue];
            NSArray *array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"]objectForKey:@"list"]];
            if(array){
                if (page==1) {
                    [mList removeAllObjects];
                }
                NSMutableArray* tempArray = [[NSMutableArray alloc]init];
                for (NSDictionary *childinfo in array) {
                    FavoriteListModel *um=[[FavoriteListModel alloc]initWithDictionaryEx:childinfo];
                    [tempArray addObject:um];
                }
                if (page == 1) {
                    [mList addObjectsFromArray:tempArray];
                }else{
                    NSRange range = {(page-1)*8, tempArray.count};
                    if ((page - 1)*8+tempArray.count <= mList.count) {
                        [mList replaceObjectsInRange:range withObjectsFromArray:tempArray];
                    }
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
        _isSelect=NO;
        _favID = [dictionary objectForKey:@"id"];
        _lang = [dictionary objectForKey:@"lang"];
        _contentGuid = [dictionary objectForKey:@"contentGuid"];
        _contentTitle = [dictionary objectForKey:@"contentTitle"];
        _contentImg = [dictionary objectForKey:@"contentImg"];
        _collectTime = [dictionary objectForKey:@"collectTime"];
        _isEpisode = [dictionary objectForKey:@"isEpisode"] ;
        _contentType = [dictionary objectForKey:@"contentType"];
        _result = 0;
    }else{
        _result = -1;
    }
    return self;
}
@end
