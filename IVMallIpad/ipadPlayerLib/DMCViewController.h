//
//  DMCViewController.h
//  IVMallPlayer
//
//  Created by SmitJh on 14-7-12.
//  Copyright (c) 2014年 MJH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPlayer.h"
#import "IVMallPlayer.h"

@interface DMCViewController : UIViewController<DMCCallBackDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong)NSString* videoName;
@property (nonatomic, strong)NSString* url;
@property()NSTimeInterval startTime;

@end
