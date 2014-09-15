//
//  TenPayPrepareWXPayModel.h
//  IVMallHD
//
//  Created by Monster on 14-9-1.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenPayPrepareWXPayModel : NSObject

@property (nonatomic,strong) NSString* errorCode;
@property (nonatomic,strong) NSString* errorMessage;
@property (nonatomic,strong) NSString* prepayid;
@property (nonatomic,strong) NSString* nonceStr;
@property (nonatomic,strong) NSString* timestamp;
@property (nonatomic,strong) NSString* packageValue;
@property (nonatomic,strong) NSString* sign;
@property (nonatomic,strong) NSString* accessToken;
@property (nonatomic,strong) NSString* subject;
@property (nonatomic,strong) NSString* body;
@property (nonatomic,strong) NSString* outTradeNo;
@property (nonatomic,strong) NSString* totalFee;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
