//
//  AdListModel.m
//  IVMallHD
//
//  Created by  周传森 on 14-5-19.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "AdListModel.h"

@implementation AdListModel
-(id)initWithDictionary:(NSDictionary *)dictionary withArr:(NSMutableArray *)adListArr
{
    if (self = [super init])
    {
        _result=[[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_result==0) {
            NSArray*arr=[[dictionary objectForKey:@"data"] objectForKey:@"ads"];
            for (NSDictionary*dic in arr) {
                AdListModel*ad=[[AdListModel alloc]initWithDictionary:dic];
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                NSString* copyright=[userDefaultes objectForKey:@"copyright_Ivmall"];
                
                if (![ad.adType isEqualToString:@"content"] ) {
                    if ( copyright && [copyright isEqualToString:@"true"] ) {
                        [adListArr addObject:ad];
                    }
                }else{
                    [adListArr addObject:ad];
                }
            }
        }
    }else{
        _result=-1;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]){
        _adType= [dictionary objectForKey:@"adType"];
        _adGuid= [dictionary objectForKey:@"adGuid"];
        _adTitle= [dictionary objectForKey:@"adTitle"];
        _adImg= [dictionary objectForKey:@"adImg"];
        _adAnchor = [dictionary objectForKey:@"adAnchor"];
    }
    return self;
}

@end
