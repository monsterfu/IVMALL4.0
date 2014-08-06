//
//  PersonModel.m
//  IVMall
//
//  Created by fangfang on 13-11-6.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import "PersonModel.h"
#import "Commonality.h"
#import "Macro.h"
@implementation PersonModel
@synthesize uid;
@synthesize nickname;
@synthesize tokenid;
@synthesize mobile;
@synthesize password;
@synthesize email;
@synthesize balance;
@synthesize lang;
@synthesize sex;
@synthesize birthYear;
@synthesize result;

- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    //{"error_code":"0","error_msg":"成功","data":{"nickname":"小小","email":"a@a.a","lang":"china","birthYear":"1980","gender":"M","balance":"1000"}}
    if (self = [super init])
    {
        NSLog(@"json=%@",dictionary);
        result=[[dictionary objectForKey:@"errorCode"]intValue];
        if (result==0) {
            NSDictionary* data=[dictionary objectForKey:@"data"];
            if (data) {
                nickname=[data objectForKey:@"nickname"];
                email=[data objectForKey:@"email"];
                lang=[data objectForKey:@"lang"];
                birthYear=[data objectForKey:@"birthday"];
                sex=[data objectForKey:@"gender"];
                balance=[data objectForKey:@"balance"];
                _address=[data objectForKey:@"address"];
                _imgString=[data objectForKey:@"userImg"];
                
                _vipExpiryTime = [data objectForKey:@"vipExpiryTime"];
                NSString* temp = [data objectForKey:@"vipExpiryTip"];
                if (temp && [temp isEqualToString:@"true"]) {
                    _vipExpiryTip = YES;
                }else{
                    _vipExpiryTip = NO;
                }
            }
        }
    }else{
        result=-1;
    }

    return self;
}


@end
