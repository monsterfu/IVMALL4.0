//
//  AdListModel.h
//  IVMallHD
//
//  Created by  周传森 on 14-5-19.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdListModel : NSObject
@property(nonatomic,strong)NSString* adType;
@property(nonatomic,strong)NSString* adGuid;
@property(nonatomic,strong)NSString* adTitle;
@property(nonatomic,strong)NSString* adImg;
@property(nonatomic,strong)NSString* adAnchor;
@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
-(id)initWithDictionary:(NSDictionary *)dictionary withArr:(NSMutableArray *)adListArr;
@end
