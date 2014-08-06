//
//  BuyListModel.h
//  IVMall
//
//  Created by fangfang on 13-11-22.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyListModel : NSObject{
    int result;
    NSString* productId;//	产品ID	String
    NSString* productTitle;//	产品名称	String
    NSString* productImg;//	产品图片	String
    float points;//	点数	long
    NSString*   buyTime;//	购买时间	String
    NSString* dueTime;//	到期时间	String
    BOOL isDue;
}
@property (nonatomic,assign) int result;
@property(nonatomic,strong)NSString* errorMessage;
@property (nonatomic,strong) NSString* productId;//	产品ID	String
@property (nonatomic,strong) NSString* productTitle;//	产品名称	String
@property (nonatomic,strong) NSString* productImg;//	产品图片	String
@property (nonatomic,assign) float points;
@property (nonatomic,strong) NSString* buyTime;//	购买时间	String
@property (nonatomic,strong) NSString* dueTime;//	到期时间	String
@property (nonatomic,assign) BOOL isDue;

@property(nonatomic,strong)NSString *productFrom;
@property(nonatomic,assign)int contentCount;
@property(nonatomic,strong)NSString* productDescription;

- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page;
- (id)initWithDictionaryEx:(NSDictionary *)dictionary;
- (id)initWithVipDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page;
- (id)initWithVipListDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray *)mList page:(int)page;

@end
