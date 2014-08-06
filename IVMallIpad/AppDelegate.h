//
//  AppDelegate.h
//  IVMall (Ipad)
//
//  Created by sean on 14-2-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
#import "HttpRequest.h"

//支付宝
#import "AlixPayResult.h"
#import "DataVerifier.h"
//支付宝

//zjj
#import "UserDetailMode.h"
#import "UserLoginModel.h"
#import "AnonymousLoginMode.h"
#import <AVFoundation/AVFoundation.h>
//zjj
@class PersonnalCenter;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString * copyright;
@property (nonatomic, strong) NSString * charge;

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *userId;

@property(nonatomic,strong)UIAlertView * alertView;
@property(nonatomic,strong)UIAlertView * statcAlertView;
//支付宝
@property(nonatomic,strong)NSString* outTradeNo;
@property(nonatomic,assign)double totalFee;
//支付宝

@property(nonatomic,strong)AVAudioPlayer* audioPlayer;

//zjj 4.0
+(AppDelegate *)App;
-(void)welcome;
-(void)play;
-(void)click;
@property (nonatomic,strong) UserDetailMode* UserInfo;
@property (nonatomic,strong) UserLoginModel* myUserLoginMode;
//@property (nonatomic,strong) NSString* token;
@property (nonatomic,strong) AnonymousLoginMode* myAnonymousLoginMode;
@property (nonatomic,strong) NSString* couponCode;
@property (nonatomic,strong) NSURL *trackViewUrl;
//zjj 4.0
@end
