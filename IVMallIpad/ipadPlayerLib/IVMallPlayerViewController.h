//
//  IVMallPlayerViewController.h
//  player4IVMall
//
//  Created by SmitJh on 14-7-4.
//  Copyright (c) 2014年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPlayer.h"
#import "DMCViewController.h"
#import "IVMallPlayer.h"

enum {
    PlayerCurrentPlay = 0,
    PlayerDmrDevicePlay = 1
};
typedef NSInteger PlayerMode;

@interface IVMallPlayerViewController : UIViewController<UIGestureRecognizerDelegate,YunPlayerCallBackDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    //    UIAlertView *myAlert;
}

@property (nonatomic, strong)NSString *playUrl;
@property (nonatomic, strong)NSString *videoName;
@property ()NSTimeInterval startTime;
@property ()connectionPlayProType connectionType;

@property (nonatomic, strong)DMCViewController* dmcPlayVC;


-(void)connectionPlayWithUrl:(NSString *)url withConnectionPlayProType:(connectionPlayProType)connectionType andVideoName:(NSString *)videoName;

@end
