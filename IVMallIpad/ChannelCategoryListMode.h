//
//  ChannelCategoryListMode.h
//  IVMallHD
//
//  Created by SMiT on 14-7-4.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryMode : NSObject
@property (nonatomic,strong) NSString* categoryId;
@property (nonatomic,strong) NSString* categoryName;
@property (nonatomic,strong) NSString* categoryDescription;
@property (nonatomic,strong) NSString* categoryImg;
@property (nonatomic,strong) NSString* categroyFrom;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface ChannelCategoryListMode : NSObject
@property (nonatomic,assign) int errorCode;
@property (nonatomic,strong) NSString* errorMessage;
@property (nonatomic,assign) int pages;
@property (nonatomic,assign) int counts;
@property (nonatomic,assign) int selectedCategoryId;
@property (nonatomic,strong) NSMutableArray* list;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
