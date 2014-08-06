//
//  ProductInfoModel.h
//  IVMall (Ipad)
//
//  Created by  周传森 on 14-3-12.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfoModel : NSObject
{
    CGFloat point;
}
@property (nonatomic, assign) int result;
@property (nonatomic, strong) NSString * errorMessage;
@property (nonatomic, strong) NSString * productGuid;
@property (nonatomic, strong) NSString * productTitle;
@property (nonatomic, strong) NSString * productDescription;
@property (nonatomic, strong) NSString * productImg;
@property (nonatomic, strong) NSString * points;
@property (nonatomic, strong) NSString * playCount;
@property (nonatomic, strong) NSString * favoriteCount;
@property (nonatomic, strong) NSString * isCollect;
- (id)initWithDictionary:(NSDictionary *)dictionary modelList:(NSMutableArray*)mList page:(int)page;
@end
