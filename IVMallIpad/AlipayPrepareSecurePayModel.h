//
//  AlipayPrepareSecurePayModel.h
//  IVMall
//
//  Created by SMiT on 14-4-22.
//  Copyright (c) 2014年 www.smit.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayPrepareSecurePayModel : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* subject;
@property(nonatomic,strong)NSString* body;
@property(nonatomic,strong)NSString* outTradeNo;
@property(nonatomic,assign)double totalFee;
@property(nonatomic,strong)NSString* notifyURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
