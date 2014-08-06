//
//  ContentProductListModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ProductModel : NSObject
@property(nonatomic,strong)NSString* productGuid;
@property(nonatomic,strong)NSString* productTitle;
@property(nonatomic,strong)NSString* productDescription;
@property(nonatomic,strong)NSString* productImg;
@property(nonatomic,assign)double points;
@property(nonatomic,assign)double buyPoints;
@property(nonatomic,assign)int contentCount;
@property(nonatomic,assign)int isBuy;
@property(nonatomic,strong)NSString* productFrom;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface VipModel : NSObject
@property(nonatomic,strong)NSString* vipGuid;
@property(nonatomic,strong)NSString* vipTitle;
@property(nonatomic,strong)NSString* vipImg;
@property(nonatomic,strong)NSString* vipDescription;
@property(nonatomic,assign)BOOL trial;
@property(nonatomic,assign)double points;
@end

@interface ContentProductListModel : NSObject//内容所属产品列表
@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSMutableArray* list;
@property(nonatomic,strong)NSMutableArray* vipList;
- (id)initWithDictionary:(NSDictionary *)dictionary andVipArr:(NSMutableArray*)vipArr :(NSMutableArray *)ContentArr;
@end
