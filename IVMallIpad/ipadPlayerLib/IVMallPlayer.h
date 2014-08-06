//
//  IVMallPlayer.h
//  IVMallPlayer
//
//  Created by SmitJh on 14-7-5.
//  Copyright (c) 2014年 MJH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IVMallPlayerViewController;

enum{
    PlayerWillPlaybackEnded = 0,
    PlayerUserExited = 1,
    PlayerPlaybackError = 2,
    PlayerWillReturnFromCurrentPlay = 3,
    PlayerWillReturnFromDMRPlay = 4,
};
typedef NSInteger PlayerCallBackEventType;

@protocol PlayerCallBackDelegate <NSObject>
-(void)PlayerCallBack:(PlayerCallBackEventType)callBackEventType withParameter: (NSMutableDictionary *)callBackInfo;
@end

//************************************************
@interface IVMallPlayer : NSObject

@property (weak, nonatomic)id<PlayerCallBackDelegate> delegate;

//创建单例
+ (IVMallPlayer *)sharedIVMallPlayer;

//初始化
- (NSInteger)IVMallPlayerInit:(NSString *)DRMServer :(NSString *)reportServer;

//播放
- (NSInteger)IVMallPlayerStart:(NSString *)url withVideoName:(NSString *)videoName fromViewController:(UIViewController *)viewController startTime:(NSTimeInterval)time;

//获取设备信息
- (NSMutableDictionary*)IVMallPlayerGetLocalInfo;

-(void)backToDMCControlFromViewController:(UIViewController*)viewController;
//销毁
- (void)IVMallPlayerDestroy;

@end
