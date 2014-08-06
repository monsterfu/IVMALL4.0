//
//  ChannelCategoryListMode.m
//  IVMallHD
//
//  Created by SMiT on 14-7-4.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ChannelCategoryListMode.h"


@implementation CategoryMode

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _categoryId = [dictionary objectForKey:@"categoryId"];
        _categoryName = [dictionary objectForKey:@"categoryName"];
        _categoryDescription = [dictionary objectForKey:@"categoryDescription"];
        _categoryImg = [dictionary objectForKey:@"categoryImg"];
        _categroyFrom = [dictionary objectForKey:@"categroyFrom"];
    }
    
    return self;
}

@end
@implementation ChannelCategoryListMode

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _errorCode = [[dictionary objectForKey:@"errorCode"]intValue];
        _errorMessage = [dictionary objectForKey:@"errorMessage"];
        if (_errorCode == 0) {
            NSDictionary* data = [dictionary objectForKey:@"data"];
            if (data) {
                _pages = [[data objectForKey:@"pages"]intValue];
                _counts = [[data objectForKey:@"counts"]intValue];
                _selectedCategoryId = [[data objectForKey:@"selectedCategoryId"]intValue];
                NSArray* list = [data objectForKey:@"list"];
                if (list) {
                    _list = [[NSMutableArray alloc]init];
                    for (NSDictionary*  dic in list) {
                        CategoryMode* um = [[CategoryMode alloc]initWithDictionary:dic];
                        [_list addObject:um];
                    }

                }
            }
        }
    }
    return self;
}

@end
