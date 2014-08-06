//
//  WiFiSetUp.h
//  WiFiSetUp
//
//  Created by SmitJh on 14-7-8.
//  Copyright (c) 2014年 MJH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WiFiSetUp : NSObject
//单例创建
+ (WiFiSetUp*)sharedInstance;
//- (void)wifiSetUpStartwithViewController:(UIViewController*)ViewController :(BOOL)isFirstTime;
- (void)wifiSetUpStartwithViewController:(UIViewController*)ViewController;
@end
