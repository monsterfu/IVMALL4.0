//
//  ProductPlayModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductPlayModel : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* URI;
@property(nonatomic,strong)NSString* catchupURI;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
