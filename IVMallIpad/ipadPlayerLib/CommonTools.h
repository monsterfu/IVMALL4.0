//
//  CommonTools.h
//  player4IVMall
//
//  Created by SmitJh on 14-7-4.
//  Copyright (c) 2014年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonTools : NSObject

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

+ (UIImage *) nSBundleSetImage:(NSString *) imageString;

+ (NSString*)timeToString:(NSTimeInterval)time;

+ (NSString *)Model;

+ (BOOL)isIPhone;//return NO if iPad

+ (UIImage *) imageFromColor:(UIColor *)color forButton:(UIButton *)btn;
@end