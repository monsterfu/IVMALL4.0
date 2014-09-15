//
//  AppDelegate.m
//  IVMall (Ipad)
//
//  Created by sean on 14-2-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpRequest.h"
#import "Macro.h"
#import "Commonality.h"
#import "MainViewController.h"
#import "IVMallPlayer.h"
#import "AppConfigModel.h"
#import "NoDataModel.h"
#import "BPush.h"
#import "JSONKit.h"
//zjj 4.0
#import "MyNavigationController.h"
#import "ContentEpisodeItemListViewController.h"
//zjj 4.0
@implementation AppDelegate
{
    NSURLConnection* aSynConnection;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self welcome];
    if (!iPad) {
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
    }
    [[IVMallPlayer sharedIVMallPlayer]IVMallPlayerInit:@"locodrm-server.locostream.com.cn":nil];
    [self configControl];
    [self commitDownloadTimes];
    [self autoLogin];

    [self enterMainView];
    //zjj
//    _token = @"%27%3F*%2F%265%17ryg%7Fq%7B%0F%210%271%24*%15afv%15a%7Cv%7Fa%7Cqxi%7F%7F%7Ch";
//    [self enterMainView];
    //zjj

    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [application setApplicationIconBadgeNumber:0];
    [application  registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
    if([WXApi registerApp:WXAppId])
    {
        NSLog(@"weixin registerApp success!");
    }
    return YES;
}

//zjj 4.0
- (void)autoLogin
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString* mobile = [userDefaultes stringForKey:@"mobile"];
    NSString* password = [userDefaultes stringForKey:@"password"];
    if (![Commonality isEmpty:mobile]&&![Commonality isEmpty:password]) {
        [HttpRequest UserLoginRequestMobile:mobile password:password delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}


- (void)enterMainView
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController* myMainViewController = [[MainViewController alloc]init];
    MyNavigationController* myNavigationController = [[MyNavigationController alloc]initWithRootViewController:myMainViewController];
    [myNavigationController setNavigationBarHidden:YES];
    [self.window setRootViewController:myNavigationController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)welcome
{
    NSString * str =  [[NSBundle mainBundle] pathForResource:@"IVMallWelcome" ofType:@"wav"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:str] error:nil];
    [_audioPlayer play];
}

- (void)play
{
    NSString * str =  [[NSBundle mainBundle] pathForResource:@"IVMallPlay" ofType:@"wav"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:str] error:nil];
    [_audioPlayer play];
}

- (void)click
{
    NSString * str =  [[NSBundle mainBundle] pathForResource:@"IVMallClick" ofType:@"wav"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:str] error:nil];
    [_audioPlayer play];
}
//zjj 4.0


- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
    
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
//        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == BPushErrorCode_Success) {
            self.appId = appid;
            self.channelId = channelid;
            self.userId = userid;
            
            //user add
            NSMutableDictionary* deviceInfoDic = [[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo];
            NSString* urlString = [NSString stringWithFormat:@"%@/user/add?userid=%@&drmid=%@&deviceType=4&userOrigin=ivmall",APPSERVER,userid,[deviceInfoDic objectForKey:@"deviceDRMId"]];
            NSLog(@"urlString =%@",urlString);
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString: urlString]];
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            [request setTimeoutInterval: 30];
            [request setHTTPShouldHandleCookies:FALSE];
            [request setHTTPMethod:@"GET"];
            aSynConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
    else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
        }
    }
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error is %@",error);
}

#pragma mark- NSURLConnectionDataDelegate 协议方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == aSynConnection) {
        NSLog(@"response=%@",response);
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
//    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString* message = [userInfo objectForKey:@"IVMALL_PUSH"];
    if (application.applicationState == UIApplicationStateInactive) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"爱V猫提醒您"
//                                                            message:[NSString stringWithFormat:@"%@", alert]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"知道了"
//                                                  otherButtonTitles:nil];
//        [alertView show];
        NSLog(@"self.window.rootViewController.childViewControllers=%@",self.window.rootViewController.childViewControllers);
        if ([message hasPrefix:@"Ender_Push_Msg:"]) {
            if ([[self.window.rootViewController.childViewControllers lastObject] isKindOfClass:[UserLoginViewController class]]) {
                NSArray* loginInfo = [message componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPushAutoLogin object:loginInfo];
            }
        }else if([message hasPrefix:@"Ender_Episode:"]){
            if (self.window.rootViewController.childViewControllers) {
                NSArray* episodeInfo = [message componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
                if (episodeInfo.count >= 3) {
                    ContentEpisodeItemListViewController* myContentEpisodeItemListViewController = [[ContentEpisodeItemListViewController alloc]init];
                    myContentEpisodeItemListViewController.episodeGuid = [episodeInfo objectAtIndex:2];
                    myContentEpisodeItemListViewController.langs = nil;
                    MyNavigationController* temp = (MyNavigationController*)self.window.rootViewController;
                    [temp pushViewController:myContentEpisodeItemListViewController animated:NO];
                }

            }
        
        }else if([message hasPrefix:@"Ender_Trial:"]){
            if (self.window.rootViewController.childViewControllers) {
                UserRegisterViewController* myUserRegisterViewController = [[UserRegisterViewController alloc]init];
                myUserRegisterViewController.isFromLoginView = NO;
                 MyNavigationController* temp = (MyNavigationController*)self.window.rootViewController;
                [temp pushViewController:myUserRegisterViewController animated:NO];
            }
        }else if([message hasPrefix:@"Ender_Subscribe:"]){
            if (self.window.rootViewController ) {
                if ([AppDelegate App].charge && [[AppDelegate App].charge isEqualToString:@"true"]) {
                    PurchaseAndRechargeManagerController* purchaseController = [[PurchaseAndRechargeManagerController alloc]initWithNibName:nil bundle:nil mode:ProcessModeEnum_Purchase completionHandler:nil];
                    
                    PopUpViewController* popUpViewController = [[PopUpViewController shareInstance]initWithNibName:@"PopUpViewController" bundle:nil];
                    
                    [popUpViewController popViewController:purchaseController fromViewController:[self.window.rootViewController.childViewControllers lastObject] finishViewController:nil blur:YES];
                }
            }
        }else if([message hasPrefix:@"Ender_Promotion:"]){
            NSArray* promotInfo = [message componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
            if (promotInfo.count >= 3 && [[promotInfo objectAtIndex:1]isEqualToString:@"couponCode"]) {
//                [[NSUserDefaults standardUserDefaults] setObject:[promotInfo objectAtIndex:2] forKey:@"couponCode"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
                _couponCode = [promotInfo objectAtIndex:2] ;
                if (self.window.rootViewController.childViewControllers) {
                    UserRegisterViewController* myUserRegisterViewController = [[UserRegisterViewController alloc]init];
                    myUserRegisterViewController.isFromLoginView = NO;
                    MyNavigationController* temp = (MyNavigationController*)self.window.rootViewController;
                    [temp pushViewController:myUserRegisterViewController animated:NO];
                }
            }
        }
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
}

-(void)commitDownloadTimes
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * isCommit = [userDefaultes objectForKey:@"isCommited"];
    if (![isCommit isEqualToString:@"YES"]) {
        [HttpRequest AppInstallDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

-(void)configControl
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _copyright=[userDefaultes objectForKey:@"copyright_Ivmall"];
    _charge=[userDefaultes objectForKey:@"charge_Ivmall"];
    if (_copyright == nil || _charge == nil) {
        [HttpRequest AppConfigDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }else{
        
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _alertView) {
        if (buttonIndex == 0) {
            exit(0);
        }
    }else if(alertView == _wxResultAlertView){
        [HttpRequest TenPay_TradeResult_Token:_myUserLoginMode.token outTradeNo:[WXPayClient shareInstance].prepareWXPayModel.outTradeNo delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];        
    }else if (alertView.tag == 10000) {
        if (buttonIndex==1) {
            if ([[UIApplication sharedApplication]canOpenURL:_trackViewUrl]) {
                [[UIApplication sharedApplication]openURL:_trackViewUrl];
            }
        }
    }
}


-(void) GetErr:(ASIHTTPRequest *)request{
    if (request.tag == APP_CONFIG_TYPE)
    {
        _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前网络异常，请先退出应用配置网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        _alertView.delegate = self;
        [_alertView show];
        return;
    }
}

-(void) GetResult:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

    if (dictionary==nil)
    {
        if (request.tag == APP_CONFIG_TYPE)
        {
            _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前网络异常，请先退出应用配置网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            _alertView.delegate = self;
            [_alertView show];
            return;
        }
    }else
    {
        if (request.tag == APP_CONFIG_TYPE)
        {
            AppConfigModel*config=[[AppConfigModel alloc]initWithDictionary:dictionary];
            if (config.errorCode==0)
            {
                _copyright=config.copyright;//版权
                _charge = config.charge;//收费
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                [userDefaultes setObject:_copyright forKey:@"copyright_Ivmall"];
                [userDefaultes setObject:_charge forKey:@"charge_Ivmall"];
                [userDefaultes synchronize];
                [self enterMainView];
            }else{
                _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前网络异常，请先退出应用配置网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                _alertView.delegate = self;
                [_alertView show];
                return;
            }
        }
        else if (request.tag == USER_LOGIN_TYPE)
        {
            self.myUserLoginMode = [[UserLoginModel alloc]initWithDictionary:dictionary];
            if (self.myUserLoginMode.errorCode == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterLoginInSuccess object:nil];
                [HttpRequest UserDetailRequestToken:self.myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                [HttpRequest DevicesBindRequestToken:self.myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }
        }
        else if (request.tag == USER_DETAIL_TYPE)
        {
            self.UserInfo = [[UserDetailMode alloc]initWithDictionary:dictionary];
            if (self.UserInfo.errorCode == 0 && (![Commonality isEmpty:self.UserInfo.userImg])) {
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterUserImage object:self.UserInfo.userImg];
            }
        }
        else if (request.tag == APP_INSTALL_TYPE)
        {
            NoDataModel* temp = [[NoDataModel alloc]initWithDictionary:dictionary];
            if (temp.errorCode == 0) {
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                [userDefaultes setObject:@"YES" forKey:@"isCommited"];
                [userDefaultes synchronize];
            }
        }
        else if (request.tag == ALIPAY_TRADERESULT_TYPE)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPayAlipayResult object:nil userInfo:dictionary];

        }else if(request.tag == ALIPAY_QRCODETRADERESULT_TYPE)
        {
            TradeResultModel* tradeResultModel = [[TradeResultModel alloc]initWithDictionary:dictionary];
            
            if (tradeResultModel.result == 0&&[tradeResultModel.tradeResult isEqualToString:@"true"]) {
                PayAddModel *lm=[[PayAddModel alloc]init];
                lm.points = tradeResultModel.points;
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPayAlipayResult object:nil userInfo:dictionary];
            }
            
        }else if(request.tag == TENPAY_TRADERESULT_TYPE)
        {
            TenPayTradeResultModel* tradeResultModel = [[TenPayTradeResultModel alloc]initWithDictionary:dictionary];
            
            if (tradeResultModel.result == 0&&[tradeResultModel.tradeResult isEqualToString:@"true"]) {
                PayAddModel *lm=[[PayAddModel alloc]init];
                lm.points = tradeResultModel.points;
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPayAlipayResult object:nil userInfo:dictionary];
            }
        }
    }
}

+(AppDelegate *)App{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

- (void)applicationDidBecomeActive:(UIApplication *)application{

}

- (void)applicationWillTerminate:(UIApplication *)application{
    [[IVMallPlayer sharedIVMallPlayer]IVMallPlayerDestroy];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}

#endif

-(void)onResp:(BaseResp *)resp
{
    NSLog(@"%@",resp);
    NSLog(@"errStr %@",[resp errStr]);
    NSLog(@"errCode %d",[resp errCode]);
    NSLog(@"type %d",[resp type]);
    if ([resp errCode]) {
        UIAlertView* alerview = [[UIAlertView alloc]initWithTitle:@"失败" message:[resp errStr] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alerview show];
    }else{
        [HttpRequest TenPay_TradeResult_Token:_myUserLoginMode.token outTradeNo:[WXPayClient shareInstance].prepareWXPayModel.outTradeNo delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果涉及其他应用交互,请做如下判断,例如:还可能和新浪微博进行交互
    if ([url.scheme isEqualToString:WXAppId]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else
    {
        [self parse:url application:application];
        return YES;
    }
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self parse:url application:application];
    return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
//            [HttpRequest AlipayTradeResultRequestToken:self.myUserLoginMode.token outTradeNo:self.outTradeNo  totalFee:self.totalFee delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            [HttpRequest AlipayQRCODETradeResultRequestToken:[AppDelegate App].myUserLoginMode.token outTradeNo:self.outTradeNo delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}


@end
