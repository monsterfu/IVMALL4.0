//
//  BoxBlurImageViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxBlurImageViewController : UIViewController
@property (nonatomic, assign) CGFloat blurLevel;
- (void)createScreenshotAndLayoutWithScreenshotCompletion;
@end
