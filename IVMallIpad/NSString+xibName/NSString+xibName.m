//
//  NSString+xibName.m
//  IVMallHD
//
//  Created by Monster on 14-7-22.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "NSString+xibName.h"
#import "Macro.h"

@implementation NSString (xibName)
+(NSString*)xibName:(NSString*)xib
{
    if (iPad) {
        return [NSString stringWithFormat:@"%@",xib];
    }else{
        return [NSString stringWithFormat:@"%@_IPhone",xib];
    }
}
@end
