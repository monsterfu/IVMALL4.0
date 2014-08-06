//
//  AppPointsModel.h
//  IVMall
//
//  Created by SMiT on 14-4-21.
//  Copyright (c) 2014年 www.smit.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppPointModel : NSObject
@property(nonatomic,assign)double points;
@property(nonatomic,assign)double price;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
@interface AppPointsModel : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSMutableArray* list;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
