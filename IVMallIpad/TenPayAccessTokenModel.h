//
//  TenPayAccessTokenModel.h
//  IVMallHD
//
//  Created by Monster on 14-9-1.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenPayAccessTokenModel : NSObject
@property (nonatomic,strong) NSString* errorCode;
@property (nonatomic,strong) NSString* errorMessage;
@property (nonatomic,strong) NSString* accessToken;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
