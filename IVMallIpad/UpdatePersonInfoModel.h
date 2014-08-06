//
//  UpdatePersonInfoModel.h
//  IVMall
//
//  Created by fangfang on 13-11-21.
//  Copyright (c) 2013年 www.smit.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdatePersonInfoModel : NSObject{
    int result;
}
@property (nonatomic,assign) int result;

- (id)initWithDictionary:(NSDictionary *)dictionary;



@end
