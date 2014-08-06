//
//  Commonality.h
//  IVMall (Ipad)
//
//  Created by sean on 14-2-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commonality : NSObject

+ (BOOL) isEmpty:(NSString *)nsstring;

+ (void)showErrorMsg:(UIView*)view type:(int)type msg:(NSString *)msg;
+ (void)showTipsMsgWithView:(UIView*)view duration:(float)duration msg:(NSString *)msg image:(UIImage*)image;
+(int) isEnableWIFI;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+(BOOL)determineCellPhoneNumber:(NSString*)str;

+(NSString*)MD5:(NSString*)str;

+ (int)judgeDate:(NSString*)onday withday:(NSString*)withday;

+ (NSString *)SystemDate2Str;

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

+(void) setImgViewStyle:(UIView *) myView;

+ (int) judgePasswordStrength:(NSString*) _password;

+(void)anmou1View:(UIView*)view delegate:(id)delegaet;

+ (UIImage *) imageFromColor:(UIColor *)color;

+(UIView *) makeButtonShadowViewWhitbtn:(UIButton *)btn;

//zjj
+ (NSString *) Date2Str1:(NSDate *)indate;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)Date2day:(NSDate *)indate;
+ (NSString*)Date2Str4:(NSDate *)indate;
//zjj

//mjh
+(NSString *)timeToString:(int)time;

+ (NSString *) Date2Str3:(NSDate *)indate;

//mjh
@end
