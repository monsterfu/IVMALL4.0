//
//  WXPayClient.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXPayConstant.h"
#import "Macro.h"
#import "TenPayAccessTokenModel.h"
#import "TenPayPrepareWXPayModel.h"
#import "TenPayTradeResultModel.h"


@interface WXPayClient : NSObject<WXApiDelegate>
{
    NSString* _accessToken;
    TenPayAccessTokenModel* _accessTokenModel;
    
    TenPayTradeResultModel* _tradeResultModel;
    UIView* _errBaseView;
    UIAlertView* _installAlertView;
    UIAlertView* _UpdateAlertView;
}
@property (nonatomic, assign)double price;
@property (nonatomic, strong) NSString* productId;
@property (nonatomic, strong)TenPayPrepareWXPayModel* prepareWXPayModel;

+ (instancetype)shareInstance;
- (void)payProduct:(NSString*) productId price:(double)price view:(UIView*)view;
@end
