//
//  AppTwoDimensionPayModel.h
//  IVMallHD
//
//  Created by Monster on 14-7-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTwoDimensionPayModel : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* qrcodeURL;
@property(nonatomic,strong)NSString* qrcodeImgURL;
@property(nonatomic,strong)NSString* outTradeNo;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
