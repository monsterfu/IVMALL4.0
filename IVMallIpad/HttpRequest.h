//
//  HttpRequest.h
//  IVMall (Ipad)
//
//  Created by sean on 14-2-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface HttpRequest : NSObject


//zjj
//5.0.1	应用控制
+(void)AppConfigDelegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.0.2	点数列表
+(void)AppPointsDelegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.0.3	首次安装应用
+(void)AppInstallDelegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.0.5	获取提示信息(v4.0)
+(void)AppTipsRequestDelegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.1	用户注册
+(void)UserRegisterRequestMobile:(NSString*)mobile password:(NSString *)password checkcode:(NSString *)checkcode couponcode:(NSString *)couponcode delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.1.2	用户登录
+(void)UserLoginRequestMobile:(NSString*)mobile password:(NSString*)password delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.4	用户修改密码
+(void)UserUpdatePasswordRequestToken:(NSString*)token oldPassword:(NSString*)oldPassword onewPassword:(NSString*)newPassword delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.5	手机号码判断
+(void)UserMobileRequestMobile:(NSString*)mobile delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.6	获取短信验证码
+(void)UserSMSRequestMobile:(NSString*)mobile delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.7	用户修改个人资料
+(void)UserUpdateRequestToken:(NSString*)token nickName:(NSString*)nickname email:(NSString*)email birthday:(NSString*)birthday gender:(NSString*)gender address:(NSString*)address delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.9	获取用户信息
+(void)UserDetailRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.10添加到收藏
+(void)FavoriteAddRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.11取消收藏
+(void)FavoriteDelRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.12取消收藏（按内容ID）
+(void)FavoriteDelByGuidRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.13	收藏列表
+(void)FavoriteListRequestToken:(NSString*)token page:(int)page rows:(int)rows delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.15	播放记录列表
+(void)PlayListRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.16	点卡充值
+(void)PayAddRequestToken:(NSString*)token voucherCode:(NSString*)voucherCode password:(NSString*)password delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.17	充值记录
+(void)PayListRequestToken:(NSString*)token page:(int)page rows:(int)rows delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.18	获取当前余额
+(void)UserBalanceRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.20	已购买产品列表
+(void)BuyListRequestToken:(NSString*)token page:(int)page rows:(int)rows delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.21	取消播放记录
+(void)PlayDelRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.22	忘记密码
+(void)UserForgetPasswordRequestMobile:(NSString*)mobile validateCode:(NSString*)validateCode password:(NSString*)password delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.23	清空播放记录
+(void)PlayEmptyRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.24	清空收藏
+(void)FavoriteEmptyRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.25	VIP资格列表
+(void)VipListRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.26	购买VIP资格
+(void)BuyVipRequestToken:(NSString*)token vipGuid:(NSString*)vipGuid points:(float)points delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.27	用户偏好存取
+(void)UserPreferenceRequestToken:(NSString*)token preferenceKey:(NSString*) preferenceKey preferenceValue:(NSString*)preferenceValue delegate:delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.1.29	用户观看时长
+(void)UserPlayTimeRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.1.30	获取账户信息

//5.1.31	免注册登陆
+(void)AnonymousLoginDelegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.2.7	首页初始化-mobile(v2.4)
+(void)IndexFeaturedHomeRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.3.6	频道分类列表
+(void)ChannelCategoryListRequestDelegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.3.7	频道猫全部内容列表
+(void)ChannelCatContentListRequestToken:(NSString*)token categoryId:(NSString*)categoryId index:(int)index offset:(int)offset delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.4.2	播放视频
+(void)ProductPlayRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.5.7	剧集内容列表
+(void)ContentEpisodeItemListRequestToken:(NSString*)token contentGuid:(NSString*)contentGuid lang:(NSString*)lang  delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.6.1	设备绑定
+(void)DevicesBindRequestToken:(NSString*)token delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//5.10.2.1	手机移动快捷支付
+(void)AlipayPrepareSecurePayRequestToken:(NSString*)token price:(double)price vipGuid:(NSString*)vipGuid delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.10.3	交易状态查询
+(void)AlipayTradeResultRequestToken:(NSString*)token outTradeNo:(NSString*)outTradeNo totalFee:(double)totalFee delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;

+(void)AlipayQRCODETradeResultRequestToken:(NSString*)token outTradeNo:(NSString*)outTradeNo delegate:(id)delegate finishSel:(SEL)finishSel failSel:(SEL)failSel;
//5.10.2.4二维码
+(void)AppTwoDimensionPayToken:(NSString*)token price:(double)price vipGuid:(NSString*)vipGuid points:(double)points  delegate:(id)delegate finishSel:(SEL)finishSel  failSel:(SEL)failSel;
//二维码
//zjj




@end

