//
//  PayListModel.h
//  IVMall (Ipad)
//
//  Created by SMiT on 14-3-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayListModel : NSObject//充值记录

@property(nonatomic,assign)int result;
@property(nonatomic,strong)NSString* errorMessage;
@property(nonatomic,assign)float points;                  //  点数
@property(nonatomic,strong)NSString* type;              //	充值方式
@property(nonatomic,strong)NSString* createTime;        //	充值时间

- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray*)mList page:(int)page;
@end
