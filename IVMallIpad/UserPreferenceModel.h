//
//  UserPreferenceModel.h
//  IVMallHD
//
//  Created by  周传森 on 14-4-23.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreferenceModel : NSObject
@property(nonatomic,assign)int errorCode;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,strong)NSString* preferenceKey;
@property(nonatomic,strong)NSString* preferenceValue;
-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
