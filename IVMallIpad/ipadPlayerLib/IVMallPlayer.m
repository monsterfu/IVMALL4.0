//
//  IVMallPlayer.m
//  IVMallPlayer
//
//  Created by SmitJh on 14-7-5.
//  Copyright (c) 2014年 MJH. All rights reserved.
//

#import "IVMallPlayer.h"
#import "YunPlayer.h"
#import "IVMallPlayerViewController.h"
#import "PlayerNavigationController.h"
#import "DMCViewController.h"

static IVMallPlayer  *sharedIVMallPlayer = nil;

@implementation IVMallPlayer
{
    IVMallPlayerViewController * myIVMallPlayerViewController;
    PlayerNavigationController * myNavi;
}

+ (IVMallPlayer *)sharedIVMallPlayer
{
    @synchronized(self)
    {
        if (sharedIVMallPlayer == nil)
        {
            sharedIVMallPlayer = [[self alloc] init];
        }
    }
    return sharedIVMallPlayer;
    
}

- (NSInteger)IVMallPlayerInit:(NSString *)DRMServer :(NSString *)reportServer{
    NSLogAny(@"\n#########   libiPadPlayer_version_1.2.11_smit_MJH_2014.6.10   #########\n");
    [[YunPlayer sharedPlayer]initWithDRMServer:DRMServer andReportServer:nil];
    [[YunPlayer sharedPlayer]DMCInit];
    return 0;
}

-(NSInteger)IVMallPlayerStart:(NSString *)url withVideoName:(NSString *)videoName withConnectionPlayProType:(connectionPlayProType)connectionType fromViewController:(UIViewController *)viewController startTime:(NSTimeInterval)time{
    if (myIVMallPlayerViewController) {
        myIVMallPlayerViewController = nil;
    }

    myIVMallPlayerViewController=[[IVMallPlayerViewController alloc]init];
    myIVMallPlayerViewController.playUrl = url;
    myIVMallPlayerViewController.videoName = videoName;
    myIVMallPlayerViewController.startTime = time;
    myIVMallPlayerViewController.connectionType = connectionType;
    
    if (myNavi) {
        myNavi = nil;
    }
    myNavi = [[PlayerNavigationController alloc]initWithRootViewController:myIVMallPlayerViewController];
    
    [viewController presentViewController:myNavi animated:YES completion:nil];
    return 0;
}

-(NSInteger)IVMallPlayerSetUrl:(NSString *)url withConnectionPlayProType:(connectionPlayProType)connectionType andVideoName:(NSString *)videoName
{
    [myIVMallPlayerViewController connectionPlayWithUrl:url withConnectionPlayProType:(connectionPlayProType)connectionType andVideoName:videoName];
    
    return 0;
}

- (NSMutableDictionary*)IVMallPlayerGetLocalInfo{
    return [[YunPlayer sharedPlayer]getLocalInfoFromPlayer];
}

-(void)backToDMCControlFromViewController:(UIViewController *)viewController
{
    [viewController presentViewController:myNavi animated:NO completion:^(void){
//        [myIVMallPlayerViewController.navigationController pushViewController:myIVMallPlayerViewController.dmcPlayVC animated:NO];
    }];
    [YunPlayer sharedPlayer].delegate = myIVMallPlayerViewController;
    [YunPlayer sharedPlayer].DMCdelegate = myIVMallPlayerViewController.dmcPlayVC;
    [[YunPlayer sharedPlayer]DMCFromAPP];
}

- (void)IVMallPlayerDestroy{
    [[YunPlayer sharedPlayer]DeInit];
    [[YunPlayer sharedPlayer]DMCDeInit];
}

@end
