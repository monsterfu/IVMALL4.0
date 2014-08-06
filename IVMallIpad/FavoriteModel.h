//
//  FavoriteModel.h
//  IVMall
//
//  Created by fangfang on 13-11-21.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteModel : NSObject
{
    int result;
    NSString* productId;//	产品ID	String
    NSString* productTitle;//	产品名称	String
    NSString* productImg;//	产品图片	String
    NSString* collectTime;//	收藏时间	String
    BOOL isSelect;
}
@property (nonatomic,assign) int result;
@property (nonatomic,strong) NSString* productId;//	产品ID	String
@property (nonatomic,strong) NSString* productTitle;//	产品名称	String
@property (nonatomic,strong) NSString* productImg;//	产品图片	String
@property (nonatomic,strong) NSString* collectTime;//	收藏时间	String
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,strong) NSString* favID;
@property (nonatomic,strong) NSString* lang;


@property (nonatomic,copy)NSString* contentDesc;//视频专用

- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray*)mList page:(int)page;
- (id)initWithDictionaryEx:(NSDictionary *)dictionary;

@end
