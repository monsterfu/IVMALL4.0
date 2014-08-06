//
//  Macro.h
//  IVMall (Ipad)
//
//  Created by sean on 14-2-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PopUpViewController.h"
#import "HttpRequest.h"
#import "Commonality.h"
//#import "JYTextField.h"
#import "UITextField+UITextField_JY.h"
#import "AppDelegate.h"
#import "NSString+xibName.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ?YES:NO)
#define VIEWWIDTH ([UIScreen mainScreen].applicationFrame.size.width)
#define VIEWHEIGHT ([UIScreen mainScreen].applicationFrame.size.height)
#define iPad ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?NO:YES)
#define CLIENT ((iPad == YES) ?@"ipad":@"ios")
#define PROMOTER @"20000"
#define PUBLISHID @"ivmall"


#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define FAIILURE @"当前网络不可用，请检查网络！"
#define LINGKERROR @"网络连接异常，请重试!"
#define NOWIFIERROR @"当前网络异常,请先退出应用配置网络"
#define IVMALL_VERSION @"4.0.7"
#define CALLPHONE @"4009904909"
#define ALOPH 0.6

//#define BASE @"http://221.228.203.230:28080"
//#define BASE @"http://192.168.20.130:28080"
#define BASE @"http://api.ivmall.com"
#define APPSERVER @"http://api.ivmall.com/push"


//zjj
//mjh
#define CHECKVERSION 1000000

#define PAGESECTION 10000000
//5.0.1	应用控制
#define APP_CONFIG_ACTION [BASE stringByAppendingString:@"/app/config.action"]
#define APP_CONFIG_TYPE 5000100
//5.0.2	点数列表
#define APP_POINTS_ACTION [BASE stringByAppendingString:@"/app/points.action"]
#define APP_POINTS_TYPE 5000200
//5.0.3	首次安装应用
#define APP_INSTALL_ACTION [BASE stringByAppendingString:@"/app/install.action"]
#define APP_INSTALL_TYPE 5000300
//5.0.5 获取提示信息
#define APP_TIPS_ACTION [BASE stringByAppendingString:@"/app/tips.action"]
#define APP_TIPS_TYPE 5000500
//5.1.1	用户注册
#define USER_REGISTER_ACTION [BASE stringByAppendingString:@"/user/register.action"]
#define USER_REGISTER_TYPE 5010100
//5.1.2	用户登录
#define USER_LOGIN_ACTION [BASE stringByAppendingString:@"/user/login.action"]
#define USER_LOGIN_TYPE 5010200
//5.1.3	用户退出
//#define USERLOGOUTACTION [BASE stringByAppendingString:@"/user/logout.action"]
//#define USERLOGOUTTYPE 5010300
//5.1.4	用户修改密码
#define USER_UPDATEPASSWORD_ACTION [BASE stringByAppendingString:@"/user/updatePassword.action"]
#define USER_UPDATEPASSWORD_TYPE 5010400
//5.1.5	手机号码判断
#define USER_MOBILE_ACTION [BASE stringByAppendingString:@"/user/mobile.action"]
#define USER_MOBILE_TYPE 5010500
//5.1.6	获取短信验证码
#define USER_SMS_ACTION [BASE stringByAppendingString:@"/user/sms.action"]
#define USER_SMS_TYPE 5010600
//5.1.7	用户修改个人资料
#define USER_UPDATE_ACTION [BASE stringByAppendingString:@"/user/update.action"]
#define USER_UPDATE_TYPE 5010700
//5.1.9	获取用户信息
#define USER_DETAIL_ACTION [BASE stringByAppendingString:@"/user/detail.action"]
#define USER_DETAIL_TYPE 5010900
//5.1.10添加到收藏
#define FAVORITE_ADD_ACTION [BASE stringByAppendingString:@"/favorite/add.action"]
#define FAVORITE_ADD_TYPE 5011000
//5.1.11取消收藏
#define FAVORITE_DEL_ACTION [BASE stringByAppendingString:@"/favorite/del.action"]
#define FAVORITE_DEL_TYPE 5011100
//5.1.12按内容ID取消收藏
#define FAVORITE_DELBYGUID_ACTION [BASE stringByAppendingString:@"/favorite/delByGuid.action"]
#define FAVORITE_DELBYGUID_TYPE 5011200
//5.1.13收藏列表
#define FAVORITE_LIST_ACTION [BASE stringByAppendingString:@"/favorite/list.action"]
#define FAVORITE_LIST_TYPE 5011300
//5.1.15播放记录列表
#define PLAY_LIST_ACTION [BASE stringByAppendingString:@"/play/list.action"]
#define PLAY_LIST_TYPE 5011500
//5.1.16点卡充值
#define PAY_ADD_ACTION [BASE stringByAppendingString:@"/pay/add.action"]
#define PAY_ADD_TYPE 5011600
//5.1.17充值记录
#define PAY_LIST_ACTION [BASE stringByAppendingString:@"/pay/list.action"]
#define PAY_LIST_TYPE 5011700
//5.1.18获取当前余额
#define USER_BALANCE_ACTION [BASE stringByAppendingString:@"/user/balance.action"]
#define USER_BALANCE_TYPE 5011800
//5.1.19购买产品
//#define BUY_ADD_ACTION [BASE stringByAppendingString:@"/buy/add.action"]
//#define BUY_ADD_TYPE 5011900
//5.1.20已购买产品列表
#define BUY_LIST_ACTION [BASE stringByAppendingString:@"/buy/list.action"]
#define BUY_LIST_TYPE 5012000
//5.1.21取消播放记录
#define PLAY_DEL_ACTION [BASE stringByAppendingString:@"/play/del.action"]
#define PLAY_DEL_TYPE 5012100
//5.1.22忘记密码
#define USER_FORGETPASSWORD_ACTION [BASE stringByAppendingString:@"/user/forgetPassword.action"]
#define USER_FORGETPASSWORD_TYPE 5012200
//5.1.23清空播放记录
#define PLAY_EMPTY_ACTION [BASE stringByAppendingString:@"/play/empty.action"]
#define PLAY_EMPTY_TYPE 5012300
//5.1.24清空收藏
#define FAVORITE_EMPTY_ACTION [BASE stringByAppendingString:@"/favorite/empty.action"]
#define FAVORITE_EMPTY_TYPE 5012400
//5.1.25VIP资格列表
#define VIP_LIST_ACTION [BASE stringByAppendingString:@"/vip/list.action"]
#define VIP_LIST_TYPE 5012500
//5.1.26购买VIP资格
#define BUY_VIP_ACTION [BASE stringByAppendingString:@"/buy/vip.action"]
#define BUY_VIP_TYPE 5012600
//5.1.27用户偏好存取
#define USER_PREFERENCE_ACTION [BASE stringByAppendingString:@"/user/preference.action"]
#define USER_PREFERENCE_SET_TYPE 5012700
#define USER_PREFERENCE_GET_TYPE 5012701
//5.1.28上传用户头像
//#define USER_UPDATEAVATAR_ACTION [BASE stringByAppendingString:@"/user/updateAvatar.action"]
//#define USER_UPDATEAVATAR_TYPE 5012800
//5.1.29用户观看时长
#define USER_PLAYTIME_ACTION [BASE stringByAppendingString:@"/user/playTime.action"]
#define USER_PLAYTIME_TYPE 5012900
//5.1.30获取账户信息
#define USER_ACCOUNT_ACTION [BASE stringByAppendingString:@"/user/account.action"]
#define USER_ACCOUNT_TYPE 5013000
//5.1.31免注册登陆
#define ANONYMOUS_LOGIN_ACTION [BASE stringByAppendingString:@"/anonymous/login.action"]
#define ANONYMOUS_LOGIN_TYPE 5013100
//5.2.7	首页初始化-mobile(v2.4)
#define INDEX_FEATUREDHOME_ACTION [BASE stringByAppendingString:@"/index/featuredHome.action"]
#define INDEX_FEATUREDHOME_TYPE 5020700
//5.3.5	频道内容列表(v2.3)
//#define CHANNEL_CONTENTLIST_ACTION [BASE stringByAppendingString:@"/channel/contentList.action"]
//#define CHANNEL_CONTENTLIST_TYPE 5030500
//5.3.6	频道分类列表
#define CHANNEL_CATEGORYLIST_ACTION [BASE stringByAppendingString:@"/channel/categoryList.action"]
#define CHANNEL_CATEGORYLIST_TYPE 5030600
//5.3.7	频道猫全部内容列表
#define CHANNEL_CATCONTENTLIST_ACTION [BASE stringByAppendingString:@"/channel/catContentList.action"]
#define CHANNEL_CATCONTENTLIST_TYPE 5030700
//5.4.2	播放视频
#define PRODUCT_PLAY_ACTION [BASE stringByAppendingString:@"/product/play.action"]
#define PRODUCT_PLAY_TYPE 5040200
//5.5.7	剧集内容列表
#define CONTENT_EPISODEITEMLIST_ACTION [BASE stringByAppendingString:@"/content/episodeItemList.action"]
#define CONTENT_EPISODEITEMLIST_TYPE 5050700
//5.6.1	设备绑定
#define DEVICES_BIND_ACTION [BASE stringByAppendingString:@"/devices/bind.action"]
#define DEVICES_BIND_TYPE 5060100
//5.10.2.1	手机移动快捷支付
#define ALIPAY_PREPARESECUREPAY_ACTION [BASE stringByAppendingString:@"/alipay/prepareSecurePay.action"]
#define ALIPAY_PREPARESECUREPAY_TYPE 5100201
//5.10.3	交易状态查询
#define ALIPAY_QRCODETRADERESULT_ACTION [BASE stringByAppendingString:@"/alipay/singleTradeQuery.action"]
#define ALIPAY_QRCODETRADERESULT_TYPE 5100301

#define ALIPAY_TRADERESULT_ACTION [BASE stringByAppendingString:@"/alipay/tradeResult.action"]
#define ALIPAY_TRADERESULT_TYPE 5100401


#define ALIPAYTRADERESULT_TYPE 10035
//5.10.2.4  二维码支付
#define TWODIMENSION_CODE_ACTION  [BASE stringByAppendingString:@"/alipay/qrCodeGen.action"]
#define TWODIMENSION_CODE_TYPE 5100300
//
//zjj

#define MANETIONCOLOL @"f0464e"
#define DISCOLOL @"519ea4"

#define CHECK_RETURN_CELL(a,b) do{if (!(a)) {NSLog(@"%s第%u行越界！",__FILE__,__LINE__); return b;};}while(0)
#define CHECK_NONERETURN(a) do{if (!(a)) {NSLog(@"%s第%u行越界！",__FILE__,__LINE__); return;};}while(0)


#define HEADVIEW_TITLESIZE 20
#define HEADVIEW_TITLE_ALPHA 0.8
#define HEADVIEW_BACKGROUND_COLOR @"323232"
#define LINEVIEW_COLOR @"c2c2c2"
#define INDICATOR_COLOR @"c3c3c3"

#define color_1 [Commonality colorFromHexRGB:@"1ea2cc"];
#define color_2 [Commonality colorFromHexRGB:@"058cb9"]
#define color_3 [Commonality colorFromHexRGB:@"1e9bc2"]
#define color_4 [Commonality colorFromHexRGB:@"ff5b5b"]
#define color_5 [Commonality colorFromHexRGB:@"e1b126"]
#define color_6 [Commonality colorFromHexRGB:@"09aae6"]
#define color_7 [Commonality colorFromHexRGB:@"79bb4c"]
#define color_8 [Commonality colorFromHexRGB:@"e490ab"]
#define color_9 [Commonality colorFromHexRGB:@"d26582"]
#define color_10 [Commonality colorFromHexRGB:@"05a6c2"]
#define color_11 [Commonality colorFromHexRGB:@"eac1a5"]
#define color_12 [Commonality colorFromHexRGB:@"3dbbdd"]
#define color_13 [Commonality colorFromHexRGB:@"f0f0f0"]
#define color_14 [Commonality colorFromHexRGB:@"ffffff"]
#define color_15 [Commonality colorFromHexRGB:@"000000"]
#define color_16 [Commonality colorFromHexRGB:@"ef3463"]
#define color_17 [Commonality colorFromHexRGB:@"a2bfca"]
#define color_18 [Commonality colorFromHexRGB:@"d2e9ef"]
#define color_19 [Commonality colorFromHexRGB:@"f0f6f8"]
#define color_20 [Commonality colorFromHexRGB:@"7eb9cc"]
#define color_21 [Commonality colorFromHexRGB:@"f1f9fb"]
#define color_22 [Commonality colorFromHexRGB:@"f0f5f8"]
#define color_23 [Commonality colorFromHexRGB:@"43bde5"]

#define font_1 [UIFont boldSystemFontOfSize:10]
#define font_2 [UIFont boldSystemFontOfSize:12]
#define font_3 [UIFont boldSystemFontOfSize:13]
#define font_4 [UIFont boldSystemFontOfSize:14]
#define font_5 [UIFont boldSystemFontOfSize:15]
#define font_6 [UIFont boldSystemFontOfSize:17]
#define font_7 [UIFont boldSystemFontOfSize:20]
#define font_8 [UIFont boldSystemFontOfSize:22]
#define font_9 [UIFont boldSystemFontOfSize:28]

#define alpha_1 0.2
#define alpha_2 0.3
#define alpha_3 0.6
#define alpha_4 0.8



//zjj
#define NSNotificationCenterUserImage               @"NSNotificationCenterUserImage"
#define NSNotificationCenterUserInfo                @"NSNotificationCenterUserInfo"
#define NSNotificationCenterLoginInSuccess          @"NSNotificationCenterLoginInSuccess"
#define NSNotificationCenterAfterLoginInSuccess          @"NSNotificationCenterAfterLoginInSuccess"
#define NSNotificationCenterRegisterInSuccess          @"NSNotificationCenterRegisterInSuccess"
#define NSNotificationCenterExitFromDMC             @"NSNotificationCenterExitFromDMC"
#define NSNotificationCenterPushAutoLogin           @"NSNotificationCenterPushAutoLogin"
#define NSNotificationCenterPushEpisode             @"NSNotificationCenterPushEpisode"
#define NSNotificationCenterPushTrial               @"NSNotificationCenterPushTrial"
#define NSNotificationCenterPushSubscribe           @"NSNotificationCenterPushSubscribe"
#define NSNotificationCenterUserBalanceChange       @"NSNotificationCenterUserBalanceChange"
#define NSNotificationCenterPayAlipayResult         @"NSNotificationCenterPayAlipayResult"
#define NSNotificationCenterPurchaseSuccessViewJump @"NSNotificationCenterPurchaseSuccessViewJump"
//zjj


//mjh
#define RATIO (iPad?1:0.6)
//mjh
