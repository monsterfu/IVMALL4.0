//
//  Commonality.m
//  IVMall (Ipad)
//
//  Created by sean on 14-2-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "Commonality.h"
#import "Toast+UIView.h"
#import "Reachability.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "Macro.h"

#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation Commonality


+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 30, 30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL) isEmpty:(NSString *)nsstring{
    if(nsstring){
        if(nsstring.length>0){
            if(![nsstring isEqualToString:@"null"]){
                return false;
            }
        }
    }
    return true;
}

+(BOOL)determineCellPhoneNumber:(NSString*)str{
    return YES;
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(16[0-9])|(18[0,1,2,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}


+(int) isEnableWIFI{
    if ([[Reachability reachabilityForLocalWiFi]currentReachabilityStatus]==NotReachable) {
        return 0;
    }
    if ([[Reachability reachabilityForLocalWiFi]currentReachabilityStatus]==ReachableViaWiFi) {
        return 1;
    }
    return 2;
}
+(NSString*)MD5:(NSString*)str{
    const char *concat_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash =[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

//程序中使用的，将日期显示成  2011年4月4日 星期一
+ (NSString *) Date2Str1:(NSDate *)indate{
    
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]]; //setLocale 方法将其转为中文的日期表达
	dateFormatter.dateFormat = @"yyyy 年 MM 月 dd 日 HH:mm";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

+ (NSString *)SystemDate2Str{
    NSDate *  indate=[NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

+ (int)judgeDate:(NSString*)onday withday:(NSString*)withday{
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    [dateFromatter setDateFormat:@"yy/MM/dd"];
    NSDate *day1 = [dateFromatter dateFromString:onday];
    NSDate *day2 = [dateFromatter dateFromString:withday];
    
    NSComparisonResult result = [day1 compare:day2];
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
    
+(void)anmou1View:(UIView*)view delegate:(id)delegaet{
    [view setTransform:CGAffineTransformScale(view.transform,0,0)];
 
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:delegaet];
    [view setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:delegaet];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft  forView:view cache:YES];
    [UIView commitAnimations];

}



+ (void)showErrorMsg:(UIView*)view type:(int)type msg:(NSString *)msg{
    switch (type) {
        case 999://	未知错误
//            [view makeToast:@"出了些小问题，请联系我们客服！"
//                   duration:2.0
//                   position:@"center"];
            break;
        case 400://	缺少参数
            [view makeToast:@"缺少参数，请检查参数是否填写完全！"
                   duration:2.0
                   position:@"center"];
            break;
        case 101://	用户已存在
            [view makeToast:@"您已是我们注册用户，可以直接登录使用！"
                   duration:2.0
                   position:@"center"];
            
            break;
        case 102://	用户未存在
            [view makeToast:@"您还未注册我们用户，请注册后登录！"
                   duration:2.0
                   position:@"center"];
            break;
        case 103://	用户名/密码错误
            [view makeToast:@"手机号码或密码有误，请检查！"
                   duration:2.0
                   position:@"center"];
            break;
        case 104://	token不存在
            [view makeToast:@"您需要重新登录！"
                   duration:2.0
                   position:@"center"];
            break;
        case 105://	登录超时
            [view makeToast:@"您需要重新登录！"
                   duration:2.0
                   position:@"center"];
            break;
        case 106://	用户未登录
            [view makeToast:@"您需要登录后，才能使用此功能！"
                   duration:2.0
                   position:@"center"];
            break;
        case 107://	账户余额不足
            [view makeToast:@"您的余额不足，请充值！"
                   duration:2.0
                   position:@"center"];
            break;
        case 108:
            [view makeToast:@"注册失败！"
                   duration:2.0
                   position:@"center"];
            break;
        case 109:
            [view makeToast:@"验证码错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 110:
            [view makeToast:@"手机号码错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 111:
            [view makeToast:@"密码不符合规则！"
                   duration:2.0
                   position:@"center"];
            break;
        case 112:
            [view makeToast:@"邮箱错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 170:
            [view makeToast:@"未经许可地域"
                   duration:2.0
                   position:@"center"];
            break;
        case 175:
            [view makeToast:@"您的帐号绑定设备过多！"
                   duration:2.0
                   position:@"center"];
            break;
        case 201://	该频道不存在
            [view makeToast:@"此频道已删除，请刷新频道后继续使用！"
                   duration:2.0
                   position:@"center"];
            break;
        case 202://	该产品不存在
            [view makeToast:@"此产品已经下架！"
                   duration:2.0
                   position:@"center"];
            break;
        case 203://	该视频不存在
            [view makeToast:@"此视频已经下架！"
                   duration:2.0
                   position:@"center"];
            break;
        case 204://	未购买该产品
            [view makeToast:@"会员权限未开通或已过期！"
                   duration:2.0
                   position:@"center"];
            break;
        case 205:
            [view makeToast:@"记录已存在！"
                   duration:2.0
                   position:@"center"];
            break;
        case 206:
            [view makeToast:@"您的点卡密码错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 207:
            [view makeToast:@"JSON语法错误！"
                   duration:2.0
                   position:@"center"];
            break;
        case 208:
            [view makeToast:@"点数未定义rateDetailPointNotDefinde！"
                   duration:2.0
                   position:@"center"];
            break;
        case 209:
            [view makeToast:@"设备不存在！"
                   duration:2.0
                   position:@"center"];
            break;
        case 210:
            [view makeToast:@"验证码已过期！"
                   duration:2.0
                   position:@"center"];
            break;
        case 212:
            [view makeToast:@"该充值卡已充值过！"
                   duration:2.0
                   position:@"center"];
            break;
        case 213:
            [view makeToast:@"充值卡已过期！"
                   duration:2.0
                   position:@"center"];
            break;
        case 216:
            [view makeToast:@"您还没有会员资格哟"
                   duration:2.0
                   position:@"center"];
            break;
        case 217:
            [view makeToast:@"您购买的会员资格不存在"
                   duration:2.0
                   position:@"center"];
            break;
        case 218:
            [view makeToast:@"您的会员资格还没到期哟"
                   duration:2.0
                   position:@"center"];
            break;
        case 219:
            [view makeToast:@"您的EMail已经绑定"
                   duration:2.0
                   position:@"center"];
            break;
        case 220:
            [view makeToast:@"您查询的交易不存在"
                   duration:2.0
                   position:@"center"];
            break;
        case 222:
            [view makeToast:@"优惠码不存在"
                   duration:2.0
                   position:@"center"];
            break;
        case 307:
            [view makeToast:@"验证码不正确！"
                   duration:2.0
                   position:@"center"];
            break;
        case 0:
            [view makeToast:msg
                   duration:2.0
                   position:@"center"];
            break;
        default:
            [view makeToast:@"系统异常，请稍后再试！"
                   duration:2.0
                   position:@"center"];
            break;
    }
}

+ (void)showTipsMsgWithView:(UIView*)view duration:(float)duration msg:(NSString *)msg image:(UIImage*)image
{
//    [view makeToast:msg duration:duration position:@"center" image:image];
//    UIView *toast = [view viewForMessage:msg title:nil image:image];
//    [view showToast:toast duration:duration position:@"center"];
    UIView *toast = [[UIView alloc]init];
    [view addSubview:toast];
    toast.alpha = 0.0;
    
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = image;
    [toast addSubview:imageView];
    
    UILabel* label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = msg;
    [toast addSubview:label];
    
    if (iPad) {
        toast.frame = CGRectMake((view.frame.size.width-770)/2, (view.frame.size.height-367)/2, 770, 367);
        imageView.frame = CGRectMake(0, 0, 770, 367);
        label.frame = CGRectMake(50, 50, 670, 267);
        label.font = [UIFont boldSystemFontOfSize:24];
    }else{
        toast.frame = CGRectMake((view.frame.size.width-385)/2, (view.frame.size.height-184)/2, 385, 184);
        imageView.frame = CGRectMake(0, 0, 385, 184);
        label.frame = CGRectMake(25, 25, 335, 134);
        label.font = [UIFont boldSystemFontOfSize:20];
        
    }
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:duration
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
}

+(void) setImgViewStyle:(UIView *) myView
{
    myView.layer.borderWidth = 1;
    myView.layer.borderColor = [UIColor clearColor].CGColor;
    myView.layer.shadowOffset = CGSizeMake(0, 0);
    myView.layer.shadowRadius = 10;
    myView.layer.shadowOpacity = 0.5;
    myView.layer.shadowPath = [UIBezierPath bezierPathWithRect:myView.bounds].CGPath;
}

+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password{
    
    NSRange range;
    
    BOOL result =NO;
    
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound){
            result =YES;
        }
    }
    
    return result;
    
}


+ (int) judgePasswordStrength:(NSString*) _password{
    
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    
    
    int intResult=0;
    
    for (int j=0; j<[resultArray count]; j++){
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"]){
            intResult++;
        }
    }
    
    int resultInt=0;
    
    if (intResult <2){
        resultInt = 0;
    }else if (intResult == 2&&[_password length]>=6){
        resultInt = 1;
    }else if (intResult > 2&&[_password length]>=6){
        resultInt = 2;
    }
    
    return resultInt;
}

+(UIView *) makeButtonShadowViewWhitbtn:(UIButton *)btn
{
    UIView * backView = [[UIView alloc] initWithFrame:btn.frame];
    
    backView.layer.cornerRadius = btn.layer.cornerRadius;
//    self.layer.borderWidth = 3;
//    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    //阴影
    backView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
//    backView.layer.shadowColor = [color_18 CGColor];
    backView.layer.shadowOffset = CGSizeMake(0, 2.0f); //[水平偏移, 垂直偏移]
    backView.layer.shadowOpacity = 10.0f; // 0.0 ~ 1.0 的值
    backView.layer.shadowRadius = 1.0f; // 阴影发散的程度
    btn.frame = CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height);
    [backView addSubview:btn];
    
    return backView;
    
}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//zjj

+ (NSDate *)dateFromString:(NSString *)string
{
    NSString* temp = @"T";
    NSRange rang = [string rangeOfString:temp];
    NSString* dateString = [string stringByReplacingCharactersInRange:rang withString:@" "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:sszzzz"];
    NSDate * date= [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSDate *)Date2day:(NSDate *)indate
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy.MM.dd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return [dateFormatter dateFromString:tempstr];
}

+(NSString*)Date2Str4:(NSDate *)indate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy.MM.dd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

//zjj

//mjh
+(NSString *)timeToString:(int)time
{
    int hour = time/3600;
    int min = (time-time/3600*3600)/60;
    return [NSString stringWithFormat:@"%d小时%d分钟",hour,min];
}

+ (NSString *) Date2Str3:(NSDate *)indate{
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}
//mjh

//Monster
+ (NSString *)sha1:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    int i =0;
    int len = strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}
//Monster
@end
