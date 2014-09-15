//
//  Player.h
//  Player
//
//  Created by SMiT on 14-2-19.
//  Copyright (c) 2014年 jjzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ?YES :NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define LDSCREEN_SIZE_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define LDSCREEN_SIZE_HEIGHT  ([UIScreen mainScreen].bounds.size.height)
#define LDSCREEN_MEDIA_GAP (LDSCREEN_SIZE_HEIGHT/22)
#define LDSCREEN_MEDIA_X (LDSCREEN_MEDIA_GAP)
#define LDSCREEN_MEDIA_Y (LDSCREEN_MEDIA_GAP)
#define LDSCREEN_MEDIA_WIDTH (LDSCREEN_SIZE_HEIGHT - LDSCREEN_MEDIA_GAP*2)//(440)
#define LDSCREEN_MEDIA_HEIGHT  (LDSCREEN_SIZE_WIDTH - LDSCREEN_MEDIA_GAP*2)//(280)




@protocol PlayerReportDelegate <NSObject>
-(NSArray*)GetAccessLogEvents;
-(NSString*)getplayURL;
-(NSString*)getReportServer;
@end

@interface CallBackMessage : NSObject
@property (nonatomic, assign)NSInteger actionType;
@property (nonatomic, assign)NSInteger errorCode;
@property (nonatomic, assign)NSInteger para1;
@property (nonatomic, assign)NSInteger para2;
@end


@protocol DMCPlayerDelegate
-(void)handleDMCCallBackEvent:(CallBackMessage*)msg;
-(BOOL)isDMRPlayerMode;
@end


//
enum{
    YunPlayerPlaybackFinish = 0,//播放结束, parameter1返回结束原因,见YunPlayerPlaybackFinishResonEnum
    YunPlayerLoadStateDidChange,//网络加载状态发生改变,parameter1返回buffer状态，见YunPlayerLoadState
    YunPlayerPlaybackStateDidChange,//播放状态发生改变,parameter1返回播放状态，见YunPlayerPlaybackState
    YunPlayerNetWorkStatusDidChange,//网络状态发生改变，parameter1返回网络连接状态，见YunPlayerNetworkStatus
    YunPlayerNowPlayingMovieDidChange,//当前播放视频发生改变，parameter1无意义
    YunPlayerReadyForDisplay,//第一帧画面可以显示出来 只支持ios6以上，parameter1无意义
    YunPlayerPreparedToPlay,//播放器准备播放，parameter1无意义
    YunPlayerUnknow
};
typedef NSInteger YunPlayerEventEnum;

enum{
    YunPlayerFinishReasonPlaybackEnded,//播放正常结束
    YunPlayerinishReasonPlaybackError,//播放发生错误,无法进行，自动结束
    YunPlayerFinishReasonUserExited//用户手动调用stop退出
};
typedef NSInteger YunPlayerPlaybackFinishResonEnum;//YunPlayerEventEnum == YunPlayerPlaybackFinish时，parameter1返回类型

enum {
    YunPlayerLoadStatePlayable = 1,//可以播放
    YunPlayerLoadStatePlaythroughOK, //buffer数据足够，会自动播放
    YunPlayerLoadStateStalled,// buffer数据不够，会自动暂停
    YunPlayerLoadStateUnknown//未知
};
typedef NSInteger YunPlayerLoadState;//YunPlayerEventEnum == YunPlayerLoadStateDidChange时，parameter1返回类型

enum {
    YunPlayerPlaybackStateStopped = 0,//停止播放
    YunPlayerPlaybackStatePlaying, //正在播放
    YunPlayerPlaybackStatePaused,//暂停播放
    YunPlayerPlaybackStateInterrupted,//中断播放
    YunPlayerPlaybackStateSeekingForward,//向前seek
    YunPlayerPlaybackStateSeekingBackward//向后seek
};
typedef NSInteger YunPlayerPlaybackState;//YunPlayerEventEnum == YunPlayerPlaybackStateDidChange时，parameter1返回类型


enum
{
	NetworkNotReachable     = 0,//网络未连接
	NetworkReachableViaWiFi = 2,//网络通过wifi连接
	NetworkReachableViaWWAN = 1,//网络通过3g连接
    NetworkReachableVia2G = 3,//网络通过2g连接
    NetworkReachableViaWifiNoNet = 4//网络连上wifi，未连接互联网
};
typedef NSInteger YunPlayerNetworkStatus;//YunPlayerEventEnum == YunPlayerNetWorkStatusDidChange时，parameter1返回类型

//DMC callback
enum{
    ACTION_REFRESH=0,//刷新设备，有新设备增加或减少都会callback通知,dmr的回应通过callback的errorCode返回
    ACTION_OPNEURL,//1设置url给dmr,dmr的回应通过callback的errorCode返回
    ACTION_PLAY,//2控制dmr播放，dmr的回应通过callback的errorCode返回
    ACTION_STOP,//3停止dmr播放，dmr的回应通过callback的errorcode返回
    ACTION_PAUSE,//4暂停dmr播放，dmr的回应通过callback的errorcode返回
    ACTION_SEEK,//5设置dmr的播放时间位置，dmr的回应通过callback的errorcode返回
    ACTION_GETVOLUME,//6获取dmr音量，dmr的回应通过callback的errorcode返回，parameter1返回dmr音量
    ACTION_SETVOLUME,//7设置dmr音量，dmr的回应通过callback的errorcode返回，
    ACTION_GETPOSITON,//8获取dmr播放器位置信息，dmr的回应通过callback的errorcode返回，parameter1 ,parameter2返回当前时间/总时间
    ACTION_GETTRANSPORTINFO,//9获取dmr传输状态，dmr的回应通过callback的errorcode返回，parameter1返回传输状态DMCPlayStateEnum
    ACTION_UNKNOWN
};
typedef NSInteger DMCActionTypeEnum;
enum{
    ERROR_OK=0,
    ERROR_MIMETYPE=714,
    ERROR_CONTENTBUSY=715,
    ERROR_RESNOTFOUND=716,
    ERROR_INVAIDINSTANCEID=718,
    ERROR_DRMERROR=719,
    ERROR_EXPIREDCONTENT=720,
    ERROR_DEVICEAUTH=724
};
typedef NSInteger DMCErrorCodeEnum;

enum{ //传输状态
	PLAYSTATE_PLAYING=0,//正在播放
	PLAYSTATE_STOPPED=1, //停止播放
	PLAYSTATE_PAUSED=2, //暂停
	PLAYSTATE_RECORDING,//正在录制
	PLAYSTATE_TRANSITIONING,//正在缓冲正在传送
	PLAYSTATE_NO_MEDIA,//没有媒体文件
	PLAYSTATE_UNKNOWN //不知道
};
typedef NSInteger DMCPlayStateEnum;

enum{ //清晰度
	DEFINITIONAUTO=0,//自动
	DEFINITIONNORMAL=1, //普通
	DEFINITIONFINE=2, //高清
	DEFINITIONPERFECT=3,//超清
};
typedef NSInteger definition;

typedef NSUInteger definitionValid;


@protocol YunPlayerCallBackDelegate
@required
-(void)handlePlayerCallBackEvent:(YunPlayerEventEnum)eventType firstParameter:(NSInteger)parameter1;
//dmc callback 事件返回
-(BOOL)isAlertViewOn; //用于判断是否存在弹出框
@end

@protocol DMCCallBackDelegate <NSObject>
-(BOOL)getPlayerMode; //用于获取当前播放mode：currentPlay or DMRPlay
-(void)handleDMCCallbackWithActionType:(DMCActionTypeEnum)actionType errorCode:(DMCErrorCodeEnum)errorCode firstParameter:(NSInteger)parameter1 secondParameter:(NSInteger)parameter2;
@end




@interface YunPlayer : NSObject<PlayerReportDelegate, DMCPlayerDelegate>

@property(nonatomic,assign)id<YunPlayerCallBackDelegate> delegate;
@property(nonatomic,assign)id<DMCCallBackDelegate>DMCdelegate;

//单例创建
+ (YunPlayer*)sharedPlayer;

//初始化播放环境
- (void)initWithDRMServer:(NSString*) DRMServer andReportServer:(NSString *)reportServer;

//获取手机播放器本地信息字典
/*
 该字典对应键如下
 appVersion
 deviceDRMId
 deviceGroup
 deviceVersion
 drmType
 macAddr
 model
 osVersion
 protocol
 seiralNo
 */
- (NSMutableDictionary*)getLocalInfoFromPlayer;

//设置用于显示媒体视频的页面
- (void)setDisplayOnView:(UIViewController*)viewController;

//设置多媒体的数据源
- (definitionValid)setDataSource:(NSString *)url;

//设置清晰度
- (void)setDefinition:(definition)defi;

//设置播放起始时间
- (void)setInitialPlaybackTime:(NSTimeInterval)historyTime;

//开始或继续播放
- (void)start;

//暂停播放
- (void)pause;

//停止播放
- (void)stop;

//设置全屏 投屏播放时无效
- (void)setScreenOnWhilePlaying:(BOOL)screen;

//获取视屏的宽和高
- (CGSize)getMovieNaturalSize;

// 检测视频是否正在播放
- (BOOL)isPlaying;

//设置到指定时间位置播放
- (void)seekTo:(NSTimeInterval)time;

//获取当前播放位置
- (NSTimeInterval)getCurrentPosition;

//获取多媒体总时间
- (NSTimeInterval)getDuration;

//释放播放器
- (void)removeYunPlayer;

//0.0 - 1.0
//获取音量
- (float)getVolume;

//设置音量
- (void)setVolume:(float)volume;

//获取缓冲时下载速度
- (long long int)getDownloadSpeedBytes;

//反初始化
- (void)DeInit;



//dmc 初始化
-(void)DMCInit; //只用初始化一次

//获取设备列表
//该数组元素为一个字典
/*
 字典对应键如下
 name DMR名称
 uuid DMRID
 */
-(NSMutableArray*)DMCRefresh;

//投屏 uuid为选中DMRID，url为播放链接
-(void)DMCPush:(NSString*)uuid WithURL:(NSString*)url;

//dmc 开始或继续播放
-(void)DMCPlay;

//dmc 暂停
-(void)DMCPause;

//dmc 设置到指定时间位置播放
-(void)DMCSeekToTime:(NSTimeInterval)time;

//dmc 停止
-(void)DMCStop;

//0-100
//dmc 获取音量
-(void)DMCGetVolume;

//dmc 设置音量
-(void)DMCSetVolume:(int)value;

//获取播放视频当前时间和总时间，在handleDMCCallBackEvent里返回。
-(void)DMCGetPosition;
-(void)DMCGetTransInfo;

//自定义控制
-(void)DMCSetExtAction:(NSString *)data forKey:(NSString *)key;

//dmc 释放
-(void)DMCDeInit;

//resume apps
-(void)DMCToAPP;
-(void)DMCFromAPP;

@end
