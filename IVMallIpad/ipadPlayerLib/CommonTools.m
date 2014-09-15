//
//  CommonTools.m
//  player4IVMall
//
//  Created by SmitJh on 14-7-4.
//  Copyright (c) 2014年 JH. All rights reserved.
//

#import "CommonTools.h"
#import "sys/utsname.h"

@implementation CommonTools

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

+ (UIImage *) nSBundleSetImage:(NSString *) imageString
{
    
    NSBundle *mainBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"IVMallPlayerBundle" ofType:@"bundle"]];
    NSString *string = [mainBundle pathForResource:imageString ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:string];    
    return image;
}

+ (NSString*)timeToString:(NSTimeInterval)time
{
    int curTime = time;
    int curhours = curTime/(60*60);
    int curmin = (curTime%(60*60))/60;//小时取余再除60秒
    int cursec = curTime%60;
    NSString* curStr = [NSString stringWithFormat:@"%02d:%02d:%02d",curhours,curmin,cursec];
    return curStr;
}

+(NSString *)Model {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    //get the device model
    
    NSString *sDeviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([sDeviceModel isEqualToString:@"i386"])      return @"Simulator";  //iPhone Simulator
    if ([sDeviceModel isEqualToString:@"iPhone1,1"]) return @"iPhone1G";   //iPhone 1G
    if ([sDeviceModel isEqualToString:@"iPhone1,2"]) return @"iPhone3G";   //iPhone 3G
    if ([sDeviceModel isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";  //iPhone 3GS
    if ([sDeviceModel isEqualToString:@"iPhone3,1"]) return @"iPhone4 AT&T";  //iPhone 4 - AT&T
    if ([sDeviceModel isEqualToString:@"iPhone3,2"]) return @"iPhone4 Other";  //iPhone 4 - Other carrier
    if ([sDeviceModel isEqualToString:@"iPhone3,3"]) return @"iPhone4";    //iPhone 4 - Other carrier
    if ([sDeviceModel isEqualToString:@"iPhone4,1"]) return @"iPhone4S";   //iPhone 4S
    if ([sDeviceModel isEqualToString:@"iPhone5,1"]) return @"iPhone5";    //iPhone 5 (GSM)
    if ([sDeviceModel isEqualToString:@"iPhone5,2"]) return @"iPhone5 (GSM+CDMA)";
    if ([sDeviceModel isEqualToString:@"iPhone5,3"]) return @"iPhone5C (GSM)";
    if ([sDeviceModel isEqualToString:@"iPhone5,4"]) return @"iPhone5C (GSM+CDMA)";
    if ([sDeviceModel isEqualToString:@"iPhone6,1"]) return @"iPhone5S (GSM)";
    if ([sDeviceModel isEqualToString:@"iPhone6,2"]) return @"iPhone5S (GSM+CDMA)";
    if ([sDeviceModel isEqualToString:@"iPod1,1"])   return @"iPod1stGen"; //iPod Touch 1G
    if ([sDeviceModel isEqualToString:@"iPod2,1"])   return @"iPod2ndGen"; //iPod Touch 2G
    if ([sDeviceModel isEqualToString:@"iPod3,1"])   return @"iPod3rdGen"; //iPod Touch 3G
    if ([sDeviceModel isEqualToString:@"iPod4,1"])   return @"iPod4thGen"; //iPod Touch 4G
    
    if ([sDeviceModel isEqualToString:@"iPad1,1"])   return @"iPadWiFi";   //iPad Wifi
    if ([sDeviceModel isEqualToString:@"iPad1,2"])   return @"iPad3G";     //iPad 3G
    if ([sDeviceModel isEqualToString:@"iPad2,1"])   return @"iPad2(WiFi)";      //iPad 2 (WiFi)
    if ([sDeviceModel isEqualToString:@"iPad2,2"])   return @"iPad2";      //iPad 2 (GSM)
    if ([sDeviceModel isEqualToString:@"iPad2,3"])   return @"iPad2(CDMA)";      //iPad 2 (CDMA)
    if ([sDeviceModel isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([sDeviceModel isEqualToString:@"iPad2,5"])   return @"iPad Mini (WiFi)";
    if ([sDeviceModel isEqualToString:@"iPad2,6"])   return @"iPad Mini";
    if ([sDeviceModel isEqualToString:@"iPad2,7"])   return @"iPad Mini (GSM+CDMA)";
    if ([sDeviceModel isEqualToString:@"iPad3,1"])   return @"iPad 3 (WiFi)";
    if ([sDeviceModel isEqualToString:@"iPad3,2"])   return @"iPad 3 (GSM+CDMA)";
    if ([sDeviceModel isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([sDeviceModel isEqualToString:@"iPad3,4"])   return @"iPad 4 (WiFi)";
    if ([sDeviceModel isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([sDeviceModel isEqualToString:@"iPad3,6"])   return @"iPad 4 (GSM+CDMA)";
    
    NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    //If a newer version exist
    if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
        if (version == 3) return @"iPhone4";
        else if (version >= 4 && version < 5) return @"iPhone4s";
        else if (version >= 5) return @"iPhone5";
    }
    if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
        if (version >=4 && version < 5) return @"iPod4thGen"; else if (version >=5) return @"iPod5thGen";
    }
    if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
        if (version ==1) return @"iPad3G";
        if (version >=2 && version < 3) return @"iPad2"; else if (version >= 3)return @"new iPad";
    }
    //If none was found, send the original string
    return sDeviceModel;
}

+ (BOOL)isIPhone
{
    if ([[self Model] hasPrefix:@"iPad"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (UIImage *)imageFromColor:(UIColor *)color forButton:(UIButton *)btn
{
    CGRect rect = CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
