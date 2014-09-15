//
//  HttpRequest.m
//  IVMall (Ipad)
//
//  Created by sean on 14-2-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "HttpRequest.h"
#import "Macro.h"
#import "AppDelegate.h"
#import "IVMallPlayer.h"
@implementation HttpRequest
+(void)Request:(NSString*)url postdate:(NSString*)postdata tag:(int)tag delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel{
    
    NSLog(@"url is %@",url);
    NSLog(@"%@ ---------%d",postdata,tag);
    NSURL *httpurl = [NSURL URLWithString:url];
    
    ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:httpurl];
    
    [asiRequest setTag:tag];
    [asiRequest appendPostData:[postdata dataUsingEncoding:NSUTF8StringEncoding]];
    [asiRequest setUseSessionPersistence:YES];
    [asiRequest setUseCookiePersistence:YES];
    [asiRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [asiRequest setDelegate:delegate];
    [asiRequest setTimeOutSeconds:10];
    [asiRequest setDidFinishSelector:finishSel];
    [asiRequest setDidFailSelector:failSel];
    
    [asiRequest startAsynchronous];
    
}
+(void)request:(NSString*)url tag:(int)tag delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel{
    
    NSLog(@"url is %@",url);
    NSURL *httpurl = [NSURL URLWithString:url];
    
    ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:httpurl];
    
    [asiRequest setTag:tag];
    [asiRequest setRequestMethod:@"GET"];
    [asiRequest setUseSessionPersistence:YES];
    [asiRequest setUseCookiePersistence:YES];
    [asiRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [asiRequest setDelegate:delegate];
    [asiRequest setTimeOutSeconds:10];
    [asiRequest setDidFinishSelector:finishSel];
    [asiRequest setDidFailSelector:failSel];
    
    [asiRequest startAsynchronous];
    
}
//zjj
//5.0.1	应用控制
+(void)AppConfigDelegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:APP_CONFIG_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:APP_CONFIG_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.0.2	点数列表
+(void)AppPointsDelegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:APP_POINTS_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:APP_POINTS_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.0.3	首次安装应用
+(void)AppInstallDelegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    NSString* deviceModel = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo] objectForKey:@"model"];
    [self Request:APP_INSTALL_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\",\"deviceModel\":\"%@\"}",CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId,deviceModel] tag:APP_INSTALL_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.0.5	获取提示信息(v4.0)
+(void)AppTipsRequestRequestToken:(NSString*)token key:(NSString*)key delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:APP_TIPS_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"key\":\"anonymous.login.tips\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:APP_TIPS_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.1	用户注册
+(void)UserRegisterRequestMobile:(NSString*)mobile password:(NSString *)password checkcode:(NSString *)checkcode couponcode:(NSString *)couponcode delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    NSString* deviceModel = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo] objectForKey:@"model"];
    if (couponcode == nil) {
        [self Request:USER_REGISTER_ACTION postdate:[NSString stringWithFormat:@"{\"mobile\":\"%@\",\"password\":\"%@\",\"validateCode\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\",\"deviceModel\":\"%@\"}",mobile,password,checkcode,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId,deviceModel] tag:USER_REGISTER_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }else{
        [self Request:USER_REGISTER_ACTION postdate:[NSString stringWithFormat:@"{\"mobile\":\"%@\",\"password\":\"%@\",\"validateCode\":\"%@\",\"promoCode\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\",\"deviceModel\":\"%@\"}",mobile,password,checkcode,couponcode,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId,deviceModel] tag:USER_REGISTER_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }
}
//5.1.2	用户登录
+(void)UserLoginRequestMobile:(NSString*)mobile password:(NSString*)password delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_LOGIN_ACTION postdate:[NSString stringWithFormat:@"{\"mobile\":\"%@\",\"password\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",mobile,password,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_LOGIN_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}

//5.1.4	用户修改密码
+(void)UserUpdatePasswordRequestToken:(NSString*)token oldPassword:(NSString*)oldPassword onewPassword:(NSString*)newPassword delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_UPDATEPASSWORD_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"oldPassword\":\"%@\",\"newPassword\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,oldPassword,newPassword,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_UPDATEPASSWORD_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}

//5.1.5	手机号码判断
+(void)UserMobileRequestMobile:(NSString*)mobile delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_MOBILE_ACTION postdate:[NSString stringWithFormat:@"{\"mobile\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",mobile,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_MOBILE_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.6	获取短信验证码
+(void)UserSMSRequestMobile:(NSString*)mobile delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_SMS_ACTION postdate:[NSString stringWithFormat:@"{\"mobile\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",mobile,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_SMS_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.7	用户修改个人资料
+(void)UserUpdateRequestToken:(NSString*)token nickName:(NSString*)nickname email:(NSString*)email birthday:(NSString*)birthday gender:(NSString*)gender address:(NSString*)address delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_UPDATE_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"nickname\":\"%@\",\"email\":\"%@\",\"birthday\":\"%@\",\"gender\":\"%@\",\"address\":\"%@\",\"lang\":\"zh-cn\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,nickname,email,birthday,gender,address,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_UPDATE_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.9	获取用户信息
+(void)UserDetailRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_DETAIL_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_DETAIL_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.10添加到收藏
+(void)FavoriteAddRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:FAVORITE_ADD_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"contentGuid\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,contentGuid,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:FAVORITE_ADD_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.11取消收藏
+(void)FavoriteDelRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    //contentGuid 可包含多个id，用逗号区分
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:FAVORITE_DEL_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"id\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,contentGuid,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:FAVORITE_DEL_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.12取消收藏（按内容ID）
+(void)FavoriteDelByGuidRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    //contentGuid 可包含多个id，用逗号区分
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:FAVORITE_DELBYGUID_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"contentGuid\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,contentGuid,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:FAVORITE_DELBYGUID_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.13	收藏列表
+(void)FavoriteListRequestToken:(NSString*)token page:(int)page rows:(int)rows delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:FAVORITE_LIST_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"page\":\"%d\",\"rows\":\"%d\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,page + 1,rows,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:FAVORITE_LIST_TYPE+(PAGESECTION)*page delegate:delegate finishSel:finishSel failSel:failSel];
    NSLog(@"%@",[NSString stringWithFormat:@"{\"token\":\"%@\",\"page\":\"%d\",\"rows\":\"%d\",\"client\":\"%@""\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,page+1,rows,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId]);
}
//5.1.15	播放记录列表
+(void)PlayListRequestToken:(NSString*)token page:(int)page rows:(int)rows delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:PLAY_LIST_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"page\":\"%d\",\"rows\":\"%d\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,page,rows,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PLAY_LIST_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.16	点卡充值
+(void)PayAddRequestToken:(NSString*)token voucherCode:(NSString*)voucherCode password:(NSString*)password delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:PAY_ADD_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"voucherCode\":\"%@\",\"password\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,voucherCode,password,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PAY_ADD_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.17	充值记录
+(void)PayListRequestToken:(NSString*)token page:(int)page rows:(int)rows delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:PAY_LIST_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"page\":\"%d\",\"rows\":\"%d\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,page,rows,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PAY_LIST_TYPE+(PAGESECTION)*page delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.18	获取当前余额
+(void)UserBalanceRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_BALANCE_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_BALANCE_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.20	已购买产品列表
+(void)BuyListRequestToken:(NSString*)token page:(int)page rows:(int)rows delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:BUY_LIST_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"page\":\"%d\",\"rows\":\"%d\",\"buyType\":\"vip\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,page,rows,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:BUY_LIST_TYPE+(PAGESECTION)*page delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.21	取消播放记录
+(void)PlayDelRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    //contentGuid 可包含多个id，用逗号区分
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:PLAY_DEL_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"id\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,contentGuid,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PLAY_DEL_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}

//5.1.22	忘记密码
+(void)UserForgetPasswordRequestMobile:(NSString*)mobile validateCode:(NSString*)validateCode password:(NSString*)password delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    //contentGuid 可包含多个id，用逗号区分
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_FORGETPASSWORD_ACTION postdate:[NSString stringWithFormat:@"{\"mobile\":\"%@\",\"validateCode\":\"%@\",\"password\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",mobile,validateCode,password,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_FORGETPASSWORD_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.23	清空播放记录
+(void)PlayEmptyRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:PLAY_EMPTY_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PLAY_EMPTY_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.24	清空收藏
+(void)FavoriteEmptyRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:FAVORITE_EMPTY_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:FAVORITE_EMPTY_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.25	VIP资格列表
+(void)VipListRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:VIP_LIST_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:VIP_LIST_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.26	购买VIP资格
+(void)BuyVipRequestToken:(NSString*)token vipGuid:(NSString*)vipGuid points:(float)points delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:BUY_VIP_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"vipGuid\":\"%@\",\"points\":\"%f\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,vipGuid,points,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:VIP_LIST_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.27	用户偏好存取
+(void)UserPreferenceRequestToken:(NSString*)token preferenceKey:(NSString*) preferenceKey preferenceValue:(NSString*)preferenceValue delegate:delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    if (preferenceValue) {
        [self Request:USER_PREFERENCE_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"preferenceKey\":\"%@\",\"preferenceValue\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,preferenceKey,preferenceValue,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_PREFERENCE_SET_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }else{
        [self Request:USER_PREFERENCE_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"preferenceKey\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,preferenceKey,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_PREFERENCE_GET_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }
    
}
//5.1.29	用户观看时长
+(void)UserPlayTimeRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:USER_PLAYTIME_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:USER_PLAYTIME_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.1.30	获取账户信息

//5.1.31	免注册登陆
+(void)AnonymousLoginDelegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    NSString* serial = [[[IVMallPlayer sharedIVMallPlayer]IVMallPlayerGetLocalInfo]objectForKey:@"seiralNo"];
    NSString* macAddr = [[[IVMallPlayer sharedIVMallPlayer]IVMallPlayerGetLocalInfo]objectForKey:@"macAddr"];
    NSString* osVersion = [[[IVMallPlayer sharedIVMallPlayer]IVMallPlayerGetLocalInfo]objectForKey:@"osVersion"];
    NSString* deviceModel = [[[IVMallPlayer sharedIVMallPlayer]IVMallPlayerGetLocalInfo]objectForKey:@"model"];
    
    NSString* deviceGroup = @"Mobile";
    if (iPad) {
        deviceGroup = @"Tablet";
    }

    [self Request:ANONYMOUS_LOGIN_ACTION postdate:[NSString stringWithFormat:@"{\"osVersion\":\"%@\",\"deviceModel\":\"%@\",\"serial\":\"%@\",\"macAddr\":\"%@\",\"protocol\":\"hls0\",\"DRMType\":\"loco\",\"deviceGroup\":\"%@\",\"lang\":\"zh-cn\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",osVersion,deviceModel,serial,macAddr,deviceGroup,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:ANONYMOUS_LOGIN_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}

+(void)PlayEpisodeListRequestToken:(NSString*)token page:(int)page rows:(int)rows delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:PLAY_EPISODELIST_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"page\":\"1\",\"rows\":\"20\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PLAY_EPISODELIST_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.2.7	首页初始化-mobile(v2.4)
+(void)IndexFeaturedHomeRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    NSString* deviceModel = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo] objectForKey:@"model"];
    if (token) {
        [self Request:INDEX_FEATUREDHOME_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\",\"deviceModel\":\"%@\"}",token,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId,deviceModel] tag:INDEX_FEATUREDHOME_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }else{
        [self Request:INDEX_FEATUREDHOME_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\",\"deviceModel\":\"%@\"}",CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId,deviceModel] tag:INDEX_FEATUREDHOME_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    
    }
}
//5.3.5	频道内容列表


//5.3.6	频道分类列表
+(void)ChannelCategoryListRequestDelegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    [self Request:CHANNEL_CATEGORYLIST_ACTION postdate:[NSString stringWithFormat:@"{\"channelCode\":\"children\",\"page\":\"1\",\"rows\":\"1000\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:CHANNEL_CATEGORYLIST_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.3.7	频道猫全部内容列表
+(void)ChannelCatContentListRequestToken:(NSString*)token categoryId:(NSString*)categoryId index:(int)index offset:(int)offset delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    if (token) {
        [self Request:CHANNEL_CATCONTENTLIST_ACTION postdate:[NSString stringWithFormat:@"{\"channelCode\":\"children\",\"token\":\"%@\",\"categoryId\":\"%@\",\"index\":\"%d\",\"offset\":\"%d\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,categoryId,index,offset,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:CHANNEL_CATCONTENTLIST_TYPE+(index/offset)*PAGESECTION delegate:delegate finishSel:finishSel failSel:failSel];
    }else{
        [self Request:CHANNEL_CATCONTENTLIST_ACTION postdate:[NSString stringWithFormat:@"{\"channelCode\":\"children\",\"categoryId\":\"%@\",\"index\":\"%d\",\"offset\":\"%d\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",categoryId,index,offset,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:CHANNEL_CATCONTENTLIST_TYPE+(index/offset)*PAGESECTION  delegate:delegate finishSel:finishSel failSel:failSel];
    }

}
//5.4.2	播放视频
+(void)ProductPlayRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    NSString* deviceGroup = @"Mobile";
    if (iPad) {
        deviceGroup = @"Tablet";
    }
//    if (token) {
//        [self Request:PRODUCT_PLAY_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"contentGuid\":\"8cb3f2a8-5fa1-4166-8b0e-5d59dc79b28e\",\"protocol\":\"hls0\",\"DRMType\":\"loco\",\"deviceGroup\":\"%@\",\"lang\":\"zh-cn\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,deviceGroup,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PRODUCT_PLAY_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
        [self Request:PRODUCT_PLAY_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"contentGuid\":\"%@\",\"protocol\":\"hls0\",\"DRMType\":\"loco\",\"deviceGroup\":\"%@\",\"lang\":\"zh-cn\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,contentGuid,deviceGroup,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PRODUCT_PLAY_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    
//    }
//    else{
//        [self Request:PRODUCT_PLAY_ACTION postdate:[NSString stringWithFormat:@"{\"contentGuid\":\"%@\",\"protocol\":\"hls0\",\"DRMType\":\"loco\",\"deviceGroup\":\"%@\",\"lang\":\"zh-cn\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",contentGuid,deviceGroup,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:PRODUCT_PLAY_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
//    }
}
//5.5.7	剧集内容列表
+(void)ContentEpisodeItemListRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid lang:(NSString*)lang  delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    int langSection = 0;
    if ([lang isEqualToString:@"en-gb"]) {
        langSection = 1;
    }
    if (token) {
        [self Request:CONTENT_EPISODEITEMLIST_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"contentGuid\":\"%@\",\"page\":\"1\",\"rows\":\"1000\",\"lang\":\"%@""\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,contentGuid,lang,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:CONTENT_EPISODEITEMLIST_TYPE+langSection delegate:delegate finishSel:finishSel failSel:failSel];
    }else{
        [self Request:CONTENT_EPISODEITEMLIST_ACTION postdate:[NSString stringWithFormat:@"{\"contentGuid\":\"%@\",\"page\":\"1\",\"rows\":\"1000\",\"lang\":\"%@""\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",contentGuid,lang,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:CONTENT_EPISODEITEMLIST_TYPE+langSection delegate:delegate finishSel:finishSel failSel:failSel];
    }
}
//5.6.1	设备绑定
+(void)DevicesBindRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    NSDictionary* deviceInfo = [[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo];
    NSString* deviceDRMId = [deviceInfo objectForKey:@"deviceDRMId"];
    NSString* serial = [deviceInfo objectForKey:@"seiralNo"];
    NSString* macAddr = [deviceInfo objectForKey:@"macAddr"];
    NSString* osVersion = [deviceInfo objectForKey:@"osVersion"];
    NSString* deviceModel = [deviceInfo objectForKey:@"model"];
    [self Request:DEVICES_BIND_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"DRMType\":\"loco\",\"deviceInfo\":\"%@\",\"serial\":\"%@\",\"macAddr\":\"%@\",\"osVersion\":\"%@\",\"deviceModel\":\"%@""\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,CLIENT,serial,macAddr,osVersion,deviceModel,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:DEVICES_BIND_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.10.2.1	手机移动快捷支付
+(void)AlipayPrepareSecurePayRequestToken:(NSString*)token price:(double)price vipGuid:(NSString*)vipGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
    if (vipGuid == nil) {
        [self Request:ALIPAY_PREPARESECUREPAY_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"price\":\"%.2f\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\"}",token,price,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId] tag:ALIPAY_PREPARESECUREPAY_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }else{
        [self Request:ALIPAY_PREPARESECUREPAY_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"price\":\"%.2f\",\"client\":\"%@\",\"appVersion\":\"%@\",\"publishId\":\"%@\",\"promoter\":\"%@\",\"deviceDRMId\":\"%@\",\"vipGuid\":\"%@\"}",token,price,CLIENT,IVMALL_VERSION,PUBLISHID,PROMOTER,deviceDRMId,vipGuid] tag:ALIPAY_PREPARESECUREPAY_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
        }
}
//5.10.3	交易状态查询
+(void)AlipayTradeResultRequestToken:(NSString*)token outTradeNo:(NSString*)outTradeNo totalFee:(double)totalFee delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    [self Request:ALIPAY_TRADERESULT_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"outTradeNo\":\"%@\",\"totalFee\":\"%.2f\",\"client\":\"%@\"}",token,outTradeNo,totalFee,CLIENT] tag:ALIPAY_TRADERESULT_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
+(void)AlipayQRCODETradeResultRequestToken:(NSString*)token outTradeNo:(NSString*)outTradeNo delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    [self Request:ALIPAY_QRCODETRADERESULT_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"outTradeNo\":\"%@\",\"client\":\"%@\"}",token,outTradeNo,CLIENT] tag:ALIPAY_QRCODETRADERESULT_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.10.2.4  二维码支付
+(void)AppTwoDimensionPayToken:(NSString*)token price:(double)price vipGuid:(NSString*)vipGuid points:(double)points  delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    if (vipGuid == nil) {
        [self Request:TWODIMENSION_CODE_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@""\",\"token\":\"%@\",\"price\":\"%f\"}",CLIENT,token,price] tag:TWODIMENSION_CODE_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }else{
        [self Request:TWODIMENSION_CODE_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@""\",\"token\":\"%@\",\"price\":\"%.2f\",\"vipGuid\":\"%@\",\"points\":\"%.2f\",\"promoter\":\"2000\"}",CLIENT,token,price,vipGuid,points] tag:TWODIMENSION_CODE_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }
    
}
//二维码
//zjj


////5.10.5.3	微信应用获取access token接口
+(void)TenPay_AccessToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    [self Request:TENPAY_ACCESSTOKEN_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@\",\"token\":\"%@\",\"appId\":\"%@\"}",CLIENT,token,WXAppId] tag:TENPAY_ACCESSTOKEN_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}


//5.10.5.2	微信支付交易状态查询接口
+(void)TenPay_TradeResult_Token:(NSString*)token outTradeNo:(NSString*)outTradeNo delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel
{
    [self Request:TENPAY_TRADERESULT_ACTION postdate:[NSString stringWithFormat:@"{\"token\":\"%@\",\"outTradeNo\":\"%@\",\"client\":\"%@\"}",token,outTradeNo,CLIENT] tag:TENPAY_TRADERESULT_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
}
//5.10.5.1	微信支付预支付接口
+(void)TenPayPrepareWXPayToken:(NSString*)token price:(double)price vipGuid:(NSString*)vipGuid delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel
{
    if (vipGuid == nil) {
        [self Request:TENPAY_PREPAREWXPay_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@\",\"token\":\"%@\",\"price\":\"%.2f\",\"appId\":\"%@\"}",CLIENT,token,price,WXAppId] tag:TENPAY_PREPAREWXPay_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }else{
        [self Request:TENPAY_PREPAREWXPay_ACTION postdate:[NSString stringWithFormat:@"{\"client\":\"%@\",\"token\":\"%@\",\"price\":\"%.2f\",\"vipGuid\":\"%@\",\"appId\":\"%@\"}",CLIENT,token,price,vipGuid,WXAppId] tag:TENPAY_PREPAREWXPay_TYPE delegate:delegate finishSel:finishSel failSel:failSel];
    }
}
@end









