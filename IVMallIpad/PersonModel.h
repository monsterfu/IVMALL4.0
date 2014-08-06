//
//  PersonModel.h
//  IVMall
//
//  Created by fangfang on 13-11-6.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject{
    NSString* uid;
    NSString* tokenid;
    NSString* nickname;
    NSString* mobile;
    NSString* password;
    NSString* lang;
    NSString* email;
    NSString* birthYear;
    NSString* balance;
    NSString* sex;
    int result;
}
@property (nonatomic,strong) NSString* uid;
@property (nonatomic,strong) NSString* tokenid;
@property (nonatomic,strong) NSString* nickname;
@property (nonatomic,strong) NSString* mobile;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* lang;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* birthYear;
@property (nonatomic,strong) NSString* balance;
@property (nonatomic,strong) NSString* sex;
@property (nonatomic,assign) int result;
@property (nonatomic,strong)NSString*address;
@property (nonatomic,strong)NSString*imgString;

@property(nonatomic,strong)NSString* vipExpiryTime;
@property(nonatomic,assign)BOOL vipExpiryTip;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
